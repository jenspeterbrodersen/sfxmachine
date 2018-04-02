#!/bin/sh

echo "Creating explosions"

# Define source & target dir
gundir=$baselibrary/explosions
themed=$themepath/explosions
targetdir=$DIR/$projectname/$projectname/explosions

gunshottrimvalue=1
gunshotfadevalue=0.8
# 100 = 1 semitone
speedmin=-500
speedmax=1500

# Pick a random file from the source folder

if [[ -d "${gundir}" ]]
    
    then
        file_matrix=($(ls "${gundir}"))
        num_files=${#file_matrix[*]}

        # Pick random gun sound
        currentgun=$gundir/${file_matrix[$((RANDOM%num_files))]}
        echo "Picking random explosion file: $currentgun"
        
        # Adding random pitch 
        gunspeedvalue=$((RANDOM % ($speedmax-$speedmin) + $speedmin))
        sox -V1 $currentgun currentgun_temp.wav speed $gunspeedvalue"c"

              
fi

echo "current explosion is $currentgun loop is $i"
sox -M -v0.8 file1.wav -v0.8 file2.wav currentgun_temp.wav $DIR/$projectname/$projectname/explosions/explosion$i.wav channels 2 trim 0 $gunshottrimvalue fade t 0 0 $gunshotfadevalue norm -1