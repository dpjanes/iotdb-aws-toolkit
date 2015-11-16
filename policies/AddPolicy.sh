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

MY_AWS_ORG=${MY_AWS_ORG:=org}
MY_AWS_GRP=${MY_AWS_GRP:=grp}
MY_AWS_THING="thing-id"

AWS_ID=$(aws iam get-user | python -c '
import json, sys, re
d = json.load(sys.stdin)
user_arn = d["User"]["Arn"]
user_id = re.sub("^arn:aws:iam:[^:]*:(\d+):.*$", "\\1", user_arn)
print user_id
')

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
		--organization|--org)
			shift
            MY_AWS_ORG="$1"
            shift
			;;
		--group|--grp)
			shift
            MY_AWS_GRP="$1"
            shift
			;;
		--thing|--thing-id)
			shift
            MY_AWS_THING="$1"
            shift
			;;
		--help)
			echo "usage: $0 [options] <file.json>..."
			echo
			echo "options:"
            echo "--region <region>    change AWS region (is: $AWS_REGION)"
            echo "--id <id>            change AWS User ID (is: $AWS_ID)"
            echo "--org <org_name>     change Organization used in topics (is: $MY_AWS_ORG)"
            echo "--group <group_name> change Group used in topics (is: $MY_AWS_GRP)"
            echo "--thing <thing-id>   change Thing ID used in topics (is: $MY_AWS_THING)"
            echo
            echo "You can default 'org' and 'group' with the environment variables"
            echo "MY_AWS_ORG and MY_AWS_GRP"
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

## set -x
for SRC in $*
do
    BASENAME=$(basename "${SRC}")
    NAME="${BASENAME%.json}"
    NAME="${NAME/my_org/${MY_AWS_ORG}}"
    NAME="${NAME/my_grp/${MY_AWS_GRP}}"
    NAME="${NAME/my_thing/${MY_AWS_THING}}"

    DOT_SRC=".${NAME}.json"
    URL="file://${DOT_SRC}"

    sed \
        -e "1,$ s/us-east-1/$AWS_REGION/g" \
        -e "1,$ s/123456789012/$AWS_ID/g" \
        -e "1,$ s/my_grp/$MY_AWS_GRP/g" \
        -e "1,$ s/my_org/$MY_AWS_ORG/g" \
        -e "1,$ s/my_thing/$MY_AWS_THING/g" \
        < $SRC > $DOT_SRC
    cat $DOT_SRC

    echo "** policy: $NAME"
    aws iot create-policy --policy-name "$NAME" --policy-document "$URL" 
    rm "${DOT_SRC}"
done
