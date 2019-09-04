#!/bin/sh

DIR="$(pwd)"

cd /usr/class/cs143/bin

rm -f coolc-rv.jar coolc-rv jupiter-cool
wget https://raw.githubusercontent.com/CC-4/cc-4.github.io/master/projects/coolc-rv.jar
wget https://raw.githubusercontent.com/CC-4/cc-4.github.io/master/projects/coolc-rv
wget https://raw.githubusercontent.com/CC-4/cc-4.github.io/master/projects/jupiter-cool
chmod +x coolc-rv
chmod +x jupiter-cool

cd /usr/class/cs143/lib
rm -f runtime.s
wget https://raw.githubusercontent.com/CC-4/runtime/master/runtime.s


cd "$DIR"
