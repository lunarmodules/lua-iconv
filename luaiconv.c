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
#include <errno.h>

#define LIB_NAME                "iconv"
#define ICONV_TYPENAME          "iconv_t"

#define getstring           luaL_checkstring
#define getostring(L, i)    luaL_optstring(L, i, NULL)

#define ERROR_NO_MEMORY     1
#define ERROR_INVALID       2
#define ERROR_INCOMPLETE    3
#define ERROR_UNKNOWN       4




/* Table assumed on top */
#define tblseticons(L, c, v)    \
    lua_pushliteral(L, c);      \
    lua_pushnumber(L, v);       \
    lua_settable(L, -3);





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




static int Liconv_open(lua_State *L)
{
    const char *tocode = getstring(L, 1);
    const char *fromcode = getstring(L, 2);
    iconv_t cd = iconv_open(tocode, fromcode);
    if(cd != (iconv_t)(-1))
        push_iconv_t(L, cd);    /* ok */
    else
        lua_pushnil(L);         /* erro */
    return 1;
}


static int Liconv(lua_State *L)
{
    iconv_t cd = get_iconv_t(L, 1);
    size_t ibleft = lua_strlen(L, 2);
    char *inbuf = (char*) getstring(L, 2);
    char *outbuf;
    char *outbufs;
    size_t bsize = ibleft;
    size_t obleft = ibleft;
    size_t ret = -1;

    outbuf = (char*) malloc(ibleft * sizeof(char));
    if(outbuf == NULL)
    {
        lua_pushstring(L, "");
        lua_pushnumber(L, ERROR_NO_MEMORY);
        return 2;
    }
    outbufs = outbuf;
    printf("M ibleft=%d, bsize=%d, obleft=%d\n", ibleft, bsize, obleft);

    do
    {
        ret = iconv(cd, &inbuf, &ibleft, &outbuf, &obleft);
        if(ret == (size_t)(-1))
        {
            if(errno == EILSEQ)
            {
                lua_pushlstring(L, outbufs, bsize-obleft);
                lua_pushnumber(L, ERROR_INVALID);
                free(outbufs);
                return 2;   /* Invalid character sequence */
            }
            else if(errno == EINVAL)
            {
                lua_pushlstring(L, outbufs, bsize-obleft);
                lua_pushnumber(L, ERROR_INCOMPLETE);
                free(outbufs);
                return 2;   /* Incomplete character sequence */
            }
            else if(errno == E2BIG)
            {
                bsize += 2 * ibleft;
                obleft += 2 * ibleft;
                printf("R ibleft=%d, bsize=%d, obleft=%d\n", ibleft, bsize,
                    obleft);
                outbufs = (char*) realloc(outbufs, bsize * sizeof(char));
                if(outbufs == NULL)
                {
                    lua_pushstring(L, "");
                    lua_pushnumber(L, ERROR_NO_MEMORY);
                    return 2;
                }
            }
            else
            {
                lua_pushlstring(L, outbufs, bsize-obleft);
                lua_pushnumber(L, ERROR_UNKNOWN);
                free(outbufs);
                return 2; /* Unknown error */
            }
        }
    }
    while(ret != (size_t) 0);

    lua_pushlstring(L, outbufs, bsize-obleft);
    free(outbufs);
    return 1;   /* Done */
}


static int Liconv_close(lua_State *L)
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
    { "open",   Liconv_open },
    { "new",    Liconv_open },
    { "iconv",  Liconv },
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

    tblseticons(L, "ERROR_NO_MEMORY",   ERROR_NO_MEMORY);
    tblseticons(L, "ERROR_INVALID",     ERROR_INVALID);
    tblseticons(L, "ERROR_INCOMPLETE",  ERROR_INCOMPLETE);
    tblseticons(L, "ERROR_UNKNOWN",     ERROR_UNKNOWN);

    lua_pushliteral(L, "metatable");    /* metatable */
    luaL_newmetatable(L, ICONV_TYPENAME);
    lua_pushliteral(L, "__index");
    lua_pushvalue(L, -4);
    lua_settable(L, -3);
    luaL_openlib(L, NULL, iconvMT, 0);
    lua_settable(L, -3);

    return 0;
}
