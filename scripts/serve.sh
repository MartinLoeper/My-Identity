#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

pushd "${SCRIPT_DIR}/../my-site" > /dev/null
    hugo server -v --buildDrafts --themesDir ../../
popd > /dev/null