#!/bin/bash

function 3dsSetup() {
    if [[ $1 == "new" ]]
    then
        ffmpeg -loglevel panic -i $2 -acodec $3 -vcodec $4 -s $5 -r 30 -preset fast -profile:v baseline $6
    elif [[ $1 == "old" ]]
    then
        ffmpeg -loglevel panic -i $2 -acodec $3 -vcodec $4 -s $5 -r 30 -q:v 15 $6
    fi
}

function dsSetup() {
    ffmpeg -loglevel panic -i $IFILE -f mp4 -vf "fps=24000/1001, colorspace=space=ycgco:primaries=bt709:trc=bt709:range=pc:iprimaries=bt709:iall=bt709, scale=256:144" -dst_range 1 -color_range 2 -vcodec mpeg4 -profile:v 0 -level 8 -q:v 2 -maxrate 500k -acodec aac -ar 32k -b:a 64000 -ac 1 -slices 1 -g 50 $OFILE
}

if [[ -e /usr/bin/ffmpeg ]] || [[ -e /usr/local/bin/ffmpeg ]]
then
    echo "FFMPEG found!"
    read -p "What console are you using 3ds/ds?: " CONSOLE_TYPE
    
    if [[ $CONSOLE_TYPE == "3ds" ]]
    then
        read -p "Are we using the old or new codec? (old/new): " CODEC_TYPE
        read -p "What audio codec should be used? (aac/mp3): " AUDIO_CODEC
        echo -e "Select a video resolution(eg. 1, 2, 3, 4)\n1. 144p\n2. 240p\n3. 360p\n4. 460p\n5. 480p"
        read RES_SELECTION
        echo -e "Select a video codec:\n1. mpeg1video\n2. mpeg2video\n3. h263p\n4. libx264"
        read VID_SELECTION
      
        case $VID_SELECTION in
        1)
            VID_CODEC="mpeg1video"
            ;;
        2)
            VID_CODEC="mpeg2video"
            ;;
        3)
            VID_CODEC="h263p"
            ;;
        4)
            VID_CODEC="libx264"
            ;;
        esac

        case $RES_SELECTION in
        1) 
            RESOULUTION="256x144"
            ;;
        2)
            RESOULUTION="426x240"
            ;;
        3)
            RESOULUTION="640x360"
            ;;
        4)
            RESOULUTION="800x240"
            ;;
        5) 
            RESOULUTION="854x480"
            ;;
        esac

        read -p "Enter the name of the input file: " IFILE
        read -p "Enter the name of the output file (ex. output.mp4): " OFILE
        
        if [[ -e ./$IFILE ]]
        then 
            3dsSetup $CODEC_TYPE $IFILE $AUDIO_CODEC $VID_CODEC $RESOULUTION $OFILE
        else
            echo "File does not exsist!"
        fi

    elif [[ $CONSOLE_TYPE == "ds" ]]
    then
        read -p "Enter the name of the input file: " IFILE
        read -p "Enter the name of the output file (ex. output.mp4): " OFILE
        dsSetup $IFILE $OFILE
    else
       echo "Please enter ethier 2ds/ds for a target console" 
    fi
    
else
    echo "FFMPEG either is not installed or could not be located in your PATH"
fi
