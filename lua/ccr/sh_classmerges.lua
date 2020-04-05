CCR.ClassFunctions = CCR.ClassFunctions || {}

function CCR:AddClassFunctions(_class)
  if (!_class.CCR_CLASSNAME) then
    error("_class HAS NO CCR_CLASSNAME")
  end

  local tbl = include("ccr/tools/class_funcs_merge.lua")
  table.Merge(_class, tbl)
  self:ApplyClassFunctions(_class)
  return _class
end

function CCR:AddClassFunction(name, func)
  self.ClassFunctions[name] = func
end

function CCR:ApplyClassFunctions(_class)
  for name, func in pairs(self.ClassFunctions) do
    local old = _class[name]
    if old then
      _class["old_" .. name] = old
    end

    _class[name] = func
  end
end
