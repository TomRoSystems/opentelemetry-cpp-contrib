#!/bin/bash

TEST_NAME="Check that 5 requests creates 5 spans (with batch)"

. tools.sh

setup_test () {

cat << EOF > ${HTTPD_CONFIG}
OpenTelemetryExporter   file
OpenTelemetryPath ${OUTPUT_SPANS}
OpenTelemetryBatch 10 5000 5
EOF

}

run_test() {
  ${CURL_CMD} ${ENDPOINT_URL} || fail "Unable to download main page"
  ${CURL_CMD} ${ENDPOINT_URL} || fail "Unable to download main page"
  ${CURL_CMD} ${ENDPOINT_URL} || fail "Unable to download main page"
  ${CURL_CMD} ${ENDPOINT_URL} || fail "Unable to download main page"
  ${CURL_CMD} ${ENDPOINT_URL} || fail "Unable to download main page"
}



check_results() {
   echo Checking that all ${TOTAL_SPANS} were created
   count '{' 5 # span count is good
}

teardown_test() {
   rm -rf ${OUTPUT_SPANS}
}

run $@
