#!/usr/bin/env bash
set -Eeuo pipefail

ql_versions=( "$@" )
if [ ${#ql_versions[@]} -eq 0 ]; then
	ql_versions=( */ )
fi

ql_versions=( "${ql_versions[@]%/}" )

# see http://stackoverflow.com/a/2705678/433558
sed_escape_lhs() {
	echo "$@" | sed -e 's/[]\/$*.^|[]/\\&/g'
}
sed_escape_rhs() {
	echo "$@" | sed -e 's/[\/&]/\\&/g' | sed -e ':a;N;$!ba;s/\n/\\n/g'
}

alpine_versions=(3.6 3.7)
declare -A ql_checksums
ql_checksums=(["1.12"]="fcf82734fa065a81141a67f0fe185d80166e60199dd7143ac5847af4ce9a36ed" ["1.13"]="bb52df179781f9c19ef8e976780c4798b0cdc4d21fa72a7a386016e24d1a86e6")

for version in "${ql_versions[@]}"; do
    echo "Generating Dockerfiles for QuantLib version ${version}."
    ql_checksum=${ql_checksums[$version]}

    for alpine_version in ${alpine_versions[@]}; do
	mkdir -p ${version}/alpine/${alpine_version}
        
	sed -r \
	    -e 's!%%TAG%%!'"alpine${alpine_version}"'!g' \
	    -e 's!%%QUANTLIB_VERSION%%!'"${version}"'!g' \
	    -e 's!%%QUANTLIB_CHECKSUM%%!'"$ql_checksum"'!g' \
            "Dockerfile-alpine.template" > "${version}/alpine/${alpine_version}/Dockerfile"
	echo "Generated ${version}/alpine/${alpine_version}/Dockerfile"
    done
done
