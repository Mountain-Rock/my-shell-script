#!/bin/bash
# ------------------------------------------------------------------
# [Author] Title
#          Description
# ------------------------------------------------------------------

set -x
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
    
    # make record 4 submit
    End=$(date +%s)
    echo $End
    Start=`expr $End - 3600`
    echo $Start
    sed "s/\"starttime\"/${Start}000/g;
        s/\"endtime\"/${End}000/g" sub-para-template.json > sub-para-temp.json

    # submit record
    result=$(curl  -i -X POST \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $token" \
      -d @sub-para-temp.json \
      $MeteringEndPoing/v4/metering/resources/$Service/usage | tail -n 1) 
    # sed -n '$p' or awk 'END {print}' print the last line, $-last, p-print
    #echo $result | tr ',' ' ' | tr ':' ' ' | awk '{print $5}' | sed 's/"//g' | tr -d '}]'
    location=$(echo $result | tr ',:' ' ' |  tr -d '"}]' | awk '{print $5}')
    
    # parse the result of submitting POST
    curl  -i -X GET \
      -H "Content-Type: application/json"  \
      -H "Authorization: Bearer $token" \
      ${MeteringEndPoing}${location}
    
fi
