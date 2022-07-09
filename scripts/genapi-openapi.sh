#!/bin/bash

version=$1

function join {
    local IFS="$1"
    shift
    echo "$*"
}

# get the root path of the directory this file resides
# this enables this script to be called from any path
# https://gist.github.com/olegch/1730673
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

keywords=(
    "k8scommerce"
    "admin gateway api"
)
keywords_json=$(printf '%s\n' "${keywords[@]}" | jq -R . | jq -s .)

# set the original and destination vars
orig=https://raw.githubusercontent.com/k8scommerce/k8scommerce/main/docs/swagger/v1/admin.json
dest=$ROOT/../projects/user-client-sdk/src/lib/
# # npm i ng-openapi-gen -g

# ng-openapi-gen --input $orig --output ./out --ignoreUnusedModels=true

# generate the
# openapi-generator generate \
#     -g typescript-angular \
#     -i https://raw.githubusercontent.com/k8scommerce/k8scommerce/main/docs/swagger/v1/admin.json \
#     -o $ROOT/../$dest \
#     --additional-properties=platform=browser,npmName=@k8soft/user-client-sdk,npmVersion=$version,providedIn=platform

npx api-client-generator -t all -s $orig -o $dest

# currently there is an error in the generator
# that makes the delete method has 3 params instead of two
# let's fix them
# perl -pi -e 'BEGIN{undef $/;} s/(return\s+this.httpClient.delete)(.*?)\n\s+body,(.*?);/$1$2$3;/smg' $ROOT/../$dest/api/admin.service.ts

# # remove the version number from the README
# perl -pi -e 'BEGIN{undef $/;} s/user-client-sdk@(\d+)\.(\d+)\.(\d+)/user-client-sdk/smg' $ROOT/../README.md

# # remove building and publishing info blocks
# perl -pi -e 'BEGIN{undef $/;} s/### Building.*(### consuming)/$1/smg' $ROOT/../README.md

# # update the package keywords before building
# perl -pi -e "BEGIN{undef $/;} s/(?s)(\"keywords\"\:).*?\]/\$1 $keywords_json/smg" $ROOT/../package.json

# # remove the package-lock.json file
# rm -rf $ROOT/../package-lock.json

# # run an npm install
# npm i --legacy-peer-deps

# # build the project
# npm run build

# # push to github
# $ROOT/gitpush.sh k8scommerce user-client-sdk "update to version ${version}" "github.com"

# # publish to npm
# cd $ROOT/../dist && npm publish && cd $ROOT
