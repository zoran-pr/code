#!/bin/bash

# This script will:
# mp4: remove comments and set Tile=file-name
# ffmpeg -i video.mp4 -vcodec copy -acodec copy video_fixed.mp4
# mkv: remove global tags and set title=file-name 
# mkvpropedit movie.mkv --edit info --set "title=The movie" --edit track:a1 --set language=fre --edit track:a2 --set language=ita

# Require Input if we are to use switches
#: ${1?Need a value: < PATH | Custom searh parm for find -name ex. [0-Z] >}

# declaring array
declare -a video_arr

if [ -z "$1" ] ; then
    file_path=${PWD}
else
    file_path="$1"
fi

# find all video files and store them into array
readarray -t video_arr < <(\
find "${file_path}" \
-type f \
-exec file -N -i -- {} + | \
sed -n 's!: video/[^:]*$!!p' | \
sort )

for src in "${video_arr[@]}"; do
    src_title="${src##*/}"
    src_ext="${src_title##*.}"
    new_title="${src_title%.*}"
    
    new_title=${new_title//___/ - }
    new_title=${new_title//_/ }
    # new_title=${new_title//./ }
    num_video=`command mediainfo "--Inform=General;%VideoCount%" "${src}"`
    num_audio=`command mediainfo "--Inform=General;%AudioCount%" "${src}"`
    num_subs=`command mediainfo "--Inform=General;%TextCount%" "${src}"`
        
    if [ "${src_ext}" == 'mkv' ]; then
        # first remove global tag and title 
        mkvpropedit --quiet --tags global:  --edit info --set "title=${new_title}"  "${src}"

        v=1
        while [[ $v -le "${num_video}" ]] ; do
            mkvpropedit --quiet --edit track:v"${v}" --set "name="  "${src}"
            ((v++))
        done
    
        # to do or not to do?? audio and subtitle metatags
        a=1
        while [[ $a -le "${num_audio}" ]] ; do
            mkvpropedit --quiet --edit track:a"${a}" --set "name="  "${src}"
            ((a++))
        done
    
        s=1
        while [[ $s -le "${num_subs}" ]] ; do
            mkvpropedit --quiet --edit track:s"${s}" --set "name="  "${src}"
            ((s++))
        done
    elif [ "${src_ext}" == "wmv" ]; then
        echo "${src}"
        echo "wmv not supported for now..."
    else
        dir_name=$(dirname "${src}")
        tmp_file="${dir_name}/.${src_title}"
        ffmpeg -i "${src}" -loglevel panic -vcodec copy -acodec copy -metadata "title=${new_title}" -metadata "comment=" "${tmp_file}"
        echo "Moving: ${tmp_file} --> ${src}"
        mv "${tmp_file}" "${src}"
    fi
echo ""
done
