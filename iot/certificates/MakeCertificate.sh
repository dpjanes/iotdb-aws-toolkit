#!/bin/sh
#
#   MakeCertificate.sh
#
#   David Janes
#   IOTDB.org
#   2015-12-30
#   
#   This will
#   1) make a certificate
#   2) assign it to a MQTT Topic Policy 

POLICY_NAME=
NO_POLICY=false
ACCESS=

while [ $# -gt 0 ] ; do
	case "$1" in
		--)
			shift
			break
			;;
		--policy-name|--policy)
			shift
            POLICY_NAME="$1"
            shift
			;;
		--no-policy)
			shift
            NO_POLICY="true"
            shift
			;;
		--help)
			echo "usage: $0 [options]"
			echo
			echo "options:"
            echo "--policy-name <policy-name>  "
            echo "--no-policy                  make certificate without policy"
            echo
            echo "get policy names: "
            echo "   $ aws iot list-policies"
            echo
            echo "create policies: "
            echo "   $ cd ../policies"
            echo "   $ sh AddPolicy.sh ..."
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

if [ "${POLICY_NAME}" = "" -a "${NO_POLICY}" = "false" ]
then
    echo "$0: you must use --policy-name <policy> or --no-policy"
    echo
    echo "for more help"
    echo "  $ sh $0 --help"
    echo
    echo "to list policies"
    echo "  $ aws iot list-policies"
    echo
    exit 1
fi

CERT_ARN=$(python MakeCertificate.py)

if [ "${NO_POLICY}" = "true" ]
then
    echo "$0: cert ARN: $CERT_ARN"
else
    aws iot attach-principal-policy --principal "${CERT_ARN}" --policy-name "${POLICY_NAME}"
    echo "$0: cert ARN: $CERT_ARN"
    echo "$0: policy: $POLICY_NAME"
fi


