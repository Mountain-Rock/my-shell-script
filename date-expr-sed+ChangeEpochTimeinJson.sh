#!/bin/bash
# ------------------------------------------------------------------
# [Author] Title
#          Description
# ------------------------------------------------------------------

SUBJECT=some-unique-id
VERSION=0.1.0
USAGE="Usage: command -hv args"

# --- processing --------------------------------------------
if [ $# == 0 ] ; then
    echo $#
    End=$(date +%s)
    echo $End
    Start=`expr $End - 3600`
    echo $Start
    record=$(sed "s/\"starttime\"/${Start}000/g;
                  s/\"endtime\"/${End}000/g" sub-para-template.json)
    echo $record
    exit 0;
fi
