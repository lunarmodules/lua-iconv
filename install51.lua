#!/usr/bin/env lua
-- Easy way to put a library on the path. For Lua >= 5.1 only.
-- (c) 2005 Alexandre Erwin Ittner < aittner{at}netuno.com.br >
--
-- This file is distributed under the same license that Lua 5.1 itself.
--
-- $Id$
--

-- Splits a package.cpath into a table.
function splitpath(str)
  local t = {}
  local v
  for v in string.gfind(str, "([^;]+);") do
    table.insert(t, v)
  end
  return t
end


-- Checks if a given file exists. DUMB. Do not distinguish files from
-- symlinks, pipes, sockets, device drivers, etc.
function fileexists(fname)
  local fp = io.open(fname, "r")
  if fp then
    fp:close()
    return true
  end
  return false
end


-- Finds the first absolute path on the list. Works with *nix (MacOS X
-- included) and Windows paths.
function findplace(tbl)
  local k, v
  for k, v in ipairs(tbl) do
    if v:sub(1, 1) == "/"
    or v:sub(2, 3) == ":\\" then
      return v
    end
  end
end


-- It's REALLY stupid, but also it's REALLY cross-platform.
function dumbcopy(from, to)
  local bufsize = 512*1024  -- 512K at once
  local ifp = io.open(from, "rb")
  assert(ifp, "Can't open file for reading. File not found?")
  local ofp = io.open(to, "wb")
  assert(ofp, "Can't open file for writing. Permission denied?")
  local buf
  repeat
    buf = ifp:read(bufsize)
    if buf then
      ofp:write(buf)
    end
  until not buf
  ifp:close()
  ofp:close()
end


-- Copies the file. 'to' MUST be an absolute path!
function copy(from, to)
  if to:sub(1, 1) == "/" then       -- Cool! We are on Unix, guys!
    ret = os.execute('install -D "' .. from .. '" "' .. to .. '"')
    if ret == 0 and fileexists(to) then
      return
    end
  end
  -- Let's try some violence.
  dumbcopy(from, to)
end


-- Installs one file. Simple. Perfect.
function installfile(fname, name)
  local tpath = splitpath(package.cpath)
  local path = findplace(tpath)
  assert(path, "Can't find a place to install")
  local dest = path:gsub("%?", name)
  print("Install:", dest)
  copy(fname, dest)
end

assert(package, "No package module found. Are you REALLY using Lua >= 5.1?")
assert(arg[1] and arg[2], "No arguments provided")

installfile(arg[1], arg[2])
os.exit(0)
