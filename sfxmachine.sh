#!/bin/sh

# Adding sox to $PATH
export PATH=$PATH:/Applications/sox-14.4.1

# Set current dir as variable DIR1
DIR1="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mkdir $DIR1/wav-stereo;
mkdir $DIR1/wav-mono;

# promt user for details
# echo "path to source audio files"; read sourcepath;
sourcepath=/Applications/sox-14.4.1/testlyde
echo "name of sfx"; read sfxname;
echo "amount"; read amount;
echo "max-length (seconds)"; read trimvalue;
echo "fadeout-length (seconds)"; read fadeoutvalue;

# Run this loop for as many sfx you need
for i in `seq 1 $amount`;
    do

    # Pick random file in folder
    for ii in `seq 1 4`;
        do
            # DIR = location of source audio files 
            DIR=$sourcepath
            IFS='
            '
            speedmin=-300
            speedmax=500
            speedvalue=$((RANDOM % ($speedmax-$speedmin+1) + $speedmin))
            panleft=$((RANDOM % 10))
            panright=$((RANDOM % 10))
            delayfloat=$((RANDOM % 2))

            if [[ -d "${DIR}" ]]
                then
                    file_matrix=($(ls "${DIR}"))
                    num_files=${#file_matrix[*]}

                    # create the temp audio wav files for later merging
                    currentfile=$DIR/${file_matrix[$((RANDOM%num_files))]}

                    channelcheck=($(soxi -c $currentfile))
                    # echo $currentfile

                    if (($channelcheck == 1)); 
                        then
                            sox $currentfile tempfile$ii.wav remix 1v0.$panleft 1v0.$panright
                        else
                            sox $currentfile tempfile$ii.wav 
                            # soxi tempfile$ii.wav
                    fi
                    
                    # external script for main fx-chain
                    source maineffects.sh

            fi

    done

    echo "Mix file1, 2, 3, 4 together into final"$i".wav"
    
            sox -M file1.wav file2.wav file3.wav file4.wav $DIR1/wav-stereo/$sfxname$i.wav channels 2 trim 0 $trimvalue fade t 0 0 $fadeoutvalue norm -1

            # sox $sfxname$i.wav $sfxname$i-faded.wav fade 2 1

            # lame $DIR1/wav-stereo/final$i.wav $DIR1/mp3-stereo/final$i-mp3-128kb.mp3

            sox -M file1.wav file2.wav file3.wav file4.wav $DIR1/wav-mono/$sfxname$i-mono.wav trim 0 $trimvalue fade t 0 0 $fadeoutvalue remix - norm -1

            # lame $DIR1/wav-mono/final$i-mono.wav $DIR1/mp3-mono/final$i-mp3-mono-128kb.mp3 
done

 echo "delete temp files"
    rm file1.wav file2.wav file3.wav file4.wav tempfile1.wav tempfile2.wav tempfile3.wav tempfile4.wav