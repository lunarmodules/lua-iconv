
-- Packs lua-iconv into a LuaRock
-- rockspec based uppon the file provided by DarkGod <darkgod at net-core.org>

package = "lua-iconv"
version = "6-1"

source = {
  url = "http://luaforge.net/frs/download.php/4181/lua-iconv-6.tar.gz",
  md5 = "2cec334c5786d7c420a53003d6cb93d4"
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
   type = "builtin",
   modules = {
      iconv = {
          sources = {"luaiconv.c"},
          incdirs = {"$(ICONV_INCDIR)"},
          libdirs = {"$(ICONV_LIBDIR)"}
      }
   },
   platforms = {
      cygwin = {
         modules = {
            iconv = {
               libraries = {"iconv"}
            }
         }
      }
   }
}
