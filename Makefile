# luaiconv - Performs character set conversions in Lua
# (c) 2005-08 Alexandre Erwin Ittner <aittner@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHOR OR COPYRIGHT HOLDER BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# If you use this package in a product, an acknowledgment in the product
# documentation would be greatly appreciated (but it is not required).

#CC = gcc
#RM = rm

# Gives a nice speedup, but also spoils debugging on x86. Comment out this
# line when debugging.
OMIT_FRAME_POINTER = -fomit-frame-pointer

# Name of .pc file. "lua5.1" on Debian/Ubuntu
LUAPKG = lua5.1
CFLAGS = `pkg-config $(LUAPKG) --cflags` -fPIC -O3 -Wall
LFLAGS = -shared $(OMIT_FRAME_POINTER)
INSTALL_PATH = `pkg-config $(LUAPKG) --variable=INSTALL_CMOD`

## If your system doesn't have pkg-config, comment out the previous lines and
## uncomment and change the following ones according to your building
## enviroment.

#CFLAGS = -I/usr/include/lua5.1/ -fPIC -O3 -Wall
#LFLAGS = -shared $(OMIT_FRAME_POINTER)
#INSTALL_PATH = /usr/lib/lua/5.1


all: iconv.so

iconv.lo: luaiconv.c
	$(CC) -o iconv.lo -c $(CFLAGS) luaiconv.c

iconv.so: iconv.lo
	$(CC) -o iconv.so $(LFLAGS) $(LIBS) iconv.lo

install: iconv.so
	make test
	install -D -s iconv.so $(DESTDIR)/$(INSTALL_PATH)/iconv.so

clean:
	$(RM) iconv.so iconv.lo

test: iconv.so test_iconv.lua
	lua test_iconv.lua

