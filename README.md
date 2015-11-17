# aws-iot-mastery

Useful tools and files for configuring your AWS IoT installation

## Setting Up

1. Sign up for AWS
*  [Install command line tools](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
*  Configure [AWS IoT and AWS IAM administrator access](https://iotdb.org/social/imadeit/post/132948890316/using-aws-iam-with-aws-iot)

## Environment Variables

All the shell tools provider here depend on a number of Environment variables.

    export MY_AWS_ORG='org'
    export MY_AWS_GRP='grp'
    export MY_AWS_ID='899999999999'
    export MY_AWS_REGION='us-east-1'

You can run

    $ sh Environment.sh 

to get reasonable values. 

To understand what MY_AWS_ORG and MY_AWS_GRP are, please see 
[iot/policies/README.md](iot/policies/README.md)
