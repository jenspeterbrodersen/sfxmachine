echo "creating UI sounds..."

mkdir $DIR1/wav-stereo/UI;
mkdir $DIR1/wav-mono/UI;


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
            speedmin=3000
            speedmax=6000
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
                            sox $currentfile tempfile$ii.wav remix 1v0.$panleft 1v0.$panright norm -1
                        else
                            sox $currentfile tempfile$ii.wav norm -1
                            # soxi tempfile$ii.wav
                    fi
                    
                    # external script for main fx-chain
                    source maineffects.sh

            fi

    done

    echo "Mix file1, 2, 3, 4 together into final"$i".wav"
    
            sox -V1 -M file1.wav file2.wav file3.wav file4.wav $DIR1/wav-stereo/UI/$sfxname$i-ui.wav channels 2 trim 0 0.5 fade t 0 0 0.1 norm -1

            # sox $sfxname$i.wav $sfxname$i-faded.wav fade 2 1

            # lame $DIR1/wav-stereo/final$i.wav $DIR1/mp3-stereo/final$i-mp3-128kb.mp3

            sox -V1 -M file1.wav file2.wav file3.wav file4.wav $DIR1/wav-mono/UI/$sfxname$i-ui-mono.wav trim 0 0.5 fade t 0 0 0.1 remix - norm -1

            # lame $DIR1/wav-mono/final$i-mono.wav $DIR1/mp3-mono/final$i-mp3-mono-128kb.mp3 
done

 echo "delete temp files"
    rm file1.wav file2.wav file3.wav file4.wav tempfile1.wav tempfile2.wav tempfile3.wav tempfile4.wav