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

alpine_versions=(3.10 "edge")
declare -A ql_checksums
ql_checksums=(["1.15"]="1f651b210d3046bffa9635864906423d40f9fff87faeaf417c9b76fd88f0ee64" ["1.16"]="204ad5822259f9a9146eaf660f0b756100604e3adb85c501d41d201bf09dec94")

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
