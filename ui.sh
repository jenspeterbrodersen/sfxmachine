echo "creating UI sounds..."

# Create folders
mkdir $DIR1/wav-stereo/UI;
mkdir $DIR1/wav-mono/UI;


# Run this loop for as many sfx you need
for i in `seq 1 $amount`;
    do

    # Pick random file in folder
    for ii in `seq 1 4`;
        do
            # Set pitch range 
            speedmin=5000
            speedmax=8000

            speedvalue=$((RANDOM % ($speedmax-$speedmin+1) + $speedmin))
            panleft=$((RANDOM % 10))
            panright=$((RANDOM % 10))
            delayfloat=$((RANDOM % 2))

            # Pick random file
            source pickrandomfile.sh

    done

    echo "Mix file1, 2, 3, 4 together into final"$i".wav"
    
            sox -V1 -M file1.wav file2.wav file3.wav file4.wav $DIR1/wav-stereo/UI/$sfxname$i-ui.wav channels 2 trim 0 0.5 fade t 0 0 0.1 norm -1

            sox -V1 -M file1.wav file2.wav file3.wav file4.wav $DIR1/wav-mono/UI/$sfxname$i-ui-mono.wav trim 0 0.5 fade t 0 0 0.1 remix - norm -1

done

 echo "delete temp files"
    rm file1.wav file2.wav file3.wav file4.wav tempfile1.wav tempfile2.wav tempfile3.wav tempfile4.wav