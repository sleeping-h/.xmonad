#!/bin/bash

lvl=`amixer sget Master | grep -o -m 1 '[[:digit:]]*%' | tr -d '%'`

echo $lvl

exit 0
