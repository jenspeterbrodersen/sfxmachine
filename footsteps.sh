#!/bin/sh

# define source & target dir
sourcedir_theme=/Slime-universe/themelibrary/footsteps/
sourcedir_base=/Slime-universe/baselibrary/materials/
targetdir=/Slime-universe/Slime-universe/footsteps/
footstepsamount=10
DIR=$sourcedir_base
IFS='
'
speedmin=-300
speedmax=500


echo "sourcedir_base: $sourcedir_base"
echo "sourcedir_theme $sourcedir_theme"
echo "targetdir $targetdir"


for i in `seq 1 $footstepsamount`;
    do
        # define variables
        speedvalue=$((RANDOM % ($speedmax-$speedmin+1) + $speedmin))
        # panleft=$((RANDOM % 10))
        # panright=$((RANDOM % 10))
        delayfloat=$((RANDOM % 2))

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
                        echo "this file is mono creating $tempfoot.wav" 
                        sox -V1 $currentfile tempfoot.wav remix 1 1 norm -1
                    else
                        echo "this file is stereo creating tempfoot.wav"
                        sox -V1 $currentfile tempfoot.wav norm -1
                fi
                
                # mix footstep from baselibrary with materialsound and themedlibrarysounds
                sox tempfoot.wav $targetdir/filefoot.wav speed "$speedvalue"c delay 0."$delayfloat" 0."$delayfloat" norm -1
        fi
    done