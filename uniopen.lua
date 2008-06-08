
-- Simple (and incomplete) Unicode I/O layer.

module("uniopen", package.seeall)

require "iconv"

local mt = { __index = _M }

function open(fname, mode, fromcharset, tocharset)
  assert(mode == "r" or mode == "rb", "Only read modes are supported yet")
  tocharset = tocharset or "utf8"
  local cd = assert(iconv.new(fromcharset, tocharset), "Bad charset")
  local fp = io.open(fname, mode)
  if not fp then
    return nil
  end
  local o =  { fp = fp, cd = cd }
  setmetatable(o, mt)
  return o;
end

function read(fp, mod)
  assert(fp and fp.fp and fp.cd, "Bad file descriptor")
  local ret = fp.fp:read(mod)
  if ret then
    return fp.cd:iconv(ret)  -- returns: string, error code
  else
    return nil
  end
end

function close(fp)
  assert(fp and fp.fp, "Bad file descriptor")
  fp.fp:close()
end

