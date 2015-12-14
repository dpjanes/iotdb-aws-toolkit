#
#   GetEndpoint.sh
#
#   David Janes
#   IOTDB
#   2015-12-14
#
#   Get the endpointAddress (without JSON)
#

aws iot describe-endpoint |
python -c '
import json
import sys

print json.load(sys.stdin)["endpointAddress"]
'
