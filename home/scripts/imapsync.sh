#!/usr/bin/env bash

docker run --rm gilleslamiral/imapsync imapsync \
  --host1 $syncFromHost \
  --user1 $syncFromLogin \
  --password1 $syncFromPassword \
  --host2 $syncToHost \
  --user2 $syncToLogin \
  --password2 $syncToPassword \
  --ssl1 \
  --ssl2 \
  --truncmess 30_000_000 # specific for icloud