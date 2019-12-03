#!/bin/bash
export LD_LIBRARY_PATH="$(pwd):$LD_LIBRARY_PATH"
export LUA_PATH="$(pwd)/?.lua"
./lovr ../windows/world/ "$@"
