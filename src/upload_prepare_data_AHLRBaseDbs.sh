#!/bin/bash

METADATA_VERSION=$1
OUTPUT=$2

mkdir -p Azure/AHLRBaseDbs/${METADATA_VERSION}
cp -rf sqlite/*  Azure/AHLRBaseDbs/${METADATA_VERSION}/
echo "" > ${OUTPUT}
