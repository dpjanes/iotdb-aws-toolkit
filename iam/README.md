# ./iam

Useful stuff for AWS IAM (used with AWS IoT)

## Concepts

There's three AWS IoT concepts to know about:

* "Rules"
* "Roles"
* "Policies"

"Rules" are added add to the Message Broker to decide what to do with messages coming
in from your Things. 
You can filter on "topics" and the contents of the message received.

Rules are given permission to do things by "Roles".
You have to associate a Role with a Rule if you want
the Rule to do anything.

Here's the complicated bit. Roles don't actually hold the permissions.
Instead, you create "Policies" and add them to the Roles".
The Policies _actually_ determine what the Role, and hence the Rule
can do.

So there's a level of indirection in there provided by Roles, which
basically acts as a bucket of Policies.

See more here:

* http://docs.aws.amazon.com/iot/latest/developerguide/iot-rules.html


## EnableAWS.sh

This script will set up the "Roles" and "Policies" you'll probably need.
It's safe to run this script multiple times.
You don't need to use this script, you can work with the "roles" and "policy"
files directly.

The most common way to run this 

    $ sh EnableAWS.sh --all

Which will create the following Role / Policy pairs:

* IotAllowAWSAllPolicy IotAllowAWSAllRole
* IotAllowAWSDynamoDBPolicy IotAllowAWSDynamoDBRole
* IotAllowAWSKinesisPolicy IotAllowAWSKinesisRole
* IotAllowAWSLambdaPolicy IotAllowAWSLambdaRole
* IotAllowAWSS3Policy IotAllowAWSS3Role
* IotAllowAWSSNSPolicy IotAllowAWSSNSRole
* IotAllowAWSSQSPolicy IotAllowAWSSQSRole

Right now I'm just using the AllPolicy, as if you 
have permissions to create new Rules, you probably can
create new Roles and Policies anyway. E.g. you
are an Administrator.

If you want to just enable a specific policy, do

    $ sh EnableAWS.sh --help

for more info.

## ./iam/roles

* IotAssumeRole.json - this Role is basically all you need, just name it in different ways

## ./iam/policies

It's possible you may want to modify these to be even more restrictive. 
They allow full access to whichever AWS service they're associatd with

* IotAllowAWSAllPolicy.json
* IotAllowAWSDynamoDBPolicy.json
* IotAllowAWSKinesisPolicy.json
* IotAllowAWSLambdaPolicy.json
* IotAllowAWSS3Policy.json
* IotAllowAWSSNSPolicy.json
* IotAllowAWSSQSPolicy.json
