#!/bin/bash

target="light_seq.s"

cat light_seq_head.s > $target
./gen_delays_assembly.py >> $target
cat light_seq_tail.s >> $target
