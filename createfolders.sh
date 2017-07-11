#!/bin/sh

# set DIR1 = current working directory
DIR1="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR1;
# Promt for projectname
echo "Enter projectname"; read projectname;

# create folderstructure
echo "Creating folderstructure..."

mkdir -p $DIR1/$projectname/$projectname/sfx;
mkdir -p $DIR1/$projectname/$projectname/music
mkdir -p $DIR1/$projectname/$projectname/footsteps
mkdir -p $DIR1/$projectname/$projectname/ui


mkdir -p $DIR1/$projectname/themelibrary/theme;
mkdir -p $DIR1/$projectname/themelibrary/movement;
mkdir -p $DIR1/$projectname/themelibrary/footsteps;

mkdir -p $DIR1/$projectname/baselibrary/destruction;
mkdir -p $DIR1/$projectname/baselibrary/explosions;
mkdir -p $DIR1/$projectname/baselibrary/gunshots;
mkdir -p $DIR1/$projectname/baselibrary/impacts;
mkdir -p $DIR1/$projectname/baselibrary/loops;
mkdir -p $DIR1/$projectname/baselibrary/materials;
mkdir -p $DIR1/$projectname/baselibrary/swooshes;
mkdir -p $DIR1/$projectname/baselibrary/twinkles;

