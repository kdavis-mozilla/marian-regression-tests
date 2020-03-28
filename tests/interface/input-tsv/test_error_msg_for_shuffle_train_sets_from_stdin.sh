#!/bin/bash -x

#####################################################################
# SUMMARY: Shuffling is not possible if training data comes from the STDIN
# TAGS: sentencepiece tsv train
#####################################################################

# Exit on error
set -e

# Remove old artifacts and create working directory
rm -rf msg_train_shuf_stdin msg_train_shuf_stdin.log
mkdir -p msg_train_shuf_stdin

test -s train.de  || cat $MRT_DATA/train.max50.de | sed 's/@@ //g' > train.de
test -s train.en  || cat $MRT_DATA/train.max50.en | sed 's/@@ //g' > train.en
paste train.{de,en} > train.tsv

# Run marian command
cat train.tsv | $MRT_MARIAN/marian \
    --seed 1111 -m msg_train_shuf_stdin/model.npz \
    --tsv --tsv-size 2 -t stdin -v $MRT_MODELS/rnn-spm/vocab.deen.{spm,spm} \
    --after-batches 1 \
    > msg_train_shuf_stdin.log 2>&1 || true

test -e msg_train_shuf_stdin.log
grep -qi "shuffling training data.* stdin.* not supported" msg_train_shuf_stdin.log

# Exit with success code
exit 0