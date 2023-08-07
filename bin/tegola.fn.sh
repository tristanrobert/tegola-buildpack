#!/usr/bin/env bash

# Installs Tegola server
#
# Usage: install_tegola_server <build_dir> <cache_dir> <env_dir>
#
install_tegola_server() {
    local build_dir="${1}"
    local cache_dir="${2}"
    local version="${3}"

    local url="https://github.com/go-spatial/tegola/releases/download/v${version}/tegola_linux_amd64.zip"
    local zip_cache_file="${cache_dir}/tegola-${version}.zip"

    if [ ! -f "${zip_cache_file}" ] ; then
        echo "Downloading Tegola ${version}"
        curl --retry 3 --silent --location "${url}" \
            --output "${zip_cache_file}"
    else
        echo "---> Retrieving Tegola ${version} from cache"
    fi

    # Either we got tegola zip from the cache of from the project page
    unzip -qq -o "${zip_cache_file}" -d "${build_dir}/tegola/tegola-${version}"

    # Ensure we have a working link to current tegola version in $build_dir/tegola
    pushd "${build_dir}/tegola" > /dev/null \
        && ln -sfn "tegola-${version}/tegola" "tegola" \
        && popd > /dev/null
}
