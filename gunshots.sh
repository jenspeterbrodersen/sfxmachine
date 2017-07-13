#!/bin/sh

echo "Creating gunshots"

# Define source & target dir
gunshots=$baselibrary/gunshots
themed=$themepath/gunshots
targetdir=$DIR/$projectname/$projectname/gunshots

# 100 = 1 semitone
speedmin=-500
speedmax=1500

# Pick a random file from the source folder

if [[ -d "${gunshots}" ]]
    
    then
        file_matrix=($(ls "${gunshots}"))
        num_files=${#file_matrix[*]}

        # Pick random gun sound
        currentgun=$gunshots/${file_matrix[$((RANDOM%num_files))]}
        # echo "Picking random gunshot file: $currentgun"
        
        # Adding random pitch 
        gunspeedvalue=$((RANDOM % ($speedmax-$speedmin) + $speedmin))
        sox -V1 $currentgun currentgun_temp.wav speed $gunspeedvalue"c"

              
fi