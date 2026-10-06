#!/bin/bash
set -e

# keep the previous build as a fallback
if [[ -x /usr/local/bin/dwm ]]; then
    cp /usr/local/bin/dwm /usr/local/bin/dwm.old
fi

make clean install
