#!/bin/sh

echo "Creating jump sounds"


# Define source & target dir
swoosh=$baselibrary/swooshes
targetdir=$DIR/$projectname/$projectname/jump

jumptrimvalue=0.2
jumpfadevalue=0.2
# 100 = 1 semitone
speedmin=200
speedmax=1000

# Pick a random file from the source folder

if [[ -d "${swoosh}" ]]
    then
        file_matrix=($(ls "${swoosh}"))
        num_files=${#file_matrix[*]}

        # Pick random swoosh sound
        currentswoosh=$swoosh/${file_matrix[$((RANDOM%num_files))]}
        echo "Picking random swoosh file: $currentswoosh"
        
        # Adding random pitch 
        swooshpitch=$((RANDOM % ($speedmax-$speedmin) + $speedmin))
        sox -V1 $currentswoosh currentswoosh_temp.wav speed $swooshpitch"c"             
fi

echo "current swoosh is $currentswoosh loop is $i"
sox -M file1.wav file2.wav file3.wav file4.wav jumpsfx.wav channels 2 fade 0.1 0.1 norm -1
sox -M jumpsfx.wav currentswoosh_temp.wav $DIR/$projectname/$projectname/jump/jump$i.wav channels 2 trim 0 $jumptrimvalue fade t 0 $jumpfadevalue norm -1