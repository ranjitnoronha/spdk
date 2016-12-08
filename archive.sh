#!/usr/bin/env bash
#
# Archive a copy of the docs for a release.
#
# Usage:
#  ./archive.sh v16.12
# (where v16.12 is the name of the release)

set -e

archive_dir="$1"

if [ -z "$archive_dir" ]; then
        echo "Usage: $0 \$archive_dir"
        echo "where \$archive_dir is something like v16.12"
        exit 1
fi

cd $(dirname $0)

doc=${doc:-~/src/spdk/doc}

if [ ! -d $doc ]; then
        echo "$doc: directory doesn't exist"
        echo "Specify doc path with:"
        echo "  doc=/dir/to/spdk/doc $0"
        exit 1
fi

if [ -d doc/$archive_dir ]; then
        echo "doc/$archive_dir already exists - updating..."
        git rm -rf -- doc/$archive_dir
fi
(cd $doc; make clean; make)
cp -R $doc/output/html doc/$archive_dir
git add -- doc/$archive_dir
(cd $doc; make clean)

echo
echo "New doc archive generated in doc/$archive_dir"
echo
git status
