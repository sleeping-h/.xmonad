#!/bin/bash

track=$(ncmpcpp --now-playing)
echo "${track#* }" > /tmp/mpdpipe

exit 0
