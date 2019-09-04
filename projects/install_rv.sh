#!/bin/sh

DIR="$(pwd)"

cd /usr/class/cs143/bin

wget https://raw.githubusercontent.com/CC-4/cc-4.github.io/master/projects/coolc-rv.jar
wget https://raw.githubusercontent.com/CC-4/cc-4.github.io/master/projects/coolc-rv
wget https://raw.githubusercontent.com/CC-4/cc-4.github.io/master/projects/jupiter-cool
chmod +x coolc-rv
chmod +x jupiter-cool

cd /usr/class/cs143/lib
wget https://raw.githubusercontent.com/CC-4/runtime/master/runtime.s


cd "$DIR"
