#!/bin/sh

PACKAGE=lua-iconv
VERSION=r4

DIRNAME=$PACKAGE-$VERSION
TGZNAME=$DIRNAME.tar.gz

rm -f $TGZNAME
mkdir $DIRNAME

mkdir $DIRNAME/debian
cp debian/changelog $DIRNAME/debian/
cp debian/control $DIRNAME/debian/
cp debian/copyright $DIRNAME/debian/
cp debian/rules $DIRNAME/debian/

cp -r COPYING Makefile README luaiconv.c test_iconv.lua $DIRNAME

tar -czf $TGZNAME $DIRNAME

#cd $DIRNAME dpkg-buildpackage -rfakeroot
#cd ..

rm -rf $DIRNAME
tar -tzf $TGZNAME
