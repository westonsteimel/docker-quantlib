#!/usr/bin/env bash
set -Eeuo pipefail

ql_versions=( "$@" )
if [ "${#ql_versions[@]}" -eq 0 ]; then
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

alpine_versions=(3.8 3.9 "edge")
declare -A ql_checksums
ql_checksums=(["1.13"]="bb52df179781f9c19ef8e976780c4798b0cdc4d21fa72a7a386016e24d1a86e6" ["1.14"]="65a6ef7984ddedd3af64ea3f9bec44a6d658436f276b4d99ced80382eaef47fb")

for version in "${ql_versions[@]}"; do
    echo "Generating Dockerfiles for QuantLib version ${version}."
    ql_checksum="${ql_checksums[$version]}"

    for alpine_version in "${alpine_versions[@]}"; do
	mkdir -p "${version}/alpine/${alpine_version}"
        
	sed -r \
	    -e 's!%%TAG%%!'"alpine${alpine_version}"'!g' \
	    -e 's!%%QUANTLIB_VERSION%%!'"${version}"'!g' \
	    -e 's!%%QUANTLIB_CHECKSUM%%!'"$ql_checksum"'!g' \
            "Dockerfile-alpine.template" > "${version}/alpine/${alpine_version}/Dockerfile"
	echo "Generated ${version}/alpine/${alpine_version}/Dockerfile"
    done
done
