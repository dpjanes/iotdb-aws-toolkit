#!/bin/sh
#
#   MQTTSubscribe.sh
#
#   David Janes
#   IOTDB.org
#   2015-12-14
#   
#   This will subscribe to an MQTT topic using a certificate.
#
#   Make sure you have done first on of:
#   $ sudo npm install -g mqtt
#   $ npm install -g mqtt

MY_AWS_ORG=${MY_AWS_ORG:=org}
MY_AWS_GRP=${MY_AWS_GRP:=grp}
MY_AWS_SCOPE="scope"

AWS_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"
AWS_ID=`sh  ${AWS_ROOT}/tools/GetIAMUserID.sh`
AWS_ENDPOINT=`sh  ${AWS_ROOT}/tools/GetIOTEndpoint.sh`
AWS_CERTS="certs"

while [ $# -gt 0 ] ; do
	case "$1" in
		--)
			shift
			break
			;;
		--certs)
			shift
            AWS_CERTS="$1"
            shift
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
		--scope)
			shift
            MY_AWS_SCOPE="$1"
            shift
			;;
		--help)
			echo "usage: $0 [options] <org|grp|scope|all> <message>"
			echo
			echo "options:"
            echo "--certs <certs>    folder that certificates are stored in"
            ## echo "--id <id>            change AWS User ID (is: $AWS_ID)"
            echo "--org <org_name>     change Organization used in topics (is: $MY_AWS_ORG)"
            echo "--grp <group_name> change Group used in topics (is: $MY_AWS_GRP)"
            echo "--scope <scope-id>   change Scope used in topics (is: $MY_AWS_SCOPE)"
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


TOPIC=""
if [ $# != 2 ]
then
    echo "MQTTPublish: argument of 'org', 'grp' or 'scope' is needed AND a message"
    echo "use --help to find out more"
    exit 1
elif [ $1 = "org" ]
then
    TOPIC="$MY_AWS_ORG/#"
elif [ $1 = "grp" ]
then
    TOPIC="$MY_AWS_ORG/$MY_AWS_GRP/#"
elif [ $1 = "scope" ]
then
    TOPIC="$MY_AWS_ORG/$MY_AWS_GRP/01/$MY_AWS_SCOPE"
elif [ $1 = "all" ]
then
    TOPIC="#"
else
    echo "needed 'org' 'grp' or 'scope'"
fi

echo "$0: publishing… $TOPIC"

mqtt publish \
    --ca "${AWS_CERTS}"/rootCA.pem \
    --cert "${AWS_CERTS}"/cert.pem \
    --key "${AWS_CERTS}"/private.pem \
    --hostname "$AWS_ENDPOINT" \
    "${TOPIC}" "${2}"
