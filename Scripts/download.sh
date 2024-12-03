#!/bin/bash

swift build --product aoc-cli

day=$(ls -1v Sources/AdventOfCode2024 | grep -E 'Day[0-9]+.swift' | sort -V | tail -1 | grep -oE '[0-9]+')
for ((i=1; i<=day; i++)); do
    echo "Fetching day $i input..."
    swift run --skip-build aoc-cli fetch -d $i
done
