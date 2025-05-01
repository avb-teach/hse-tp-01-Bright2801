#!/bin/bash

if [[ $# -lt 2 ]]; then
    exit 1
fi

args=()
max_depth=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --max_depth)
            max_depth="$2"
            shift 2
            ;;
        *)
            args+=("$1")
            shift
            ;;
    esac
done

input_dir="${args[0]}"
output_dir="${args[1]}"

if [[ ! -d "$input_dir" ]]; then
    exit 1
fi

mkdir -p "$output_dir"

python3 - <<EOF
import os
import shutil

i = "$input_dir"
o = "$output_dir"
m = ${max_depth:-None}

fc = {}

def d(p):
    return p.count(os.sep) - i.count(os.sep)

for p, ds, fs in os.walk(i):
    depth = d(p)
    if m is not None and depth >= int(m):
        ds.clear()
        continue
    for f in fs:
        sp = os.path.join(p, f)
        if f in fc:
            fc[f] += 1
            b, e = os.path.splitext(f)
            nf = f"{b}{fc[f]}{e}"
        else:
            fc[f] = 0
            nf = f
        tp = os.path.join(o, nf)
        shutil.copy2(sp, tp)
EOF