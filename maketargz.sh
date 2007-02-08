#!/bin/sh

PACKAGE=lua-iconv
VERSION=r3

DIRNAME=$PACKAGE-$VERSION
TGZNAME=$DIRNAME.tar.gz

rm -f $TGZNAME
mkdir $DIRNAME

cp -r debian COPYING Makefile README luaiconv.c test_iconv.lua $DIRNAME

tar -czf $TGZNAME $DIRNAME
rm -rf $DIRNAME
tar -tzf $TGZNAME
