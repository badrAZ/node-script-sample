#!/bin/bash

name=$1
if [[ ! $name ]]; then echo "The script name is required"; exit 1; fi

lib=/usr/local/lib/$name
bin=/usr/local/bin/$name
dir=$(dirname $(readlink -f $0))

echo "deleting old script files..."

rm -rf $lib
rm -f $bin

echo "creating script files..."

mkdir $lib

requiredFiles=("index" "package.json" "yarn.lock")
for file in ${requiredFiles[@]}; do
  cp $dir/$file $lib/
done

echo "fetching dependencies..."

cd $lib
/usr/local/bin/yarn
cd -

echo "exposing script command..."

ln -s $lib/index $bin

echo "tesing the command..."

$bin -m method1 || echo "generation failed" && rm -rf $lib && rm -f $bin

echo "script path: $bin"
