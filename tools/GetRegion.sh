#!/bin/sh
#
#   GetRegion.sh
#
#   David Janes
#   IOTDB.org
#   2015-12-29
#   

grep '^region =' ~/.aws/config | head -1 | sed -e '1 s/^.* = //'
