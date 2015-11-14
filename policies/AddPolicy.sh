#!/bin/sh
#
#   David Janes
#   IOTDB.org
#   2015-11-14
#
#   Add policies to AWS IoT

set -x
for SRC in $*
do
    NAME="${SRC%.json}"
    URL="file://$SRC"
    
    aws iot create-policy --policy-name "$NAME" --policy-document "$URL" || exit $?
done
