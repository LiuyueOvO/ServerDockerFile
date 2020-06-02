#!/bin/bash
positional=()
while [[ $# -gt 0 ]]
do
  key="$1"
case $key in
  -u|--user)
    user="$2"
    shift
    shift;;
  -p|--port)
    port="$2"
    shift
    shift;;
  -*)
    usage "$1: unknown option"
    shift;
    break;;
  *)
  positional+=("$1")
  shift
  ;;
esac
done
#参数不足退出
if [ ! $user ]; then
  echo "plaease add: -u "
  exit
fi

docker run \
--name atelier-server \
-p ${port}-$(($port+49)):${port}-$(($port+49)) \
-v ~/atelier-server:/var/atelier-server \
--restart=always \
-d atelier \
$user
