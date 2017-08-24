#!/bin/sh

# set DIR = current working directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR;
# Promt for projectname
echo "Enter projectname"; read projectname;

# create folderstructure
echo "Creating folderstructure..."

mkdir -p $DIR/$projectname/$projectname/sfx;
mkdir -p $DIR/$projectname/$projectname/music
mkdir -p $DIR/$projectname/$projectname/footsteps
mkdir -p $DIR/$projectname/$projectname/ui
mkdir -p $DIR/$projectname/$projectname/gunshots
mkdir -p $DIR/$projectname/$projectname/jump

# Copy files from baselibrary to new library
# cp -R /Applications/sox-14.4.1/sourcelibraries/baselibrary/. $DIR/$projectname/baselibrary/
