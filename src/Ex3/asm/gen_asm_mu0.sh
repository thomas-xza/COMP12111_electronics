#!/bin/bash

target="light_seq.s"

cat light_seq_head.s > $target
python3 $1 >> $target
cat light_seq_tail.s >> $target

