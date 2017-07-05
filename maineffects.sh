# only use reverse sfx sometimes

v=$((RANDOM % 15))

if (( v == 0 )); 
    then
        sox tempfile$ii.wav file$ii.wav speed "$speedvalue"c delay 0."$delayfloat" 0."$delayfloat" reverse norm
else    
    sox tempfile$ii.wav file$ii.wav speed "$speedvalue"c delay 0."$delayfloat" 0."$delayfloat" norm -1
fi