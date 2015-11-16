#!/bin/sh
#
#   David Janes
#   IOTDB.org
#   2015-11-14
#
#   Add policies to AWS IoT
#
#   This assumes that you've already got to the 'aws configure' 
#   stage and you're logged in a user that is "root" authenticated
#   for both IAM and IOT

MY_AWS_ORG=${MY_AWS_ORG:=my_org}
MY_AWS_GRP=${MY_AWS_GRP:=my_grp}

AWS_ID=$(aws iam get-user | python -c '
import json, sys, re
d = json.load(sys.stdin)
user_arn = d["User"]["Arn"]
user_id = re.sub("^arn:aws:iam:[^:]*:(\d+):.*$", "\\1", user_arn)
print user_id
')
echo $AWS_ID

AWS_REGION=$(grep '^region =' ~/.aws/config | head -1 | sed -e '1 s/^.* = //')

## echo $MY_AWS_ORG $MY_AWS_GRP $AWS_ID $AWS_REGION
## exit 
while [ $# -gt 0 ] ; do
	case "$1" in
		--)
			shift
			break
			;;
		--region)
			shift
            AWS_REGION="$1"
            shift
			;;
		--id)
			shift
            AWS_ID="$1"
            shift
			;;
		--org)
			shift
            AWS_MY_ORG="$1"
            shift
			;;
		--group)
			shift
            AWS_MY_GROUP="$1"
            shift
			;;
		--help)
			echo "usage: $0 [options] <file.json>..."
			echo
			echo "options:"
            echo "--region <region>    change AWS region (is: $AWS_REGION)"
            echo "--id <id>            change AWS User ID (is: $AWS_ID)"
            echo "--org <org_name>     change Organization used in topics (is: $MY_AWS_ORG)"
            echo "--grp <group_name>   change Group used in topics (is: $MY_AWS_GRP)"
			exit 0
			;;
		--*)
			echo "Unrecognized option"
			exit 1
			;;
		*)
			break
	esac
done

set -x
for SRC in $*
do
    NAME="${SRC%.json}"
    DOT_SRC=".${SRC}"
    URL="file://${DOT_SRC}"

    sed \
        -e "1,$ s/us-east-1/$AWS_REGION/g" \
        -e "1,$ s/123456789012/$AWS_ID/g" \
        -e "1,$ s/my_grp/$MY_AWS_GRP/g" \
        -e "1,$ s/my_org/$MY_AWS_ORG/g" \
        < $SRC > $DOT_SRC
    cat $DOT_SRC

    aws iot create-policy --policy-name "$NAME" --policy-document "$URL" 
    rm "${DOT_SRC}"
done
