#!/usr/bin/env bash

CWD=$(pwd)

# install V-SIM
wget -O vsim https://git.io/fbpu0 && chmod +x vsim && . ./vsim && rm vsim

# download traphandler
cd ~/.vsim
wget https://raw.githubusercontent.com/CC-4/traphandler/master/traphandler.s

# download coolc-rv
cd /usr/class/cs143/cool/bin
wget https://github.com/CC-4/cc-4.github.io/raw/master/proyectos/coolc-rv.jar
printf '#!/bin/sh\n\n' >> coolc-rv
printf 'if [ "$#" -gt 0 ]; then\n' >> coolc-rv
printf '  /usr/class/cs143/cool/etc/../lib/.i686/PA5J/lexer $* | /usr/class/cs143/cool/etc/../lib/.i686/PA5J/parser $* | /usr/class/cs143/cool/etc/../lib/.i686/PA5J/semant $* | java -classpath /usr/class/cs143/cool/lib:.:/usr/java/lib/rt.jar:/usr/class/cs143/cool/bin/coolc-rv.jar Cgen $*\n' >> coolc-rv
printf 'fi' >> coolc-rv
chmod +x coolc-rv

cd "$CWD"
