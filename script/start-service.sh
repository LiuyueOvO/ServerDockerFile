#!/bin/bash
#add env
export PATH=/opt/rh/devtoolset-7/root/usr/bin:$PATH
# Keep server alive
trap : TERM INT
tail -f /dev/null & wait