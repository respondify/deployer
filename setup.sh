#!/bin/bash

echo "This will setup a git deploy pipeline on this server."

GITDIR=$(pwd)/gitdir
DEPLOYDIR=$(pwd)/deploydir
LOGFILE=$(pwd)/logs/deploy.log
JSBUILD=$(pwd)/buildscripts/js.sh
CSSBUILD=$(pwd)/buildscripts/css.sh
DEPLOYSCRIPT=$(pwd)/buildscripts/deploy.sh

if [[ -e "$GITDIR" ]]; then
  echo "$GITDIR already exists, are you sure?"
  exit 2
fi

if [[ -e "deploy.config" ]]; then
  echo "You already have a deploy.config file, are you sure?"
  exit 2
fi

echo -e "Specify branch to deploy (other pushed branches will be ignored) [master]: \c" 
read -r BRANCH 
if [[ -z $BRANCH ]]; then
  BRANCH="master"
fi

mkdir -p $GITDIR
mkdir -p $DEPLOYDIR
mkdir -p buildscripts
mkdir -p logs

# Copy example buildscripts
cp ./install/buildscripts/* ./buildscripts/

# Setup git repo
pushd gitdir > /dev/null 2>&1
git init --bare
cp ../install/hooks/* hooks/
chmod u+x hooks/*
git --work-tree=$DEPLOYDIR --git-dir=$GITDIR checkout -b $BRANCH  
popd > /dev/null 2>&1

# Create config file
echo "BRANCH=$BRANCH" > deploy.config
echo "GITDIR=$GITDIR" >> deploy.config 
echo "DEPLOYDIR=$DEPLOYDIR" >> deploy.config 
echo "LOGFILE=$LOGFILE" >> deploy.config
echo "JSBUILD=$JSBUILD" >> deploy.config
echo "CSSBUILD=$CSSBUILD" >> deploy.config
echo "DEPLOYSCRIPT=$DEPLOYSCRIPT" >> deploy.config

# Done
echo "Done. Now you need to:"
echo "* Check settings in the deploy.config file, f eg DEPLOYDIR (if you want to deploy to another folder)"
echo "* Copy/customize buildscripts in the ./buildscripts folder"
echo "* Add this server as a remote on your dev env:"
echo " - \$ git remote add $BRANCH ssh://$(hostname)$(pwd)/gitdir"
echo "* When all set, push branch here to upload a copy and run buildscripts first time"
echo " - \$ git push $BRANCH $BRANCH"
