#!/bin/sh
usage() { echo "Usage: $0 [-h] [-i <file>] [-a <file>] [-t <file>]" 1>&2; exit 1; }

while getopts ":hi:a:t:c:" o; do
  case "${o}" in
    i)
      file=${OPTARG}
      echo "$file"
      echo "=> Output"
      moonc -p "$file"
      echo "=> AST"
      moonc -T "$file" | sed -e 's/\[[[:digit:]]\+\]//g'
      echo "=> Line rewriting and positions"
      moonc -X "$file"
      ;;
    a)
      file=${OPTARG}
      moonc -T "$file" | sed -e 's/\[[[:digit:]]\+\]//g' > "$file.ast"
      ;;
    t)
      transformer=${OPTARG}
      ;;
    c)
      file=${OPTARG}
      moonc --transform "$transformer" "$file"
      ;;
    h | *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))
