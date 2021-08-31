-- hold.moon
-- SFZILabs 2021

TenMinutes = 60*10

class Cache
    new: (DefaultTTL, @data = {}) =>
        assert ('table' == type @data),
            'cache: constructor expects a table for arg#2!'

        @TimeSource = os.time
        @setDefaultTTL DefaultTTL or TenMinutes

    setTimeSource: (@TimeSource) =>
    setDefaultTTL: (Value) =>
        Number = tonumber Value
        assert Number, 'setDefaultTTL expects a number!'
        @DefaultTTL = Number

    set: (Key, Value, TTL = @DefaultTTL) =>
        if Value == nil
            @del Key if @has Key
            return

        @data[Key] = {
            time: @TimeSource! + TTL
            value: Value
        }

    _expire: (Key) => @data[Key] = nil -- Why are these separate?
    del: (Key) => @data[Key] = nil -- So you can extend Cache!

    has: (Key) =>
        if E = @data[Key]
            return true if E.time > @TimeSource!
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
        now = @TimeSource!
        @_expire i for i, k in pairs @data when k.time > now

    keys: => [k for k in pairs @data when @has k]

    ttl: (Key, TTL = @DefaultTTL) =>
        return false unless @has Key
        if TTL <= 0
            @expire Key
            return true

        @data[Key].time = @TimeSource! + TTL
        true

    -- Multiple
    mget: (Keys) => {K, @get K for K in *Keys}
    mtake: (Keys) => {K, @take K for K in *Keys}
    mset: (Map, TTL) => @set K, V, TTL for K, V in pairs Map

    -- Advanced
    fetch: (Key, Getter, TTL, ...) =>
        if @has Key
            return @get Key

        Value = Getter Key, ...
        @set Key, Value, TTL
        Value

    run: (Key, Fn) =>
        if Value = @get Key
            Fn Value, Key

    getState: => @data
    setState: (@data) =>
