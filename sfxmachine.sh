#!/bin/sh

# Adding sox to $PATH
export PATH=$PATH:/Applications/sox-14.4.1

# Set current dir as variable DIR1
DIR1="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mkdir $DIR1/wav-stereo; echo "creating folder: $DIR1/wav-stereo"
mkdir $DIR1/wav-mono; echo "creating folder: $DIR1/wav-mono"

# promt user for settings
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

    # loop over picking 4 random files, and applying effectschain
    for ii in `seq 1 4`;
        do
            # define variables
            DIR=$sourcepath
            IFS='
            '
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
            if [[ -d "${DIR}" ]]
                then
                    file_matrix=($(ls "${DIR}"))
                    num_files=${#file_matrix[*]}

                    # create the temp audio wav files for later merging
                    currentfile=$DIR/${file_matrix[$((RANDOM%num_files))]}
                    echo "picking file: $currentfile"

                    channelcheck=($(soxi -c $currentfile))
                    # echo $currentfile

                    # check if file is mono, then create random panning
                    if (($channelcheck == 1)); 
                        then
                            echo "this file is mono creating $tempfile$ii.wav and adding panning: left $panleft, right $panright" 
                            sox -V1 $currentfile tempfile$ii.wav remix 1v0.$panleft 1v0.$panright norm -1
                        else
                            echo "this file is stereo creating tempfile$ii.wav"
                            sox -V1 $currentfile tempfile$ii.wav norm -1
                    fi
                    
                    # fetch and run external script for main effectschain
                    echo "adding maineffects chain"
                    source maineffects.sh   

            fi

        done

    echo "Mix file1, 2, 3, 4 together into $sfxname$i$i.wav"
    
    # mix file 1-4 together into $sfxname$i.wav (stereo)
    sox -V1 -M file1.wav file2.wav file3.wav file4.wav $DIR1/wav-stereo/$sfxname$i.wav channels 2 trim 0 $trimvalue fade t 0 0 $fadeoutvalue norm -1

    # create round robin variations
    for r in `seq 1 $roundrobins`; 
        do
        echo "doing variation $r"

            delayfloat=$((RANDOM % 1))

            sox -V1 file1.wav file1-var.wav speed "$(($speedvalue+$((RANDOM % 500))))"c delay 0.$delayfloat 0.$delayfloat

            delayfloat=$((RANDOM % 1))

            sox -V1 file2.wav file2-var.wav speed "$(($speedvalue+$((RANDOM % 500))))"c delay 0.$delayfloat 0.$delayfloat

            delayfloat=$((RANDOM % 1))

            sox -V1 file3.wav file3-var.wav speed "$(($speedvalue+$((RANDOM % 500))))"c delay 0.$delayfloat 0.$delayfloat

            delayfloat=$((RANDOM % 1))

            sox -V1 file4.wav file4-var.wav speed "$(($speedvalue+$((RANDOM % 500))))"c delay 0.$delayfloat 0.$delayfloat

            echo "mixing file1-r.wav...file4-r.wav together into $sfxname$i-variation-$r.wav"
            sox -V1 -M file1-var.wav file2-var.wav file3-var.wav file4-var.wav $DIR1/wav-stereo/$sfxname$i-$r.wav channels 2 trim 0 $trimvalue fade t 0 0 $fadeoutvalue norm -1
        done

    # mix file 1-4 together into finalX.wav (mono)
    # echo "mixing file1.wav - file4.wav together into $sfxname$1-mono.wav"
    # sox -V1 -M file1.wav file2.wav file3.wav file4.wav $DIR1/wav-mono/$sfxname$i-mono.wav trim 0 $trimvalue fade t 0 0 $fadeoutvalue remix - norm -1

done

 echo "delete temp files: file1.wav file2.wav file3.wav file4.wav tempfile1.wav tempfile2.wav tempfile3.wav tempfile4.wav"
    rm *.wav #file1.wav file2.wav file3.wav file4.wav tempfile1.wav tempfile2.wav tempfile3.wav tempfile4.wav


    #create ui sounds
    source ui.sh