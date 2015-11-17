#!/bin/sh
#
#   Environment.sh
#
#   David Janes
#   IOTDB.org
#   2015-11-17
#
#   Figure out proper environment variables
#
#   This assumes that you've already got to the 'aws configure' 
#   stage and you're logged in a user that is "root" authenticated
#   for both IAM and IOT

MY_AWS_ORG=${MY_AWS_ORG:=org}
MY_AWS_GRP=${MY_AWS_GRP:=grp}
MY_AWS_THING="thing-id"

MY_AWS_ID=$(aws iam get-user | python -c '
import json, sys, re
d = json.load(sys.stdin)
user_arn = d["User"]["Arn"]
user_id = re.sub("^arn:aws:iam:[^:]*:(\d+):.*$", "\\1", user_arn)
print user_id
')

MY_AWS_REGION=$(grep '^region =' ~/.aws/config | head -1 | sed -e '1 s/^.* = //')

echo "###########"
echo "# Based on your current AWS configuration"
echo "# please add the following environment variables"
echo "# to your .bashrc (or similar)"
echo "#"
echo "# See README.md for more"
echo "###########"

echo "export MY_AWS_ORG='$MY_AWS_ORG'"
echo "export MY_AWS_GRP='$MY_AWS_GRP'"
echo "export MY_AWS_ID='$MY_AWS_ID'"
echo "export MY_AWS_REGION='$MY_AWS_REGION'"
