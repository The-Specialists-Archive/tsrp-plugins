#!/bin/bash

# AMX Mod X
#
# by the AMX Mod X Development Team
#  originally developed by OLO
#
# This file is part of AMX Mod X.

# new code contributed by \malex\

test -e compiled || mkdir compiled
rm temp.txt

for sourcefile in *.sma
do
        amxxfile="`echo $sourcefile | sed -e 's/\.sma$/.amxx/'`"
        echo -n "Compiling $sourcefile ..."
        ./amxxpc $sourcefile -ocompiled/$amxxfile >> temp.txt
        echo "done"
done

less temp.txt
rm temp.txt
