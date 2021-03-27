
# hold
*A simple caching mechanism in MoonScript*

**Importing with [Neon](https://github.com/Belkworks/NEON)**:
```lua
Cache = NEON:github('belkworks', 'hold')
```

## API

### Creating a cache

To create a cache, call **Cache**.  
The TTL defaults to 10 minutes (600 seconds).  
`Cache(default TTL in seconds) -> Cache`
```lua
cache = Cache()
-- or,
cache2 = Cache(2 * 60) -- 2 minute cache
```

### Cache operations

**set**: `cache:set(key, value, [TTL]) -> nil`  
Sets the value at `key` to `value`.  
`TTL` defaults to the cache's TTL.  
Calling **set** with a nil `value` will redirect to `cache:del(key)`
```lua
cache:set('hello', 'world') -- `world` cached for 10 minutes
cache:set('test', 123, 2 * 60) -- 123 cached for 2 minutes
```

**get**: `cache:get(key) -> value?`  
Returns the value at `key` if it exists, or `nil`.
```lua
cache:get('hello') -- world
cache:get('asdf') -- nil
```

**del**: `cache:del(key) -> nil`  
Deletes the value at `key`.  
Will NOT throw an error if no value at `key`.
```lua
cache:del('test') -- nil
cache:del('asdf') -- nil
```

**take**: `cache:take(key) -> value?`  
Fetches and then deletes the value at `key`.  
Returns the value that was at `key`, or `nil`.
```lua
cache:take('hello') -- world
cache:has('hello') -- false
```

**ttl**: `cache:ttl(key, time) -> boolean`  
Changes the TTL on a key.  
Returns `true` if the key was found and changed, otherwise `false`.
```lua
cache:ttl('hello', 20) -- 'hello' will expire in 20 seconds
-- (unless another set call occurs)
```

**mset**: `cache:mset(map) -> nil`  
Set multiple key-value pairs at once.
```lua
cache:mset({hello='world', test=123})
```

**mget**: `cache:mget([keys]) -> map`  
Get multiple keys at once
```lua
cache:mget({'hello', 'test'}) -- {hello='world', test=123}
```

**fetch**: `cache:fetch(key, getter, TTL, ...args) -> value`  
If a value at `key` already exists, it is returned.  
Otherwise, `getter` is called, and its return value is set to `key` and returned.  
`getter` is called with `(key, ...args)`.
```lua
cache:fetch('foo', function(k) return k..'bar' end) -- 'foobar'
```

### Utilities

**clean**: `cache:clean() -> nil`  
Perform an expiry pass over the cache.  
In this cache implementation, keys are cleaned on access.  
Consider calling **clean** periodically in a production environment.
```lua
cache:clean() -- deletes extant keys
```

**setDefaultTTL**: `cache:setDefaultTTL(time in seconds) -> nil`  
Sets the default TTL for the cache.
```lua
cache:setDefaultTTL(60 * 4) -- default ttl is now 4 minutes
```

**has**: `cache:has(key) -> boolean`  
Returns true if a value at `key` exists.
```lua
cache:has('hello') -- true
cache:has('asdf') -- false
```

**keys**: `cache:keys() -> array`  
Returns an array of keys that have values in the cache.
```lua
cache:set('hello', 'world')
cache:keys() -- ['hello']
```

**run**: `cache:run(key, fn) -> value`  
If there is a value at `key`, `fn` is executed.  
`fn` is called with `(value, key)`.
```lua
cache:run('hello', function(v) print(v) end) -- prints 'world'
```
