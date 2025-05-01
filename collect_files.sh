#!/bin/bash

if [ "$#" -lt 2 ]; then
    exit 1
fi

positional=()
max_depth=""

while [ $# -gt 0 ]; do
    case "$1" in
        --max_depth)
            max_depth="$2"
            shift 2
            ;;
        *)
            positional+=("$1")
            shift
            ;;
    esac
done

input_dir="${positional[0]}"
output_dir="${positional[1]}"

if [ ! -d "$input_dir" ]; then
    exit 1
fi

mkdir -p "$output_dir"

python3 - <<END
import os
import shutil

i = "$input_dir"
o = "$output_dir"
md = ${max_depth:-None}

fc = {}

def d(p):
    return p.count(os.sep) - i.count(os.sep)

for p, dirs, files in os.walk(s):
    depth = get_depth(p)
    if m is not None and depth >= int(m):
        dirs.clear()
        continue
    for f in files:
        src = os.path.join(p, f)
        if f in c:
            c[f] += 1
            name, ext = os.path.splitext(f)
            nf = f"{name}{c[f]}{ext}"
        else:
            c[f] = 0
            nf = f
        shutil.copy2(src, os.path.join(d, nf))
END