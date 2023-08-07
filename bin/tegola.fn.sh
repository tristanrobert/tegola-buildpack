#!/usr/bin/env bash

# Installs Tegola server
#
# Usage: install_tegola_server <build_dir> <cache_dir> <env_dir>
#
install_tegola_server() {
    local build_dir="${1}"
    local cache_dir="${2}"
    local env_dir="${3}"    
    
    local tegola_version="${TEGOLA_VERSION:-0.17.0}"

    if [[ -f "${ENV_DIR}/TEGOLA_VERSION" ]]; then
        tegola_version=$(cat "${ENV_DIR}/TEGOLA_VERSION")
    else
        tegola_version=0.17.0
    fi

    local url="https://github.com/go-spatial/tegola/releases/download/v${tegola_version}/tegola_linux_amd64.zip"
    local zip_cache_file="${cache_dir}/tegola-${tegola_version}.zip"

    if [ ! -f "${zip_cache_file}" ] ; then
        echo "Downloading Tegola ${tegola_version}"
        curl --retry 3 --location "${url}" \
            --output "${zip_cache_file}"
    else
        echo "---> Retrieving Tegola ${tegola_version} from cache"
    fi

    # Either we got tegola zip from the cache of from the project page
    unzip -qq -o "${zip_cache_file}" -d "${build_dir}/tegola/tegola-${tegola_version}"

    # Ensure we have a working link to current tegola version in $build_dir/tegola
    
    echo "---> Installing Tegola ${tegola_version}"
    pushd "${build_dir}/tegola" > /dev/null \
        && ln -sfn "tegola-${tegola_version}/tegola" "tegola" \
        && popd > /dev/null
}
