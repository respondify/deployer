#!/bin/bash

if [[ ! -f deploy.config ]]; then
  echo "deploy.confg not found, is everything setup?"
  exit 1
fi;
source ./deploy.config

echo "Current branch: $BRANCH"

# Repo to reset
if [[ -z $1 ]]; then
  echo -e "Enter commit ID to reset branch to and checkout: \c"
  read -r RESETCOMMIT 
else
  RESETCOMMIT=$1
fi

# Check if repo exists
if git --git-dir=$GITDIR cat-file -e $RESETCOMMIT 2> /dev/null 
then 
  echo "Resetting to $RESETCOMMIT"
  cd "$DEPLOYDIR"
  git --work-tree=$DEPLOYDIR --git-dir=$GITDIR reset $RESETCOMMIT --hard

  # Build scripts
  if [[ -f $CSSBUILD ]]; then
    $CSSBUILD $DEPLOYDIR $COMMIT
  fi

  if [[ -f $JSBUILD ]]; then
    $JSBUILD $DEPLOYDIR $COMMIT
  fi

  if [[ -f $DEPLOYSCRIPT ]]; then
    $DEPLOYSCRIPT $DEPLOYDIR $COMMIT
  fi

  echo "Commit $COMMIT released"
  echo "$( date +'%Y-%m-%d %H:%M:%S' ) COMMIT $COMMIT released (manual rollback)" >> $LOGFILE

else 
  echo "Commit $RESETCOMMIT does not exist"
fi