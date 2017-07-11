#!/bin/sh

# Adding sox to $PATH
export PATH=$PATH:/Applications/sox-14.4.1

# Set current dir as variable DIR1
DIR1="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Create folders
# mkdir $DIR1/wav-stereo; echo "creating folder: $DIR1/wav-stereo"
source createfolders.sh

# Promt user for settings
echo "path to source audio files"; read sourcepath;
# sourcepath=/Applications/sox-14.4.1/sfxtest
echo "name of sfx"; read sfxname;
echo "amount"; read amount;
echo "max-length (seconds)"; read trimvalue;
echo "fadeout-length (seconds)"; read fadeoutvalue;
echo "number of round-robin variations"; read roundrobins;

# echo "name of sfx: $sfxname"
# echo "amount: $amount"
# echo "max-length $trimvalue"
# echo "fadeout-length $fadeoutvalue"
# echo "number of round-robin variations $roundrobins"


# Run this loop for as many sfx you need
for i in `seq 1 $amount`;
    do
    echo "
making sfx # $i"

    # Picking 4 random files, and applying effectschain
    for ii in `seq 1 4`;
        do
            # Set new randomized variabeles for pitch (speed) playback timing (delay) and panning for each time a new random file is picked
            IFS='
            ' # Used to handle filenames with spaces
            speedmin=-300
            speedmax=500
            speedvalue=$((RANDOM % ($speedmax-$speedmin+1) + $speedmin))
            panleft=$((RANDOM % 10))
            panright=$((RANDOM % 10))
            delayfloat=$((RANDOM % 2))
            
            echo "speedvalue $speedvalue"
            echo "speedmin = $speedmin"
            echo "speedmax = $speedmax"
            echo "panleft = $panleft"
            echo "panright = $panright"
            echo "delayfloat = $delayfloat"

            # Pick a random file in folder
            source pickrandomfile.sh

        done

    
    # Create the final sfx file by mixing file 1-4.wav together into a single .wav file
    echo "Mixing file1, 2, 3, 4 together into $sfxname$i$i.wav"

    sox -V1 -M file1.wav file2.wav file3.wav file4.wav $DIR1/$projectname/$projectname/sfx/$sfxname$i.wav channels 2 trim 0 $trimvalue fade t 0 0 $fadeoutvalue norm -1

    # Create additional round robin variations
    for variation in `seq 1 $roundrobins`; 
        do
        echo "creating round robin variation #$variation"

            delayfloat=$((RANDOM % 1))
            sox -V1 file1.wav file1-var.wav speed "$(($speedvalue+$((RANDOM % 500))))"c delay 0.$delayfloat 0.$delayfloat

            delayfloat=$((RANDOM % 1))
            sox -V1 file2.wav file2-var.wav speed "$(($speedvalue+$((RANDOM % 500))))"c delay 0.$delayfloat 0.$delayfloat

            delayfloat=$((RANDOM % 1))
            sox -V1 file3.wav file3-var.wav speed "$(($speedvalue+$((RANDOM % 500))))"c delay 0.$delayfloat 0.$delayfloat

            delayfloat=$((RANDOM % 1))
            sox -V1 file4.wav file4-var.wav speed "$(($speedvalue+$((RANDOM % 500))))"c delay 0.$delayfloat 0.$delayfloat

            echo "mixing file1-r.wav...file4-r.wav together into $sfxname$i-$variation.wav"
            sox -V1 -M file1-var.wav file2-var.wav file3-var.wav file4-var.wav $DIR1/$projectname/$projectname/sfx/$sfxname$i-$variation.wav channels 2 trim 0 $trimvalue fade t 0 0 $fadeoutvalue norm -1
        done

done

# Delete temp files
echo "delete temp files"
rm *.wav 

# Create UI sounds
source ui.sh