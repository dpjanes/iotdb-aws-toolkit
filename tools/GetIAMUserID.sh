#!/bin/sh
#
#   GetIAMUserID.sh
#
#   David Janes
#   IOTDB.org
#   2015-12-29
#   

aws iam get-user | python -c '
import json, sys, re
d = json.load(sys.stdin)
user_arn = d["User"]["Arn"]
user_id = re.sub("^arn:aws:iam:[^:]*:(\d+):.*$", "\\1", user_arn)
print user_id'

