#!/bin/sh

bin/gen_docs.sh

VERSION="$(cat VERSION)"
TMP_DIR="$(mktemp -d -t AmazeKit.docs)"
if [ $? -ne 0 ]; then
	echo "$0: Can't create temp file, exiting..."
	exit 1
fi

pushd "${TMP_DIR}"

git clone git@github.com:detroit-labs/AmazeKit
git fetch --all
git checkout gh-pages

popd

rsync -HhavP --delete docs/html/ "${TMPDIR}"

pushd "${TMP_DIR}"

git add --all
git commit -m "Updated docs for version ${VERSION}."

git push origin gh-pages

popd

rm -rf "${TMP_DIR}"
