#!/bin/sh

DIR1="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# define source & target dir
footsteps=$DIR1/Slime-universe/themelibrary/footsteps
materials=$DIR1/Slime-universe/baselibrary/materials
targetdir=$DIR1/Slime-universe/Slime-universe/footsteps

# DIR=$materials
IFS='
'
speedmin=-300
speedmax=500


echo "materials location: $materials"
echo "footsteps location: $footsteps"
echo "targetdir location: $targetdir"


# Get number of files in material source folder
if [[ -d "${materials}" ]]
    
    then
        materialfile_matrix=($(ls "${materials}"))
        num_materialfiles=${#materialfile_matrix[*]}

fi

# Get number of files in footsteps source folder
if [[ -d "${footsteps}" ]];
    
    then
        footstepfile_matrix=($(ls "${footsteps}"))
        num_footstepfiles=${#footstepfile_matrix[*]}

fi

echo "materials = $num_materialfiles"
echo "footsteps = $num_footstepfiles"

# Loop though each footstep and mix with each material 

# First the Footsteps
for footcount in `seq 0 $num_footstepfiles`;
    do
        currentfootstep=$footsteps/${footstepfile_matrix[$footcount]}
        footfilename=${footstepfile_matrix[$footcount]}

        # echo "currentfootstep = $currentfootstep"
        # echo "filename = $footfilename"

        # Then loop through each material
        for materialcount in `seq 0 $num_materialfiles`;
            do
                currentmaterial=$materials/${materialfile_matrix[$materialcount]}
                materialfilename=${materialfile_matrix[$materialcount]}
                materialname=$(echo $materialfilename | cut -f 1 -d '.');
        
                # echo "currentmaterial = $currentmaterial"
                # echo "filename = $materialfilename"

                # ...and mix them together
                echo "Creating footstep: $footfilename + $materialfilename"

                sox -M $currentfootstep -v0.2 $currentmaterial $targetdir/footstep_0$((footcount+1))_$materialname.wav remix -

            done









    
    done


