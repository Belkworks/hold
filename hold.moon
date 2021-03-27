-- hold.moon
-- SFZILabs 2021

class Cache
    new: (@DefaultTTL = 60*10) =>
        @data = {}

    setDefaultTTL: (Value) =>
        Number = tonumber Default
        assert Number, 'setDefaultTTL expects a number!'
        @DefaultTTL = Value

    set: (Key, Value, TTL = @DefaultTTL) =>
        if Value == nil and @has Key
            return @del Key

        @data[Key] = {
            time: os.time! + TTL
            value: Value
        }

    _expire: (Key) => @data[Key] = nil -- Why are these separate?
    del: (Key) => @data[Key] = nil -- So you can extend Cache!

    has: (Key) =>
        if E = @data[Key]
            return true if E.time > os.time!
            @_expire Key

        false

    get: (Key) =>
        return unless @has Key
        @data[Key].value

    take: (Key) => -- get and set
        return unless @has Key
        Value = @get Key
        @del Key
        Value

    clean: =>
        now = os.time!
        @_expire i for i, k in pairs @data when k.time > now

    keys: => [k for k in pairs @data when @has k]

    ttl: (Key, TTL = @DefaultTTL) =>
        return false unless @has Key
        return @expire Key if TTL <= 0
        @data[Key].time = os.time! + TTL

    -- Multiple
    mget: (Keys) => {K, @get K for K in *Keys}
    mset: (Map, TTL) => @set K, V, TTL for K, V in pairs Map

    -- Advanced
    fetch: (Key, Getter, TTL) =>
        if @has Key
            return @get Key

        Value = Getter!
        @set Key, Value, TTL
        Value

    run: (Key, Fn) =>
        return unless @has Key
        Fn @get Key
