
-- Common locations (add new ones if needed).
local locs = {
    -- Unices
    "libluaiconv.so",
    "./libluaiconv.so",
    "/usr/lib/libluaiconv.so",
    "/usr/local/lib/libluaiconv.so",
    "/usr/local/lib/lua/5.0/lib/libluaiconv.so",

    -- Windows
    "libluaiconv.dll",
    "luaiconv.dll",
    ".\\luaiconv.dll",
    ".\\libluaiconv.dll",
    "c:\\lua\\lib\\libluaiconv.dll"
}

local loadiconv, fname, ndx
for ndx, fname in ipairs(locs) do
  loadiconv = loadlib(fname, "luaopen_iconv")
  if loadiconv then
    break
  end
end

assert(loadiconv, "Can't load Lua-iconv")
loadiconv()





-- An useful extension: Detects automatically the charset of the string
-- and returns it on the chosen one.

iconv.commoncharsets = {
    "ascii", "iso-8859-1", "utf-8", "utf-16", "windows-1252"
}

iconv.autoconvert = function(tocode, str)
  local _, fromcode, cd, ret, err
  for _, fromcode in pairs(iconv.commoncharsets) do
    cd = iconv.new(tocode, fromcode)
    ret, err = cd:iconv(str)
    if not err then
      return ret
    end
  end
  return nil
end

