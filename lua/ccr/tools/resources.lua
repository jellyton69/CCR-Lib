local realms = {
  ["sv"] = true,
  ["cl"] = true,
  ["sh"] = true
}

local function _include(file)
  local toReturn = include(file)
  assert(toReturn || istable(toReturn), "Nothing to merge")
  return toReturn
end

function CCR:IncludeFile(fileName, realm, sourceOverride)
  assert(fileName, "Invalid fileName")

  local trace = istable(sourceOverride) && sourceOverride || debug.getinfo(sourceOverride || 2, "S")
  local fileSource = trace["short_src"]
  local fileToMerge = fileSource:GetPathFromFilename()

  fileToMerge = fileToMerge .. fileName
  fileToMerge = fileToMerge:Split("/lua/")
  fileToMerge = fileToMerge[2]

  assert(fileToMerge, "Failed to get path from file name")

  local fileNameSplit = fileName:Split("/")
  fileName = fileNameSplit && fileNameSplit[#fileNameSplit] || fileName

  if (!realm) then
    realm = fileName:sub(1, 2)
  end

  assert(realms[realm], "Invalid realm")

  if (!fileToMerge:EndsWith(".lua")) then
    fileToMerge = fileToMerge .. ".lua"
  end

  if (SERVER && (realm == "sh" || realm == "cl")) then
    AddCSLuaFile(fileToMerge)
  end

  local includeClient = CLIENT && realm == "cl"
  local includeServer = SERVER && realm == "sv"
  if (realm == "sh" || includeClient || includeServer) then
    return include(fileToMerge)
  end
end

function CCR:IncludeVGUI(fileName)
  return self:IncludeFile("vgui/" .. fileName, "cl", 2)
end

function CCR:IncludeRecursive(path, realmOverride, traceOverride)
  local trace = traceOverride || debug.getinfo(sourceOverride || 2, "S")
  local source = trace["short_src"]

  source = source:Split("/lua/")
  source = source[2]

  local files, dirs = file.Find((source:GetPathFromFilename() .. path) .. "/*", "LUA")
  for i, dir in ipairs(dirs) do
    self:IncludeRecursive(path .. "/" .. dir, realmOverride, trace)
  end

  for i, fileName in ipairs(files) do
    self:IncludeFile(path .. "/" .. fileName, realmOverride, trace)
  end
end

function CCR:IncludeClass(className)
  return self:IncludeFile("classes/" .. className .. "/sh.lua", nil, 2)
end

function CCR:ExtendClass(_class, fileName, realm)
  assert(_class, "Invalid class")
  assert(fileName, "Invalid fileName")

  local returned = self:IncludeFile(fileName, realm, 3)
  if returned then
    table.Merge(_class, returned)
  end
end
