#!/bin/bash

# Setting
# docker run --rm -it amazon/aws-cli:2.1.32 configure --profile koki_tsuyuzaki
# AWS Access Key ID [****************4F6N]:
# AWS Secret Access Key [****************ENMF]:
# Default region name [us-east-1]:
# Default output format [text]:

# cp
docker run -v ~/.aws:/root/.aws --rm -it amazon/aws-cli:2.1.32 --profile koki_tsuyuzaki s3 cp sqlite s3://annotationhub/AHLRBaseDbs/v001 --recursive

# ls
docker run -v ~/.aws:/root/.aws --rm -it amazon/aws-cli:2.1.32 --profile koki_tsuyuzaki s3 ls s3://annotationhub/AHLRBaseDbs/v001 --recursive
