#
#   make-certs.py
#
#   David Janes
#   IOTDB.org
#   2015-11-06
#
#   Make AWS IoT X.509 certificates and nicely bundle
#   them up for us on your devices
#
#   This should work with Python2 and Python3

import json
import sys
import pprint
import subprocess
import zipfile
import urllib2

rootCA = urllib2.urlopen('https://www.symantec.com/content/en/us/enterprise/verisign/roots/VeriSign-Class%203-Public-Primary-Certification-Authority-G5.pem').read()

cmd = [
    "aws",
    "iot",
    "create-keys-and-certificate",
    "--set-as-active",
    "--output",
    "json",
]
output = subprocess.check_output(cmd, shell=False, universal_newlines=True)


masterd = json.loads(output)

certificate_id = masterd[u'certificateId']
zout = zipfile.ZipFile("certs.%s.zip" % certificate_id, "w");

zout.writestr("certs/certificate-id.txt", certificate_id);
zout.writestr("certs/arn.txt", masterd['certificateArn']);
zout.writestr("certs/cert.pem", masterd['certificatePem'])
zout.writestr("certs/private.pem", masterd['keyPair']['PrivateKey'])
zout.writestr("certs/public.pem", masterd['keyPair']['PublicKey'])
zout.writestr("certs/rootCA.pem", rootCA);
zout.close()

print masterd['certificateArn']
