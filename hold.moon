-- hold.moon
-- SFZILabs 2021

class Cache
	new: (@DefaultTTL = 60*10) =>
		@data = {}

	set: (Key, Value, TTL = @DefaultTTL) =>
		@data[Key] = {
			time: os.time! + TTL
			value: Value
		}

	expire: (Key) => @data[Key] = nil -- Why are these separate?
	del: (Key) => @data[Key] = nil -- So you can extend Cache!

	has: (Key) =>
		if E = @data[Key]
			return true if E.time > os.time!
			@expire Key

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
		@expire i for i, k in pairs @data when k.time > now

	keys: => [k for k in pairs @data when @has k]

	ttl: (Key, TTL = @DefaultTTL) =>
		return false unless @has Key
		return @expire Key if TTL < 0
		@data[Key].time = os.time! + TTL

	-- Multiple
	mget: (Keys) => {K, @get K for K in *Keys}
	mset: (Keys, TTL) => {K, @set K, V, TTL for K, V in pairs Keys}
