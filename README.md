# aws-iot-mastery

Useful tools and files for configuring your AWS IoT installation

## Important Links

* [AWS IoT Developer Guide](http://docs.aws.amazon.com/iot/latest/developerguide/what-is-aws-iot.html)

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

To understand what MY_AWS_ORG and MY_AWS_GRP are, please see "Topics" in
[iot/policies/README.md](iot/policies/README.md).
It's not important to make a decision on these, so leave them as the
defaults if you don't want to think about it right now.

## Topics

Our code is based around the following MQTT topic organization.

* Layer 1 : the _name_ of your organization (defaults $MY_AWS_ORG)
* Layer 2 : the _code_ for a particular "group" of things (defaults $MY_AWS_GRP)
* Layer 3 : a version, always "01 "
* Layer 4 : the _scope_, which is an arbitrary strong

For example,

    ibm/canada/01/l38939339

This seems to provide a fairly flexibly upgrade path to very complicated networks.

The actual readings can be in the payload, though you can add additional layers like:
    
    ibm/canada/01/l38939339/ambient-noise

though personally I don't think this is a great idea.


## Folders


