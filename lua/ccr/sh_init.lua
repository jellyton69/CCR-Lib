
// TODO: Clean this trash up ffs

CCR.Resources:CL("cl_panelfuncs") // Load b4 tools
CCR.Resources:SH("sh_classmerges")


// Tools
CCR.Resources:SH("tools/_PROMISES")
CCR.Resources:CL("tools/_BSHADOWS")
CCR.Resources:CL("tools/_GRADIENT")
CCR.Resources:SH("tools/resources")
CCR.Resources:SV("tools/net")
CCR.Resources:SH("tools/accessor_funcs")
CCR.Resources:SH("tools/class_funcs_merge")
CCR.Resources:SH("tools/color")
CCR.Resources:SH("tools/misc")
CCR.Resources:SH("tools/sh_playerfuncs")
CCR.Resources:SH("tools/table")
CCR.Resources:SH("tools/entity_vars")
CCR.Resources:SH("tools/language")
CCR.Resources:CL("tools/vgui")
CCR.Resources:CL("tools/draw")
CCR.Resources:CL("tools/anim")
CCR.Resources:CL("tools/text")
CCR.Resources:CL("tools/hook")
CCR.Resources:CL("tools/cache")
CCR.Resources:CL("tools/imgur")

// Config
CCR.Resources:CLASS("config")
CCR.Resources:CLASS("mysqlite")

// Theme
CCR.Resources:CLASS("theme")
CCR.Resources:CL("cl_themes")

for k, v in pairs(file.Find("ccr/themes/*", "LUA")) do
	v = string.StripExtension(v)
	CCR.Resources:CL("themes/" .. v)
end

CCR.Resources:CL("cl_test")

for k, v in pairs(file.Find("ccr/elements/*", "LUA")) do
	CCR.Resources:ELEMENT(v:StripExtension())
end

hook.Run("CCR.OnLoaded")