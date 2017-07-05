#!/bin/sh

# Adding sox to $PATH
export PATH=$PATH:/Applications/sox-14.4.1

# Set current dir as variable DIR1
DIR1="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mkdir $DIR1/wav-stereo;
mkdir $DIR1/wav-mono;
# mkdir $DIR1/mp3-stereo;
# mkdir $DIR1/mp3-mono; 

# echo "DIR1: $DIR1"

# Run this loop for as many sfx you need
for i in `seq 1 50`;
    do

    # Pick random file in folder
    for ii in `seq 1 4`;
        do
            # DIR = location of source audio files 
            DIR="/Applications/sox-14.4.1/Samples"
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
                    echo $currentfile

                    if (($channelcheck == 1)); 
                        then
                            sox $currentfile tempfile$ii.wav remix 1v0.$panleft 1v0.$panright
                        else
                            sox $currentfile tempfile$ii.wav 
                            # soxi tempfile$ii.wav
                    fi
                    
                    # only use reverse sfx sometimes
                    v=$((RANDOM % 15))
                    if (( v == 0 )); 
                        then
                        # echo "reversing $v"
                            # sox $currentfile tempfile.wav $pan
                            sox tempfile$ii.wav file$ii.wav speed "$speedvalue"c delay 0."$delayfloat" 0."$delayfloat" reverse norm
                    else    
                        # echo "normal $v"
                        # sox $currentfile tempfile.wav $pan
                        sox tempfile$ii.wav file$ii.wav speed "$speedvalue"c delay 0."$delayfloat" 0."$delayfloat" norm -1
                    fi
            fi

    done

    echo "Mix file1, 2, 3, 4 together into final"$i".wav"
    
            sox -M file1.wav file2.wav file3.wav file4.wav $DIR1/wav-stereo/final$i.wav channels 2

            # lame $DIR1/wav-stereo/final$i.wav $DIR1/mp3-stereo/final$i-mp3-128kb.mp3

            sox -M file1.wav file2.wav file3.wav file4.wav $DIR1/wav-mono/final$i-mono.wav remix -

            # lame $DIR1/wav-mono/final$i-mono.wav $DIR1/mp3-mono/final$i-mp3-mono-128kb.mp3 
done

 echo "delete temp files"
    rm file1.wav file2.wav file3.wav file4.wav tempfile1.wav tempfile2.wav tempfile3.wav tempfile4.wav