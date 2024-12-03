#!/bin/sh

day=$1
swift test --parallel --filter "AdventOfCode2024Tests.Day($day)"
