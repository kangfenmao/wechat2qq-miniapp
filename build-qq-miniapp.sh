#!/bin/bash

DIRNAME=$(basename `pwd`)
WORKDIR=$(pwd)
DISTDIR=$WORKDIR/../$DIRNAME-qq-miniapp

# Copy code
rsync -r --exclude=.git --exclude=node_modules -delete $WORKDIR/ $DISTDIR
ln -fs $WORKDIR/node_modules $DISTDIR/node_modules

# Delete all wxss files
find $DISTDIR -name '*.wxss' -type f -print -exec rm -rf {} \;

# Rename all .wxml extension files to .qml
# Replace wechat template grammar with qq template grammar.
for i in $(find $DISTDIR -name '*.wxml')
do
  qml=${i/.wxml/.qml}
  mv $i $qml
  sed -i '' 's/wx:if/qq:if/g; s/wx:elif/qq:elif/g; s/wx:else/qq:else/g; s/wx:for/qq:for/g; s/wx:key/qq:key/g' $qml
done

# Replace wx api with qq api
for i in $(find $DISTDIR -name '*.js');
do
  sed -i '' 's/wx\./qq\./g' $i
done

# Change working directory
cd $DISTDIR

# Do something else

