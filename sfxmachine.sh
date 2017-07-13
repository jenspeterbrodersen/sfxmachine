#!/bin/sh

# Adding sox to $PATH
export PATH=$PATH:/Applications/sox-14.4.1

# Set current dir as variable DIR
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
IFS='
' # Used to handle filenames with spaces

# Create folders
source createfolders.sh


# Promt user for settings
# echo "path to source audio files"; read sourcepath;
# echo "path to themed audio files"; read themepath;
# echo "name of sfx"; read sfxname;
# echo "amount"; read amount;
# echo "max-length (seconds)"; read trimvalue;
# echo "fadeout-length (seconds)"; read fadeoutvalue;
# echo "number of round-robin variations"; read roundrobins;

# Test values 
sourcepath=/Volumes/AudioLibraries/SFXMachine/SwooshSFX
themepath=/Applications/sox-14.4.1/sourcelibraries/themelibrary
baselibrary=/Applications/sox-14.4.1/sourcelibraries/baselibrary
sfxname="sfx"
amount=10
trimvalue=3
gunshottrimvalue=1
gunshotfadevalue=0.8
fadeoutvalue=0.5
roundrobins=1

# Main loop creating the sfx
for i in `seq 1 $amount`;
    do
    echo "$IFS""Cooking sfx # $i..."

    # Picking 4 random files, and applying effectschain
    for ii in `seq 1 4`;
        do
            # Set new randomized variabeles for pitch (speed) playback timing (delay) and panning for each time a new random file is picked
            speedmin=-200
            speedmax=200
            speedvalue=$((RANDOM % ($speedmax-$speedmin+1) + $speedmin))
            panleft=$((RANDOM % 10))
            panright=$((RANDOM % 10))
            delayfloat=$((RANDOM % 2))

            # Pick a random file in folder
            # source pickrandomfile.sh
            # echo "picking random file in $sourcepath"
 
            if [[ -d "${sourcepath}" ]]
  
                then
                    file_matrix=($(ls "${sourcepath}"))
                    num_files=${#file_matrix[*]}

                    # Create the temp audio wav files for later merging
                    currentfile=$sourcepath/${file_matrix[$((RANDOM%num_files))]}
                    echo "Picking random file: $currentfile"

                    # Check if file is mono, then create random panning
                    channelcheck=($(soxi -c $currentfile))
                    
                    if (($channelcheck == 1)); 
                        then
                            echo "This file is mono, creating $channelconvert$ii.wav and adding panning: left $panleft, right $panright" 
                            sox -V1 $currentfile channelconvert$ii.wav remix 1v0.$panleft 1v0.$panright norm -1
                        else
                            # echo "This file is stereo, creating channelconvert$ii.wav"
                            sox -V1 $currentfile channelconvert$ii.wav norm -1
                    fi
                    
                    # Add effects
                    echo "Adding maineffects chain"
                    source maineffects.sh   

            fi

        done

    
    # Create the final sfx file by mixing file 1-4.wav together into a single .wav file
    echo "Mixing file1, 2, 3, 4 together into $sfxname$i$i.wav $IFS"

    sox -V1 -M file1.wav file2.wav file3.wav file4.wav $DIR/$projectname/$projectname/sfx/$sfxname$i.wav channels 2 trim 0 $trimvalue fade t 0 0 $fadeoutvalue norm -1

    # Create gunshot sounds
    source gunshots.sh
    echo "current gun is $currentgun loop is $i"
    sox -M -v0.8 file1.wav -v0.8 file2.wav currentgun_temp.wav $DIR/$projectname/$projectname/gunshots/shoot$i.wav trim 0 $gunshottrimvalue fade t 0 0 $gunshotfadevalue norm -1

    # Create round robin variations
    for variation in `seq 1 $roundrobins`; 
        do
        echo "creating round robin variation #$variation"

            delayfloat=$((RANDOM % 1))
            speedvalue=$((RANDOM % ($speedmax-$speedmin+1) + $speedmin))
            sox -V1 file1.wav file1-var.wav speed $speedvalue"c" delay 0.$delayfloat 0.$delayfloat

            delayfloat=$((RANDOM % 1))
            speedvalue=$((RANDOM % ($speedmax-$speedmin+1) + $speedmin))
            sox -V1 file2.wav file2-var.wav speed $speedvalue"c" delay 0.$delayfloat 0.$delayfloat

            delayfloat=$((RANDOM % 1))
            speedvalue=$((RANDOM % ($speedmax-$speedmin+1) + $speedmin))
            sox -V1 file3.wav file3-var.wav speed $speedvalue"c" delay 0.$delayfloat 0.$delayfloat

            delayfloat=$((RANDOM % 1))
            speedvalue=$((RANDOM % ($speedmax-$speedmin+1) + $speedmin))
            sox -V1 file4.wav file4-var.wav speed $speedvalue"c" delay 0.$delayfloat 0.$delayfloat

            echo "mixing file1-r.wav...file4-r.wav together into $sfxname$i-$variation.wav"
            sox -V1 -M file1-var.wav file2-var.wav file3-var.wav file4-var.wav $DIR/$projectname/$projectname/sfx/$sfxname$i-$variation.wav channels 2 trim 0 $trimvalue fade t 0 0 $fadeoutvalue norm -1

            #Create gunshot variations
             sox -V1 -M file1-var.wav file2-var.wav file3-var.wav file4-var.wav currentgun_temp.wav $DIR/$projectname/$projectname/gunshots/shoot$i-$variation.wav channels 2 trim 0 $gunshottrimvalue fade t 0 0 $gunshotfadevalue norm -1
        done

done

# Delete temp files
echo "delete temp files"
rm *.wav 

# Create UI sounds
source ui.sh

# Create Footstep sounds
source footsteps.sh

