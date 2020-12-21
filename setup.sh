#!/bin/bash

echo "This will setup a git deploy pipeline on this server."
echo -e "Specify branch to deploy (other pushed branches will be ignored), e.g. master: \c" 
read -r BRANCH 

GITDIR=$(pwd)/gitdir
DEPLOYDIR=$(pwd)/deploydir
LOGFILE=$(pwd)/logs/deploy.log
JSBUILD=$(pwd)/buildscripts/js.sh
CSSBUILD=$(pwd)/buildscripts/css.sh
DEPLOYSCRIPT=$(pwd)/buildscripts/deploy.sh

mkdir -p $GITDIR
mkdir -p $DEPLOYDIR
mkdir -p logs

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
echo Done. Check configuration in deploy.config and customize buildscripts.
echo Add this server as a remote on your dev env and push branch $BRANCH
echo \$ git remote add $BRANCH ssh://$(hostname)$(pwd)/gitdir
echo \$ git push $BRANCH $BRANCH
