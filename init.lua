local Cache
do
  local _class_0
  local _base_0 = {
    setDefaultTTL = function(self, Value)
      local Number = tonumber(Default)
      assert(Number, 'setDefaultTTL expects a number!')
      self.DefaultTTL = Value
    end,
    set = function(self, Key, Value, TTL)
      if TTL == nil then
        TTL = self.DefaultTTL
      end
      if Value == nil and self:has(Key) then
        return self:del(Key)
      end
      self.data[Key] = {
        time = os.time() + TTL,
        value = Value
      }
    end,
    _expire = function(self, Key)
      self.data[Key] = nil
    end,
    del = function(self, Key)
      self.data[Key] = nil
    end,
    has = function(self, Key)
      do
        local E = self.data[Key]
        if E then
          if E.time > os.time() then
            return true
          end
          self:_expire(Key)
        end
      end
      return false
    end,
    get = function(self, Key)
      if not (self:has(Key)) then
        return 
      end
      return self.data[Key].value
    end,
    take = function(self, Key)
      if not (self:has(Key)) then
        return 
      end
      local Value = self:get(Key)
      self:del(Key)
      return Value
    end,
    clean = function(self)
      local now = os.time()
      for i, k in pairs(self.data) do
        if k.time > now then
          self:_expire(i)
        end
      end
    end,
    keys = function(self)
      local _accum_0 = { }
      local _len_0 = 1
      for k in pairs(self.data) do
        if self:has(k) then
          _accum_0[_len_0] = k
          _len_0 = _len_0 + 1
        end
      end
      return _accum_0
    end,
    ttl = function(self, Key, TTL)
      if TTL == nil then
        TTL = self.DefaultTTL
      end
      if not (self:has(Key)) then
        return false
      end
      if TTL <= 0 then
        return self:expire(Key)
      end
      self.data[Key].time = os.time() + TTL
    end,
    mget = function(self, Keys)
      local _tbl_0 = { }
      for _index_0 = 1, #Keys do
        local K = Keys[_index_0]
        _tbl_0[K] = self:get(K)
      end
      return _tbl_0
    end,
    mset = function(self, Map, TTL)
      for K, V in pairs(Map) do
        self:set(K, V, TTL)
      end
    end,
    fetch = function(self, Key, Getter, TTL)
      if self:has(Key) then
        return self:get(Key)
      end
      local Value = Getter()
      self:set(Key, Value, TTL)
      return Value
    end,
    run = function(self, Key, Fn)
      if not (self:has(Key)) then
        return 
      end
      return Fn(self:get(Key))
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, DefaultTTL)
      if DefaultTTL == nil then
        DefaultTTL = 60 * 10
      end
      self.DefaultTTL = DefaultTTL
      self.data = { }
    end,
    __base = _base_0,
    __name = "Cache"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Cache = _class_0
  return _class_0
end
