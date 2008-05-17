
-- Packs lua-iconv into a LuaRock
-- rockspec based uppon the file provided by DarkGod <darkgod at net-core.org>

package = "lua-iconv"
version = "r4-1"

source = {
  url = "http://luaforge.net/frs/download.php/3374/lua-iconv-r4.tar.gz",
}

description = {
   summary = "Lua binding to the iconv",
   detailed = [[
     Lua binding to the POSIX 'iconv' library, which converts a sequence of
     characters from one codeset into a sequence of corresponding characters
     in another codeset.
   ]],
   license = "MIT/X11",
   homepage = "http://luaforge.net/projects/lua-iconv/"
}

dependencies = {
   "lua >= 5.1",
}

external_dependencies = {
   ICONV = {
      header = "iconv.h"
   }
}

build = {
   type = "make",
   variables = {
      CFLAGS = "-I$(LUA_INCDIR) -O3 -Wall",
      LFLAGS = "$(LIBFLAG)",
      LIBS = "",
      INSTALL_PATH = "$(LIBDIR)"
   }
}

