#!/bin/bash
# ------------------------------------------------------------------
# [Author] Title
#          Description
# ------------------------------------------------------------------

SUBJECT=some-unique-id
VERSION=0.1.0
USAGE="Usage: command -hv args"
IAMEndPoint="https://iam.cloud.net/oidc/token"
MeteringEndPoing="https://metering.cloud.net"
APIKey="n2b60WTF"
Service="041216e4"
# --- processing --------------------------------------------
if [ $# == 0 ] ; then
    echo $#
    token=$(curl -X POST \
      -H "Content-Type: application/x-www-form-urlencoded" \
      -H "Accept: application/json" \
      -d "grant_type=urn%3Acloud%3Aparams%3Aoauth%3Agrant-type%3Aapikey&apikey=$APIKey" \
      $IAMEndPoint \
      | tr ',' ' ' | tr ':' ' ' | awk '{print $2}' | sed 's/"//g')
    echo $token

    curl  -i -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $token" \
    -d @sub-para.json \
    $MeteringEndPoing/v4/metering/resources/$Service/usage

    exit 0;
fi
