local Cache
do
  local _class_0
  local _base_0 = {
    set = function(self, Key, Value, TTL)
      if TTL == nil then
        TTL = self.DefaultTTL
      end
      self.data[Key] = {
        time = os.time() + TTL,
        value = Value
      }
    end,
    expire = function(self, Key)
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
          self:expire(Key)
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
          self:expire(i)
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
      if TTL < 0 then
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
    mset = function(self, Keys, TTL)
      local _tbl_0 = { }
      for K, V in pairs(Keys) do
        _tbl_0[K] = self:set(K, V, TTL)
      end
      return _tbl_0
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
