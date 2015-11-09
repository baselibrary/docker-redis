#!/bin/bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )


for version in "${versions[@]}"; do	
  if [ "${version%%.*}" -ge 3 ]; then
    fullVersion="$(curl -fsSL "http://ppa.launchpad.net/chris-lea/redis-server/ubuntu/dists/trusty/main/binary-amd64/Packages.gz" | gunzip | awk -F ': ' '$1 == "Package" { pkg = $2 } pkg ~ /^redis-server$/ && $1 == "Version" { print $2 }' | grep "$version" | sort -rV | head -n1 )"
  else
    fullVersion="$(curl -fsSL "http://archive.ubuntu.com/ubuntu/dists/trusty/universe/binary-amd64/Packages.gz"                   | gunzip | awk -F ': ' '$1 == "Package" { pkg = $2 } pkg ~ /^redis-server$/ && $1 == "Version" { print $2 }' | grep "$version" | sort -rV | head -n1 )"
  fi
  (
		set -x
		cp docker-entrypoint.sh "$version/"
		sed '
			s/%%REDIS_MAJOR%%/'"$version"'/g;
			s/%%REDIS_VERSION%%/'"$fullVersion"'/g;
		' Dockerfile.template > "$version/Dockerfile"
	)
done
