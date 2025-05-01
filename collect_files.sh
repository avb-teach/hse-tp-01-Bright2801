#!/bin/bash

if [[ $# -ne 2 ]]; then
    exit 1
fi

INPUT_DIR="$1"
OUTPUT_DIR="$2"

if [[ ! -d "$INPUT_DIR" ]]; then
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

find "$INPUT_DIR" -type f -exec cp {} "$OUTPUT_DIR" \;