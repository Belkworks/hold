local TenMinutes = 60 * 10
local Cache
do
  local _class_0
  local _base_0 = {
    setTimeSource = function(self, TimeSource)
      self.TimeSource = TimeSource
    end,
    setDefaultTTL = function(self, Value)
      local Number = tonumber(Value)
      assert(Number, 'setDefaultTTL expects a number!')
      self.DefaultTTL = Number
    end,
    set = function(self, Key, Value, TTL)
      if TTL == nil then
        TTL = self.DefaultTTL
      end
      if Value == nil then
        if self:has(Key) then
          self:del(Key)
        end
        return 
      end
      self.data[Key] = {
        time = self:TimeSource() + TTL,
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
          if E.time > self:TimeSource() then
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
      local now = self:TimeSource()
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
        self:expire(Key)
        return true
      end
      self.data[Key].time = self:TimeSource() + TTL
      return true
    end,
    mget = function(self, Keys)
      local _tbl_0 = { }
      for _index_0 = 1, #Keys do
        local K = Keys[_index_0]
        _tbl_0[K] = self:get(K)
      end
      return _tbl_0
    end,
    mtake = function(self, Keys)
      local _tbl_0 = { }
      for _index_0 = 1, #Keys do
        local K = Keys[_index_0]
        _tbl_0[K] = self:take(K)
      end
      return _tbl_0
    end,
    mset = function(self, Map, TTL)
      for K, V in pairs(Map) do
        self:set(K, V, TTL)
      end
    end,
    fetch = function(self, Key, Getter, TTL, ...)
      if self:has(Key) then
        return self:get(Key)
      end
      local Value = Getter(Key, ...)
      self:set(Key, Value, TTL)
      return Value
    end,
    run = function(self, Key, Fn)
      do
        local Value = self:get(Key)
        if Value then
          return Fn(Value, Key)
        end
      end
    end,
    getState = function(self)
      return self.data
    end,
    setState = function(self, data)
      self.data = data
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self, DefaultTTL, data)
      if data == nil then
        data = { }
      end
      self.data = data
      assert(('table' == type(self.data)), 'cache: constructor expects a table for arg#2!')
      self.TimeSource = os.time
      return self:setDefaultTTL(DefaultTTL or TenMinutes)
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
