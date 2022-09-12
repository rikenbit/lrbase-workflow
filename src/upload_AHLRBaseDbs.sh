#!/bin/bash

URL=$1
OUTPUT=$2

mkdir /tmp/azcopy
wget https://aka.ms/downloadazcopy-v10-linux
tar xvf downloadazcopy-v10-linux -C /tmp/azcopy
cp  /tmp/azcopy/*/azcopy /tmp/azcopy/azcopy

cd Azure

/tmp/azcopy/azcopy copy --recursive AHLRBaseDbs $URL
/tmp/azcopy/azcopy list $URL
cd ..
echo "" > ${OUTPUT}

