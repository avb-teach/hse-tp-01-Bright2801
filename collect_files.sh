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

for r, ds, fs in os.walk(i):
    if md is not None and d(r) >= int(md):
        ds.clear()
    for f in fs:
        s = os.path.join(r, f)
        n = f
        if f in fc:
            fc[f] += 1
            b, e = os.path.splitext(f)
            n = f"{b}{fc[f]}{e}"
        else:
            fc[f] = 0
        t = os.path.join(o, n)
        shutil.copy2(s, t)
END