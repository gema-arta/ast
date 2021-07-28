#!/bin/ksh -e

# Script to refresh the contrib/ast area in a checkout of illumos-gate

if [[ -z "$1" ]]; then
	echo "Syntax: $0 <path to gate checkout>"
	exit 1
fi

gate="$1"
ast="$gate/usr/src/contrib/ast"
if [[ ! -d "$ast" ]]; then
	echo "Error, could not find usr/src/contrib/ast under $gate"
	exit 1
fi

cp LICENSE $ast/

rsync='rsync -a --delete --delete-excluded'

mkdir -p $ast/lib
for lib in package; do
	echo "Syncing $lib"
	$rsync \
	    --exclude '*.html' --exclude '*.README' \
	    lib/$lib/ $ast/lib/$lib/
done

mkdir -p $ast/src/lib
for lib in libast libpp libdll libsum libcmd; do
	echo "Syncing $lib"
	$rsync src/lib/$lib/ $ast/src/lib/$lib/
	rm -rf $ast/src/lib/$lib/man
done

mkdir -p $ast/src/cmd
echo "Syncing INIT"
$rsync \
    --exclude 'cc.*' --exclude 'ldd.*' --exclude 'ar.*' --exclude 'ld.*' \
    src/cmd/INIT/ $ast/src/cmd/INIT/

for cmd in ksh93 msgcc; do
	echo "Syncing $cmd"
	$rsync src/cmd/$cmd/ $ast/src/cmd/$cmd/
done

