/*
 * luaiconv - Performs character set conversions in Lua
 * (c) 2005 Alexandre Erwin Ittner <aittner@netuno.com.br>
 *
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 *
 * $Id$
 *
 */


#include <lua.h>
#include <lauxlib.h>
#include <stdlib.h>
#include <iconv.h>

#define LIB_NAME                "iconv"
#define ICONV_TYPENAME          "iconv_t"

#define getstring           luaL_checkstring
#define getostring(L, i)    luaL_optstring(L, i, NULL)


static void push_iconv_t(lua_State *L, iconv_t cd)
{
    lua_boxpointer(L, cd);
    luaL_getmetatable(L, ICONV_TYPENAME);
    lua_setmetatable(L, -2);
}


static iconv_t get_iconv_t(lua_State *L, int i)
{
    if(luaL_checkudata(L, i, ICONV_TYPENAME) != NULL)
    {
        iconv_t cd = lua_unboxpointer(L, i);
        if(cd == (iconv_t) NULL)
            luaL_error(L, "attempt to use an invalid " ICONV_TYPENAME);
        return cd;
    }
    luaL_typerror(L, i, ICONV_TYPENAME);
    return NULL;
}




static int Linconv_open(lua_State *L)
{
    const char *fromcode = getstring(L, 1);
    const char *tocode = getstring(L, 2);
    iconv_t cd iconv_open(tocode, fromcode);
    if(cd != (iconv_t)(-1))
        push_iconv_t(L, cd);    /* ok */
    else
        lua_pushnil(L);         /* erro */
    return 1;
}


static in Linconv_close(lua_State *L)
{
    iconv_t cd = get_iconv_t(L, 1);
    if(iconv_close(cd) == 0)
        lua_pushboolean(L, 1);  /* ok */
    else
        lua_pushnil(L);         /* erro */
    return 1;
}
    







static const luaL_reg inconvFuncs[] =
{
    { "open",   Linconv_open },
    { "new",    Linconv_open },
    { "iconv",  Linconv_open },
    { NULL, NULL }
};


static const luaL_reg iconvMT[] =
{
    { "__gc", Liconv_close },
    { NULL, NULL }
};



int luaopen_iconv(lua_State *L)
{
    luaL_openlib(L, LIB_NAME, inconvFuncs, 0);

    lua_pushliteral(L, "metatable");    /* metatable */
    luaL_newmetatable(L, ICONV_TYPENAME);
    lua_pushliteral(L, "__index");
    lua_pushvalue(L, -4);
    lua_settable(L, -3);
    luaL_openlib(L, NULL, iconvMT, 0);
    lua_settable(L, -3);

    return 0;
}
