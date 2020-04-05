function CCR:NewElement(_class, parent, name)


  if string.StartWith(_class, "!") then
    _class = _class:Right(#_class - 1)
  else
    _class = "CCR." .. _class
  end

  local pnl = vgui.Create(_class, parent, name)
  CCR:AddPanelID(pnl)

  hook.Run("CCR.OnElementCreated", pnl, parent, _class, name)

  return pnl
end

function CCR:RegisterElement(_class, tbl, base)
  self:Debug("Registered element \"" .. "CCR." .. _class .. "\"")

  CCR:PreparePanelTheme(tbl)
  CCR:PreparePanelFunctions(tbl)

  return vgui.Register("CCR." .. _class, tbl, base)
end

function CCR:GetFullElementName(_class)
  return "CCR." .. _class
end

function CCR:CopyAndPrepareDefaultElement(_class)
  self:RegisterElement(_class, {}, _class)
end

local lastW, lastH = ScrW(), ScrH()
hook.Add("Think", "CCR.Resolution", function()
  if (lastW != ScrW() || lastH != ScrH()) then
    hook.Run("CCR.OnResolutionChanged", {
      lastW, lastH})
    lastW, lastH = ScrW(), ScrH()
  end
end)
