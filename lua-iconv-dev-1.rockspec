local package_name = "lua-iconv"
local package_version = "dev"
local rockspec_revision = "1"
local github_account_name = "lunarmodules"
local github_repo_name = package_name

package = package_name
version = package_version.."-"..rockspec_revision

source = {
   url = "git+https://github.com/"..github_account_name.."/"..github_repo_name..".git",
   branch = (package_version == "dev") and "master" or nil,
   tag = (package_version ~= "dev") and ("v" .. package_version) or nil,
}

description = {
   summary = "Lua binding to the iconv",
   detailed = [[
      Lua binding to the POSIX 'iconv' library, which converts a sequence of
      characters from one codeset into a sequence of corresponding characters
      in another codeset.
      ]],
   license = "MIT/X11",
   homepage = "https://github.com/"..github_account_name.."/"..github_repo_name,
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
      },
      macosx = {
         modules = {
           iconv = {
              libraries = {"iconv"}
           }
        }
     },
   }
}
