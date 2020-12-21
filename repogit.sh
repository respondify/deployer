#!/bin/bash

if [[ ! -f deploy.config ]]; then
  echo "deploy.confg not found, is everything setup?"
  exit 1
fi;
source ./deploy.config

if [[ -z $1 ]]; then
  echo "Just adds the current --work-tree and --git-dir"
  echo "Example: ./repogit.sh log --oneline"
  exit 0
fi
git --work-tree=$DEPLOYDIR --git-dir=$GITDIR $@


