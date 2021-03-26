-- hold.moon
-- SFZILabs 2021

class Cache
	data = {}

	new: (@DefaultTTL) =>
	clean: =>
	get: (Key) =>
	has: (Key) =>
	del: (Key) =>
	keys: =>
	ttl: (Key, TTL = @DefaultTTL) =>
	take: (Key) => -- get and set
	set: (Key, Value, TTL = @DefaultTTL) =>
