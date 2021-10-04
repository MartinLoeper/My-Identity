#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

pushd "${SCRIPT_DIR}/../my-site" > /dev/null
    hugo -v --buildDrafts --themesDir ../../ --minify
popd > /dev/null