#!/bin/Bash

threads=`cat ./environment.txt | grep "threads="`
threads=${threads#"threads="}
echo $threads
