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

input_dir = "$input_dir"
output_dir = "$output_dir"
max_depth = ${max_depth:-None}

file_counter = {}

def relative_depth(path):
    return path.count(os.sep) - input_dir.count(os.sep)

for root, dirs, files in os.walk(input_dir):
    depth = relative_depth(root)
    if max_depth is not None and depth >= int(max_depth):
        dirs.clear()
        files.clear()
    rel_root = os.path.relpath(root, input_dir)
    out_root = os.path.join(output_dir, rel_root) if rel_root != "." else output_dir
    os.makedirs(out_root, exist_ok=True)
    for file in files:
        src_path = os.path.join(root, file)
        dst_file = file
        if dst_file in file_counter:
            count = file_counter[dst_file]
            name, ext = os.path.splitext(dst_file)
            dst_file = f"{name}_{count}{ext}"
            file_counter[file] += 1
        else:
            file_counter[file] = 1
        dst_path = os.path.join(out_root, dst_file)
        shutil.copy2(src_path, dst_path)
EOF