# luaiconv - Performs character set conversions in Lua
# (c) 2005-10 Alexandre Erwin Ittner <alexandre@ittner.com.br>
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

CC=gcc
LD=ld

CFLAGS += $$(pkg-config lua --cflags) -fPIC -Wall
LDFLAGS += -shared $$(pkg-config lua --libs)

INSTALL_PATH = $$(pkg-config --variable=INSTALL_CMOD lua)

all: iconv.so

iconv.so: luaiconv.o
	$(LD) $(LDFLAGS) luaiconv.o -o iconv.so
.c.o:
	$(CC) $(CFLAGS) -c $<

install: iconv.so test
#	install -D -s iconv.so $(DESTDIR)/$(INSTALL_PATH)/iconv.so

clean:
	rm *.so *.o

test: iconv.so test_iconv.lua
	lua test_iconv.lua

