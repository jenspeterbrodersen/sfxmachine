echo "Creating UI sounds..."

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

    # Create the final sfx file by mixing file 1-4.wav together into a single .wav file
    echo "Mix file1, 2, 3, 4 together into final"$i".wav"
    
        sox -V1 -M file1.wav file2.wav file3.wav file4.wav $DIR1/$projectname/$projectname/ui/$sfxname$i-ui.wav channels 2 trim 0 0.5 fade t 0 0 0.1 norm -1

done

# Delete temp files
echo "delete temp files"
rm *.wav 