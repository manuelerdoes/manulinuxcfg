#!/bin/bash

make clean install
mv /bin/dwm /bin/dwm.old
cp dwm /bin/dwm
