# Pick a random file from the source folder
echo "picking random folder"
 
if [[ -d "${sourcepath}" ]]
    
    then
        file_matrix=($(ls "${sourcepath}"))
        num_files=${#file_matrix[*]}

        # Create the temp audio wav files for later merging
        currentfile=$sourcepath/${file_matrix[$((RANDOM%num_files))]}
        echo "picking file: $currentfile"

       
        # Check if file is mono, then create random panning
        channelcheck=($(soxi -c $currentfile))

        if (($channelcheck == 1)); 
            then
                echo "this file is mono creating $channelconvert$ii.wav and adding panning: left $panleft, right $panright" 
                sox -V1 $currentfile channelconvert$ii.wav remix 1v0.$panleft 1v0.$panright norm -1
            else
                echo "this file is stereo creating channelconvert$ii.wav"
                sox -V1 $currentfile channelconvert$ii.wav norm -1
        fi
        
        # Add effects
        echo "adding maineffects chain"
        source maineffects.sh   

fi