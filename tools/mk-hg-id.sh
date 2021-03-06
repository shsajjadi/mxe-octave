#! /bin/sh
#
# Copyright (C) 2016-2018 John W. Eaton
#
# This file is part of Octave.
#
# Octave is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Octave is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Octave; see the file COPYING.  If not, see
# <http://www.gnu.org/licenses/>.

# Generate a file that holds the hg id of the mxe-octave source tree.

# set -e

if [ $# -ne 1 ]; then
  echo "usage: mk-hg-id.sh SRCDIR" 1>&2
  exit 1
fi

srcdir="$1"

hg_id=HG-ID

if [ -d $srcdir/.hg ]; then
  ( cd $srcdir && hg identify --id || echo "unknown" ) > ${hg_id}-t && mv ${hg_id}-t ${hg_id}
elif [ ! -f $srcdir/${hg_id} ]; then
  echo "WARNING: $srcdir/${hg_id} is missing!" 1>&2
  echo "unknown" > ${hg_id}-t && mv ${hg_id}-t ${hg_id}
else
  echo "preserving existing ${hg_id} file" 1>&2
  if [ "x$srcdir" != "x." ] && [ -f $srcdir/${hg_id} ] && [ ! -f ${hg_id} ]; then
    cp ${srcdir}/${hg_id} ${hg_id}
  fi
fi

