#!/bin/sh

PACKAGE=lua-iconv
VERSION=r1

DIRNAME=$PACKAGE-$VERSION
TGZNAME=$DIRNAME.tar.gz

rm -f $TGZNAME
mkdir $DIRNAME

cp COPYING Makefile README luaiconv.c iconv.lua test_iconv.lua \
    install51.lua $DIRNAME

tar -czf $TGZNAME $DIRNAME
rm -rf $DIRNAME
tar -tzf $TGZNAME
