#!/bin/bash

swift build --product aoc-cli -c release

day=$(ls -1v Sources/AdventOfCode2024 | grep -E 'Day[0-9]+.swift' | sort -V | tail -1 | grep -oE '[0-9]+')
for ((i=1; i<=day; i++)); do
    echo "Fetching day $i input..."
    ./.build/release/aoc-cli fetch -d $i -y 2024 &
done

day=$(ls -1v Sources/AdventOfCode2025 | grep -E 'Day[0-9]+.swift' | sort -V | tail -1 | grep -oE '[0-9]+')
for ((i=1; i<=day; i++)); do
    echo "Fetching day $i input..."
    ./.build/release/aoc-cli fetch -d $i -y 2025 &
done

wait
