# iot/certificates

Certificates are needed by software that wants to access
AWS IoT, especially via MQTT.

Certificates must be associated with a **Policy**, which gives
things using Certificates the right to access certain 
MQTT paths on AWS (and also whether they can Publish or Subscribe
or both)

To use

* Create the Policies you want to use first using the tools in ../policies. 
* Use "$ aws iot list-policies" to get the policy name (if it isn't obvious)
* Use "$ sh MakeCertificate.sh --policy SomePolicyName" to create the policy

The end result will be a ZIP file 
