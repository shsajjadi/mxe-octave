#! /bin/sh

## Run from top-level mxe-octave directory.

set -e

top_dir=`pwd`

make_ver="4.1"
make_dir="make-$make_ver"
make_pkg="$make_dir.tar.gz"

if [ ! -d pkg ]; then
  mkdir pkg
fi

if [ ! -f pkg/$make_pkg ]; then
  wget ftp://ftp.gnu.org/gnu/make/$make_pkg -O pkg/$make_pkg
fi

rm -rf $make_dir

tar zxf pkg/$make_pkg

cd $make_dir

./configure --prefix=$top_dir/usr

make

make install

cd $top_dir

rm -rf $make_dir
