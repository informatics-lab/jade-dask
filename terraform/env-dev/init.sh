#!/bin/bash

# Usage: ./init.sh once to initialise remote storage for this environment. 

environment="dev"
tfstate_bucket="informatics-jade-terraform"
tfstate_key="dask/dev/dev.tfstate"

terraform remote config -backend=s3 \
                        -backend-config="bucket=$tfstate_bucket" \
                        -backend-config="key=$tfstate_key" \
                        -backend-config="region=eu-west-1"

echo "Remote state set to s3://$tfstate_bucket/$tfstate_key"


