#!/bin/bash

# Exit on error
set -e

model=model.student.small

# Run test
cat newstest2014.in | $MRT_MARIAN/build/marian-decoder \
    -m $MRT_MODELS/wnmt18/$model/model.npz \
    -v $MRT_MODELS/wnmt18/vocab.ende.{yml,yml} \
    --mini-batch-words 384 --mini-batch 100 --maxi-batch 100 --maxi-batch-sort src -b 1 \
    --shortlist $MRT_MODELS/wnmt18/lex.s2t 100 75 --cpu-threads=1 --skip-cost --max-length-factor 1.2 \
    > student_small.out

diff student_small.out student_small.expected > student_small.diff

# Exit with success code
exit 0
