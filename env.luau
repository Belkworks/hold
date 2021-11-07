type Cache = {
	set: (key: string, value: any, ttl: number?) -> nil,
	del: (key: string) -> boolean,
	has: (key: string) -> boolean,
	get: (key: string) -> any?,
	take: (key: string) -> any?,
	clean: () -> nil,
	keys: () -> {string},
	ttl: (key: string, ttl: number) -> boolean,
	mget: (keys: {string}) -> { [string]: any },
	mtake: (keys: {string}) -> { [string]: any },
	mset: (keys: { [string]: any }, ttl: number?) -> nil,
	fetch: (key: string, getter: function, ttl: number?, ...) -> any,
	run: (key: string, callback: function) -> nil,
	getState: () -> { [string]: any },
	setState: (state: { [string]: any }) -> nil
}

type PKG = () -> Cache
