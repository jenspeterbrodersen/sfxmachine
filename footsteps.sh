#!/bin/sh

DIR1="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# define source & target dir
footsteps=$DIR1/Slime-universe/themelibrary/footsteps
materials=$DIR1/Slime-universe/baselibrary/materials
targetdir=$DIR1/Slime-universe/Slime-universe/footsteps

IFS='
'
# 100 = 1 semitone
speedmin=-200
speedmax=200

echo "materials location: $materials"
echo "footsteps location: $footsteps"
echo "targetdir location: $targetdir $IFS"


# Get number of files in material source folder
if [[ -d "${materials}" ]]
    
    then
        materialfile_matrix=($(ls "${materials}"))
        num_materialfiles=${#materialfile_matrix[*]}
        # echo "num_materialfiles = $num_materialfiles"
fi

# Get number of files in footsteps source folder
if [[ -d "${footsteps}" ]];
    
    then
        footstepfile_matrix=($(ls "${footsteps}"))
        num_footstepfiles=${#footstepfile_matrix[*]}

fi

# echo "materials = $num_materialfiles"
# echo "footsteps = $num_footstepfiles"


# Debug arrays
# echo "Array items and indexes:"
# for index in ${!materialfile_matrix[*]}
# do
#     printf "%4d: %s\n" $index ${materialfile_matrix[$index]}
# done


# Loop though each footstep and mix with each material 
# First the Footsteps
for footcount in `seq 0 $(($num_footstepfiles-1))`;
    do
        currentfootstep=$footsteps/${footstepfile_matrix[$footcount]}
        footfile=${footstepfile_matrix[$footcount]}

        # echo "currentfootstep = $currentfootstep"
        # echo "footstep-filename = $footfile $IFS"

        # Then loop through each material
        for materialcount in `seq 0 $(($num_materialfiles-1))`;
            do
                # echo "materialcount = $materialcount"
                currentmaterial=$materials/${materialfile_matrix[$materialcount]}
                materialfile=${materialfile_matrix[$materialcount]}
                materialname=$(echo $materialfile | cut -f 1 -d '.');
        
                # echo "currentmaterial = $currentmaterial"
                # echo "material-filename = $materialfile"

                # ...and then mix them together                
                echo "Creating footstep $materialcount: $footfile ($speedvalue) + $materialfile"

                # Add random pitch to footsteps
                speedvalue=$((RANDOM % ($speedmax-$speedmin) + $speedmin))
                sox -V1 $currentfootstep currentfootstep_temp.wav speed $speedvalue"c" 

                # Add fadein on materials
                sox -V1 $currentmaterial currentmaterial_temp.wav fade t 0.1 0

                # Mix footstep and material together
                sox -V1 -M currentfootstep_temp.wav -v0.9 currentmaterial_temp.wav $targetdir/footstep_0$((footcount+1))_$materialname.wav remix -


            done
            # Remove temp audiofiles
            rm currentfootstep_temp.wav
            rm currentmaterial_temp.wav
            echo "$IFS""Footsteps completed...$IFS"
    done


