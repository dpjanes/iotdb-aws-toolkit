#!/bin/sh
#
#   EnableAWS.sh
#
#   David Janes
#   IOTDB.org
#   2015-11-17
#   
#   This will allow you to create rules
#   that can access other AWS services
#
#   See http://docs.aws.amazon.com/iot/latest/developerguide/iot-rules.html

TXT_ERR=.err.txt
TXT_OUT=.out.txt

KEYS="AWSAll AWSDynamoDB AWSKinesis AWSLambda AWSS3 AWSSNS AWSSQS"
for KEY in $KEYS
do
    POLICY_NAME="IotAllow${KEY}Policy"
    ROLE_NAME="IotAllow${KEY}Role"

    ##
    echo "* create $POLICY_NAME"
    aws iam create-policy \
        --policy-name "$POLICY_NAME" \
        --policy-document file://policies/$POLICY_NAME.json \
        > /dev/null 2> $TXT_ERR
    if [ $? -ne 0 ]
    then
        if grep EntityAlreadyExists $TXT_ERR > /dev/null
        then
            echo "- $POLICY_NAME already exists (this is OK)"
        else
            cat $TXT_ERR
            exit 1
        fi
    fi

    ## get ARN
    POLICY_ARN=$(
    aws iam list-policies --scope Local |
    python -c "
import json, sys

d = json.load(sys.stdin)
for pd in d['Policies']:
    if pd['PolicyName'] == '${POLICY_NAME}':
        print pd['Arn']

")
    
    echo "- arn: $POLICY_ARN"


    ##
    echo "* create $ROLE_NAME"
    aws iam create-role \
        --role-name "$ROLE_NAME" \
        --assume-role-policy-document file://roles/IotAssumeRole.json \
        > /dev/null 2> $TXT_ERR
    if [ $? -ne 0 ]
    then
        if grep EntityAlreadyExists $TXT_ERR > /dev/null
        then
            echo "- $ROLE_NAME already exists (this is OK)"
        else
            cat $TXT_ERR
            exit 1
        fi
    fi

    ## associate the policy & role
    echo "* attach $ROLE_NAME to $POLICY_ARN"
    aws iam attach-role-policy \
        --role-name "$ROLE_NAME" \
        --policy-arn "$POLICY_ARN"

done
