#!/bin/bash

cd

if [ "$1" != "" ]; then
	SAMPLE_TO_BUILD="$1"
fi

if [ "$SAMPLE_TO_BUILD" == "" ]; then
	echo To build a cross-compiler, either set SAMPLE_TO_BUILD or call with the first argument as one of the following samples:
	ct-ng list-samples
	exit 0
fi

if [ "$S3_OUTPUT_URI" == "" ]; then
	echo You need to set S3_OUTPUT_URI so that the results have somewhere to go
	exit 1
fi

echo Checking AWS credentials....
aws s3 ls "${S3_OUTPUT_URI}"

if [ "$?" != "0" ]; then
	echo Could not list ${S3_OUTPUT_URI}
	exit 2
fi

echo Configuring....
if [ -f "${HOME}/${SAMPLE_TO_BUILD}.config" ]; then
	cp ${HOME}/${SAMPLE_TO_BUILD}.config ${HOME}/.config
else
	ct-ng "${SAMPLE_TO_BUILD}"
	patch < /home/build/glibc_version.patch
fi

echo ----------------------------------------
echo Building......

ct-ng build

cd x-tools
ls -lh


for x in `find . -type d -maxdepth 1 -mindepth 1`; do
	PKGNAME=`basename $x`
	echo ---------------------------------------
	echo Packaging $PKGNAME.....
	tar c ${PKGNAME} | xz > ~/${PKGNAME}.tar.xz

	echo ---------------------------------------
	echo Uploading.....
	aws s3 cp ~/${PKGNAME}.tar.xz "${S3_OUTPUT_URI}"/${PKGNAME}.tar.xz
done

echo ----------------------------------------
echo All done!
