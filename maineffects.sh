# Add reverse effect at random intervals, then add pitch (speed) variation, and offset playback (delay) to each audiofile

v=$((RANDOM % 15))

if (( v == 0 )); 
    then
        sox -V1 channelconvert$ii.wav file$ii.wav speed "$speedvalue"c delay 0."$delayfloat" 0."$delayfloat" reverse norm -1
else    
    sox -V1 channelconvert$ii.wav file$ii.wav speed "$speedvalue"c delay 0."$delayfloat" 0."$delayfloat" norm -1
fi