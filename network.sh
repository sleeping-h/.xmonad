#!/bin/bash

ping -q -c 1 -W 1 8.8.8.8 > /dev/null && echo 'up' || echo 'down'

exit 0
