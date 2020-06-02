#!/bin/bash
echo "Starting Atelier-server ..."

sed -i 's/$zoneid/'$1'/g' $WORKSPACE/build/debug/restart

# Keep server alive
trap : TERM INT
tail -f /dev/null & wait