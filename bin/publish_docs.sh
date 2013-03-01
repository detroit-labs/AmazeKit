#!/bin/sh

bin/gen_docs.sh

VERSION="$(cat VERSION)"
TMP_DIR="$(mktemp -d -t AmazeKit.docs)"
if [ $? -ne 0 ]; then
	echo "$0: Can't create temp file, exiting..."
	exit 1
fi

pushd "${TMP_DIR}"

git clone git@github.com:AmazeKit/amazekit.github.com
cd amazekit.github.com/

popd

rsync -HhavP --delete --exclude=".git/" docs/html/ "${TMP_DIR}/amazekit.github.com/"

pushd "${TMP_DIR}/amazekit.github.com/"

git add --all
git commit -m "Updated docs for version ${VERSION}."

git push origin master

popd

rm -rf "${TMP_DIR}"
