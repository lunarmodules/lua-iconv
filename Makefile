# luaiconv - Performs character set conversions in Lua
# (c) 2005 Alexandre Erwin Ittner <aittner@netuno.com.br>
#
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.
#

CC=gcc
OUTFILE=libluaiconv.so
CFLAGS=-Wall
LFLAGS=-shared -llua -liconv


all: $(OUTFILE)

libluagd.so: luaiconv.c
	$(CC) -o $(OUTFILE) $(CFLAGS) $(LFLAGS) luaiconv.c

install: $(OUTFILE)
	cp $(OUTFILE) /usr/lib/

clean:
	rm -f $(OUTFILE) *.o
