#!/bin/bash
# Find and convert (avi, mpg, asf, fla and vwm) video files
# with parallel NVENC
# HandBrake 1.5.1

# User Adjustable variables
nvenc_instances=2
delete_LOG=false
# scipt testing, it will rename original to .bak
backup_enable=false

presetImport="~/XMKV480p30Q23.json"
presetImport="~/media-export/mkv-x265-hq-31-dual-audio.json"
preset_name="mkv-x265-hq-31"

# HandbrakeCLI --encoder-preset
presetAVI="fast"
presetMPG="faster"

# --encoder-tune
# film, animation, grain
tuneAVI="film"
tuneMPG="film"

# HandbrakeCLI -q
crfAVI="22"
crfMPG="23"

# ffmpef -crf
crfWMV="24"
crfFLA="26"
crfASF="26"

# Require Input if using switches
#: ${1?Need a value: < PATH | Custom searh parm for find -name ex. [0-Z] >}
: ${2?Need a value: < PATH | Custom searh parm for find -name ex. [0-Z] or "" >}

# Arrays
declare -l video_ext
declare -a video_arr
declare -a p1_arr
declare -a p2_arr
declare -a p3_arr
declare -a p4_arr

# experiment
#need to install pwgen package
#if [ $(dpkg-query -W -f='${Status}' pwgwn 2>/dev/null | grep -c "ok installed") -eq 0 ];
#then
#   echo "We need to install 'pwgen' for creating random folders"
#  sudo apt-get install pwgen;
#fi
#
#tmpDir ='pwgen -s 13'

# Check for given path, -if none assign 'pwd'
if [ -z "$1" ]; then
    file_path=${PWD}
else
    file_path="$1"
fi

if [[ ! -z ${2} ]]; then
  part=${2//[}
  part=${part//]}
  doneFile="${file_path}/0_converted-videos_${part}.sh"
else
  doneFile="${file_path}/0_converted-videos.sh"
fi

doneDir="${file_path}/0-Done-Converting"

# find all video files and store them into array
readarray -t video_arr < <(\
find "${file_path}" \
-type f \
-exec file -N -i -- {} + | \
sed -n 's!: video/[^:]*$!!p' | \
sort )

# Total number of video files
video_files_no=${#video_arr[@]}

## HandBrakeCLI preset
if [ ${enable_local_preset} == true ]; then    
# dual audio preset
mkv_x265_hq_30_dual_audio=$(cat <<-EOF
{
    "PresetList": [
        {
            "AlignAVStart": false,
            "AudioCopyMask": [
                "copy:aac",
                "copy:ac3"
            ],
            "AudioEncoderFallback": "av_aac",
            "AudioLanguageList": [],
            "AudioList": [
                {
                    "AudioBitrate": 160,
                    "AudioCompressionLevel": -1.0,
                    "AudioDitherMethod": "auto",
                    "AudioEncoder": "av_aac",
                    "AudioMixdown": "dpl2",
                    "AudioNormalizeMixLevel": false,
                    "AudioSamplerate": "auto",
                    "AudioTrackDRCSlider": 0.0,
                    "AudioTrackGainSlider": 0.0,
                    "AudioTrackQuality": 1.0,
                    "AudioTrackQualityEnable": false
                },
                {
                    "AudioBitrate": 160,
                    "AudioCompressionLevel": -1.0,
                    "AudioDitherMethod": "auto",
                    "AudioEncoder": "copy:ac3",
                    "AudioMixdown": "dpl2",
                    "AudioNormalizeMixLevel": false,
                    "AudioSamplerate": "auto",
                    "AudioTrackDRCSlider": 0.0,
                    "AudioTrackGainSlider": 0.0,
                    "AudioTrackQuality": 1.0,
                    "AudioTrackQualityEnable": false
                }
            ],
            "AudioSecondaryEncoderMode": true,
            "AudioTrackSelectionBehavior": "first",
            "ChapterMarkers": true,
            "ChildrenArray": [],
            "Default": false,
            "FileFormat": "av_mkv",
            "Folder": false,
            "FolderOpen": false,
            "InlineParameterSets": false,
            "Mp4HttpOptimize": true,
            "Mp4iPodCompatible": false,
            "PictureAutoCrop": true,
            "PictureBottomCrop": 0,
            "PictureCombDetectCustom": "",
            "PictureCombDetectPreset": "default",
            "PictureDARWidth": 0,
            "PictureDeblock": 0,
            "PictureDeblockCustom": "qp=0:mode=2",
            "PictureDeinterlaceCustom": "",
            "PictureDeinterlaceFilter": "decomb",
            "PictureDeinterlacePreset": "default",
            "PictureDenoiseCustom": "",
            "PictureDenoiseFilter": "off",
            "PictureDenoisePreset": "",
            "PictureDenoiseTune": "none",
            "PictureDetelecine": "off",
            "PictureDetelecineCustom": "",
            "PictureForceHeight": 0,
            "PictureForceWidth": 0,
            "PictureHeight": 0,
            "PictureItuPAR": false,
            "PictureKeepRatio": true,
            "PictureLeftCrop": 0,
            "PictureLooseCrop": false,
            "PictureModulus": 2,
            "PicturePAR": "loose",
            "PicturePARHeight": 800,
            "PicturePARWidth": 801,
            "PictureRightCrop": 0,
            "PictureRotate": "disable=1",
            "PictureSharpenCustom": "",
            "PictureSharpenFilter": "off",
            "PictureSharpenPreset": "",
            "PictureSharpenTune": "",
            "PictureTopCrop": 0,
            "PictureWidth": 0,
            "PresetDescription": "H.264 video (up to 1080p30) and AAC stereo audio, in an MP4 container.",
            "PresetName": "mkv-x265-hq-30-dual-audio",
            "SubtitleAddCC": false,
            "SubtitleAddForeignAudioSearch": true,
            "SubtitleAddForeignAudioSubtitle": false,
            "SubtitleBurnBDSub": true,
            "SubtitleBurnBehavior": "foreign",
            "SubtitleBurnDVDSub": true,
            "SubtitleLanguageList": [],
            "SubtitleTrackSelectionBehavior": "none",
            "Type": 1,
            "UsesPictureFilters": true,
            "UsesPictureSettings": 2,
            "VideoAvgBitrate": 6000,
            "VideoColorMatrixCode": 0,
            "VideoEncoder": "nvenc_h265",
            "VideoFramerate": "29.97",
            "VideoFramerateMode": "pfr",
            "VideoGrayScale": false,
            "VideoLevel": "auto",
            "VideoOptionExtra": "",
            "VideoPreset": "hq",
            "VideoProfile": "main",
            "VideoQSVAsyncDepth": 4,
            "VideoQSVDecode": false,
            "VideoQualitySlider": 30.0,
            "VideoQualityType": 2,
            "VideoScaler": "swscale",
            "VideoTune": "",
            "VideoTurboTwoPass": true,
            "VideoTwoPass": true,
            "x264Option": "",
            "x264UseAdvancedOptions": false
        }
    ],
    "VersionMajor": 34,
    "VersionMicro": 0,
    "VersionMinor": 0
}
EOF
)

# default preset
mkv_x265_hq_30=$(cat <<-EOF
{
    "PresetList": [
        {
            "AlignAVStart": false,
            "AudioCopyMask": [
                "copy:aac",
                "copy:ac3"
            ],
            "AudioEncoderFallback": "av_aac",
            "AudioLanguageList": [],
            "AudioList": [
                {
                    "AudioBitrate": 160,
                    "AudioCompressionLevel": -1.0,
                    "AudioDitherMethod": "auto",
                    "AudioEncoder": "av_aac",
                    "AudioMixdown": "dpl2",
                    "AudioNormalizeMixLevel": false,
                    "AudioSamplerate": "auto",
                    "AudioTrackDRCSlider": 0.0,
                    "AudioTrackGainSlider": 0.0,
                    "AudioTrackQuality": 1.0,
                    "AudioTrackQualityEnable": false
                }
            ],
            "AudioSecondaryEncoderMode": true,
            "AudioTrackSelectionBehavior": "first",
            "ChapterMarkers": true,
            "ChildrenArray": [],
            "Default": false,
            "FileFormat": "av_mkv",
            "Folder": false,
            "FolderOpen": false,
            "InlineParameterSets": false,
            "Mp4HttpOptimize": true,
            "Mp4iPodCompatible": false,
            "PictureAutoCrop": true,
            "PictureBottomCrop": 0,
            "PictureCombDetectCustom": "",
            "PictureCombDetectPreset": "default",
            "PictureDARWidth": 0,
            "PictureDeblock": 0,
            "PictureDeblockCustom": "qp=0:mode=2",
            "PictureDeinterlaceCustom": "",
            "PictureDeinterlaceFilter": "decomb",
            "PictureDeinterlacePreset": "default",
            "PictureDenoiseCustom": "",
            "PictureDenoiseFilter": "off",
            "PictureDenoisePreset": "",
            "PictureDenoiseTune": "none",
            "PictureDetelecine": "off",
            "PictureDetelecineCustom": "",
            "PictureForceHeight": 0,
            "PictureForceWidth": 0,
            "PictureHeight": 0,
            "PictureItuPAR": false,
            "PictureKeepRatio": true,
            "PictureLeftCrop": 0,
            "PictureLooseCrop": false,
            "PictureModulus": 2,
            "PicturePAR": "loose",
            "PicturePARHeight": 1,
            "PicturePARWidth": 1,
            "PictureRightCrop": 0,
            "PictureRotate": "disable=1",
            "PictureSharpenCustom": "",
            "PictureSharpenFilter": "off",
            "PictureSharpenPreset": "",
            "PictureSharpenTune": "",
            "PictureTopCrop": 0,
            "PictureWidth": 0,
            "PresetDescription": "H.264 video (up to 1080p30) and AAC stereo audio, in an MP4 container.",
            "PresetName": "mkv-x265-hq-30",
            "SubtitleAddCC": false,
            "SubtitleAddForeignAudioSearch": true,
            "SubtitleAddForeignAudioSubtitle": false,
            "SubtitleBurnBDSub": true,
            "SubtitleBurnBehavior": "foreign",
            "SubtitleBurnDVDSub": true,
            "SubtitleLanguageList": [],
            "SubtitleTrackSelectionBehavior": "none",
            "Type": 1,
            "UsesPictureFilters": true,
            "UsesPictureSettings": 2,
            "VideoAvgBitrate": 6000,
            "VideoColorMatrixCode": 0,
            "VideoEncoder": "nvenc_h265",
            "VideoFramerate": "29.97",
            "VideoFramerateMode": "pfr",
            "VideoGrayScale": false,
            "VideoLevel": "auto",
            "VideoOptionExtra": "",
            "VideoPreset": "hq",
            "VideoProfile": "main",
            "VideoQSVAsyncDepth": 4,
            "VideoQSVDecode": false,
            "VideoQualitySlider": 30.0,
            "VideoQualityType": 2,
            "VideoScaler": "swscale",
            "VideoTune": "",
            "VideoTurboTwoPass": true,
            "VideoTwoPass": true,
            "x264Option": "",
            "x264UseAdvancedOptions": false
        }
    ],
    "VersionMajor": 34,
    "VersionMicro": 0,
    "VersionMinor": 0
}
EOF
)

fi

# Create files for each nvemc instance
if [[ $((nvenc_instances)) == 2 ]]; then
    ni2=$(($video_files_no/2))
    
    printf '%s\n' "${video_arr[@]::$ni2}" > 0_nvenc_p1_files
    printf '%s\n' "${video_arr[@]:$ni2}" > 0_nvenc_p2_files

    for videos in "${video_arr[@]::$ni2}"; do
        p1_arr+=("${videos}")
    done

    for videos in "${video_arr[@]:$ni2}"; do
        p2_arr+=("${videos}")
    done
    

elif [[ $((nvenc_instances)) == 3 ]]; then
    ni3p1=$(($video_files_no/3))
    ni3p2=$(($video_files_no/3*2))

    printf '%s\n' "${video_arr[@]::$ni3p1}" > 0_nvenc_p1_files
    printf '%s\n' "${video_arr[@]:$ni3p1:$ni3p1}" > 0_nvenc_p2_files
    printf '%s\n' "${video_arr[@]:$ni3p2}" > 0_nvenc_p3_files

    for v in "${video_arr[@]::$ni3p1}"; do
        p1_arr+=("${v}")
    done

    for v in "${video_arr[@]:$ni3p1:$ni3p1}"; do
        p2_arr+=("${v}")
    done

    for v in "${video_arr[@]:$ni3p2}"; do
        p3_arr+=("${v}")
    done       

elif [[ $((nvenc_instances)) == 4 ]]; then
    ni4p1=$(($video_files_no/4))
    ni4p2=$(($video_files_no/4*2))
    ni4p3=$(($video_files_no/4*3))

    printf '%s\n' "${video_arr[@]::$ni4p1}" > 0_nvenc_p1_files
    printf '%s\n' "${video_arr[@]:$ni4p1:$ni4p1}" > 0_nvenc_p2_files
    printf '%s\n' "${video_arr[@]:$ni4p2:$ni4p1}" > 0_nvenc_p3_files
    printf '%s\n' "${video_arr[@]:$ni4p3}" > 0_nvenc_p4_files

    for videos in "${video_arr[@]::$ni4p1}"; do
        p1_arr+=("${videos}")
    done

    for v in "${video_arr[@]:$ni4p1:$ni4p1}"; do
        p2_arr+=("${v}")
    done

    for v in "${video_arr[@]:$ni4p2:$ni4p1}"; do
        p3_arr+=("${v}")
    done

    for v in "${video_arr[@]:$ni4p3}"; do
        p4_arr+=("${v}")
    done    
    
else
    echo "Maximum nvenc threads is 4"    

fi
# End Create array/files for each nvemc instance

# Create scripts to run
for (( i=1; i<=${nvenc_instances}; i++ )); do    
# 0_nvenc_p1_files
# 0_nvenc_p$i_file
# 0_nvenc_p$i_LOG
# 0_nvenc_p$i_scrip
ni="0_nvenc_p${i}"

# Create LOG/UNDU file
if [[ ! -f "${ni}_LOG" ]]; then
cat > "${ni}_LOG" <<EOL
#!/bin/bash
# This file is having dual purpose.
# 1. If we chose to create backups it wil generate script to remove those backups
# 2. log file, just a log file listing converted files with some extra info.
#
# To remove backup files:
# Make this script executable by running chmod +x on this script
# then just execute thisfile to remove all backed-up videos
# !! Don't forget to remove this file once you are done !!
EOL
fi
# End Create LOG/UNDU file

# Create scripts
cat > "${ni}_script" <<EOL
#!/bin/bash
# Script "${ni}_script"
#
presetX264="$presetX264"
presetAVI="$presetAVI""
presetMPG="$presetMPG""

presetImport="$presetImport"
presetImport="$presetImport"
preset_name="$preset_name"

tuneAVI="$tuneAVI"
tuneMPG="$tuneMPG"

crfAVI="$crfAVI"
crfMPG="$crfMPG"
crfWMV="$crfWMV"
crfFLA="$crfFLA"
crfASF="$crfASF"

video_list=""0_nvenc_${th}_files"
#start

#end
EOL
# End create scripts
done

################################
################################
################################



for video_file in "${video_arr[@]}"; do
    video_name="${video_file##*/}"
    video_ext="${video_name##*.}"

    backup_file="${video_name}.bak"
    dst_mkv="${video_file%\.*}.mkv"
    # change to du -h on POSIX
    src_size=`du -h "${video_file}" | cut -f1`
    echo "# SRC: ${video_file}  ${src_size} | ${videoCodec}" >> "${doneFile}"

    videoCodec=`mediainfo --language=raw --full --inform="Video;%Codec%" ${video_file}`
    videoWidth=`mediainfo --language=raw --full --inform="Video;%Width%" ${video_file}`
    videoHeight=`mediainfo --language=raw --full --inform="Video;%Height%" ${video_file}`
    audio_channels=`mediainfo --language=raw --full --inform="Audio;%Channel(s)%" ${video_file}`

# FFMPEG for ASF, FLV, WMV
if [ $video_ext == "asf" ] || [ $video_ext == "flv" ] || [ $video_ext == "wmv" ]; then
    echo "script extensions ffmpeg" 
    # import variables
    if [ $video_ext == "asf" ]; then
        crf="$crfASF"
    
    elif [ $video_ext == "fla" ]; then
        crf="$crfFLA"
    
    elif [ $video_ext == "wmw" ]; then
        crf="crfWMV"
    
    else
        crf="24"
    
    fi

    if [[ ! -f "${dst_mkv}" ]]; then
        ffmpeg -i "${video_file}" -c:v libx264 -preset medium -crf "${crf}" -r 30000/1001 -tune "${tune}" -c:a aac -b:a 128k -q:a 100  "${dst_mkv}"
        
        dst_size=`du -h "${dst_mkv}" | cut -f1`
        sed  -i "s@# SRC: ${video_file}  ${src_size} | ${videoCodec}@&\n# DST: ${dst_mkv}  ${dst_size} | HandBrakeCLI ${crfWMV}@" "${doneFile}"
        sed  -i "s@# DST: ${dst_mkv}  ${dst_size} | HandBrakeCLI ${crfAVI}@&\nrm -f ${srcBak}@" "${doneFile}"
    
        if [ "${backup_enable}" == "true" ]; then
            echo "Backup"
            # mv -f "${video_file}" "${video_file}".bak
        fi

        #rm -f "${video_file}"

    else
        continue

    fi

# HandBrakeCLI for AVI,MP4, MPG, TS
elif [ $video_ext == "avi" ] || [ $video_ext == "mp4" ] || [ $video_ext == "mpg" ] || [ $video_ext == "ts" ]; then
    echo "script extensions handbrake-cli"
    # import variables
    #  obsolete, using preset in this script
    if [ $video_ext == "avi" ]; then
        tune="$tuneAVI"
        crf="$crfAVI"
    elif [ $video_ext == "mpg" ]; then
        tune="$tuneMPG"
        crf="$crfMPG"
    else
        tune="film"
        crf="22"
    fi

    if [[ ! -f "${dst_mkv}" ]]; then
        # create dual audio if src 6 channel detected
        if [[ "${audio_channels}" == "6" ]]; then
            echo "6 Channel audio detected."
            #HandBrakeCLI -i "${video_file}" -o "${dst_mkv}"   --encoder nvenc_h265 --encopts spatial_aq=1:rc-lookahead=20:b_adapt=0:no-scenecut=1 --preset-import-file ~/media-export/mkv-x265-hq-30-dual-audio.json -Z mkv-x265-hq-30-dual-audio
            # inline json experiment
            HandBrakeCLI -i "${video_file}" -o "${dst_mkv}"  --encopts spatial_aq=1:rc-lookahead=20:b_adapt=0:no-scenecut=1 --preset-import-gui "${mkv_x265_hq_30_dual_audio}"

        else
            echo "2 Channel audio detected."
            #HandBrakeCLI -i "${video_file}" -o "${dst_mkv}"  --encoder nvenc_h265 --encopts spatial_aq=1:rc-lookahead=20:b_adapt=0:no-scenecut=1  --preset-import-file ~/media-export/mkv-x265-hq-30.json -Z mkv-x265-hq-30
            # inline json experiment
            HandBrakeCLI -i "${video_file}" -o "${dst_mkv}"  --encopts spatial_aq=1:rc-lookahead=20:b_adapt=0:no-scenecut=1  --preset-import-gui "${mkv_x265_hq_30}"
            # manual experiment
            ## HandBrakeCLI -i "${video_file}" -o "${dst_mkv}" -O --loose-anamorphic --modulus 2  --encoder nvenc_h265 --encopts spatial_aq=1:rc-lookahead=15 -q 30 --encoder-profile auto --encoder-level auto --encoder-preset slow -a 1 --aencoder ffaac --ab 128 --arate 48 --drc 1 --gain 6 --mixdown dpl2 --normalize-mix 0 --audio-copy-mask aac,ac3,dtshd,dts,mp3 --audio-fallback ffac3

        fi

        # nvenc_h265
      
        dst_size=`du -h "${dst_mkv}" | cut -f1`
        sed  -i "s@# SRC: ${video_file}  ${src_size} | ${videoCodec}@&\n# DST: ${dst_mkv}  ${dst_size} | HandBrakeCLI ${crfMPG}@" "${doneFile}"
        sed  -i "s@# DST: ${dst_mkv}  ${dst_size} | HandBrakeCLI ${crfAVI}@&\nrm -f ${srcBak}@" "${doneFile}"
        
        if [ "${backup_enable}" == "true" ]; then
            echo "Backup"
            # mv -f "${video_file}" "${video_file}".bak
        fi

        #rm -f "${video_file}"

    else
        continue
    fi
else
    echo "Not suported."

fi
done

