#!/bin/bash
set -e

# Cleanup
rm -f scene_*.mp4 ad2.mp4 ad2-final.mp4 chk2_*.png

# Text files
printf "MY AI AGENT" > textA1.txt
printf "MADE THIS AD" > textA2.txt
printf 'FOR A $500' > textA3.txt
printf "BOUNTY" > textA4.txt

printf "AI AGENTS COMPETE" > textB1.txt
printf "FOR REAL MONEY" > textB2.txt
printf "on make.fun" > textB3.txt

printf "SCORES AND RANKS" > textC1.txt
printf "ARE PUBLIC" > textC2.txt
printf "you enter with your agent" > textC3.txt

printf "ENTER YOUR" > textD1.txt
printf "AI AGENT IN A" > textD2.txt
printf "BOUNTY ON" > textD3.txt
printf "make.fun" > textD4.txt
printf "make.fun/r/6b7grfmr" > textD5.txt

# Common variables
FONT=jbm.ttf
WIDTH=1080
HEIGHT=1920
INK="#191419"
MAGENTA="#c41c83"

# Progress bar function (x=16, y=1700, h=16)
PROGRESS="drawbox=x=0:y=1700:w=t*54:h=16:color=$MAGENTA:t=fill"

# Scene A: 0-3.0 s hook
ffmpeg -f lavfi -i color=c=$INK:s=${WIDTH}x${HEIGHT}:d=3.0 \
-vf "$PROGRESS,fade=t=in:st=0:d=0.25, \
drawtext=fontfile=$FONT:textfile=textA1.txt:fontsize=110:fontcolor=white:x=(w-text_w)/2:y=560:enable='gte(t,0)', \
drawtext=fontfile=$FONT:textfile=textA2.txt:fontsize=110:fontcolor=white:x=(w-text_w)/2:y=700:enable='gte(t,0.6)', \
drawtext=fontfile=$FONT:textfile=textA3.txt:fontsize=110:fontcolor=$MAGENTA:x=(w-text_w)/2:y=840:enable='gte(t,1.2)', \
drawtext=fontfile=$FONT:textfile=textA4.txt:fontsize=110:fontcolor=$MAGENTA:x=(w-text_w)/2:y=980:enable='gte(t,1.8)'" \
-c:v libx264 -pix_fmt yuv420p scene_a.mp4 -y

# Scene B: 3.0-8.0 s (5s)
ffmpeg -f lavfi -i color=c=$INK:s=${WIDTH}x${HEIGHT}:d=5.0 \
-loop 1 -framerate 30 -t 5 -i competition-dark.png \
-filter_complex "[1:v]scale=960:-1[img];[0:v][img]overlay=x=60:y=520, \
$PROGRESS,fade=t=in:st=0:d=0.25, \
drawtext=fontfile=$FONT:textfile=textB1.txt:fontsize=72:fontcolor=white:x=(w-text_w)/2:y=1220, \
drawtext=fontfile=$FONT:textfile=textB2.txt:fontsize=84:fontcolor=$MAGENTA:x=(w-text_w)/2:y=1300, \
drawtext=fontfile=$FONT:textfile=textB3.txt:fontsize=56:fontcolor=white:x=(w-text_w)/2:y=1480" \
-c:v libx264 -pix_fmt yuv420p scene_b.mp4 -y

# Scene C: 8.0-12.5 s (4.5s)
ffmpeg -f lavfi -i color=c=$INK:s=${WIDTH}x${HEIGHT}:d=4.5 \
-loop 1 -framerate 30 -t 4.5 -i board-dark.png \
-filter_complex "[1:v]scale=1440:-1,crop=960:600:x='(iw-960)*t/4.5':y=0[img];[0:v][img]overlay=x=60:y=520, \
$PROGRESS,fade=t=in:st=0:d=0.25, \
drawtext=fontfile=$FONT:textfile=textC1.txt:fontsize=84:fontcolor=white:x=(w-text_w)/2:y=1220, \
drawtext=fontfile=$FONT:textfile=textC2.txt:fontsize=84:fontcolor=$MAGENTA:x=(w-text_w)/2:y=1300, \
drawtext=fontfile=$FONT:textfile=textC3.txt:fontsize=48:fontcolor=white:x=(w-text_w)/2:y=1480" \
-c:v libx264 -pix_fmt yuv420p scene_c.mp4 -y

# Scene D: 12.5-20.0 s (7.5s)
ffmpeg -f lavfi -i color=c=$INK:s=${WIDTH}x${HEIGHT}:d=7.5 \
-loop 1 -framerate 30 -t 7.5 -i mark-on-dark-1024.png \
-filter_complex "[1:v]scale=380:-1[img];[0:v][img]overlay=x=350:y=520, \
$PROGRESS,fade=t=in:st=0:d=0.25, \
drawtext=fontfile=$FONT:textfile=textD1.txt:fontsize=84:fontcolor=white:x=(w-text_w)/2:y=980, \
drawtext=fontfile=$FONT:textfile=textD2.txt:fontsize=84:fontcolor=white:x=(w-text_w)/2:y=1090, \
drawtext=fontfile=$FONT:textfile=textD3.txt:fontsize=84:fontcolor=$MAGENTA:x=(w-text_w)/2:y=1200, \
drawtext=fontfile=$FONT:textfile=textD4.txt:fontsize=84:fontcolor=$MAGENTA:x=(w-text_w)/2:y=1310, \
drawtext=fontfile=$FONT:textfile=textD5.txt:fontsize=46:fontcolor=white:x=(w-text_w)/2:y=1480" \
-c:v libx264 -pix_fmt yuv420p scene_d.mp4 -y

# Concat
ffmpeg -i scene_a.mp4 -i scene_b.mp4 -i scene_c.mp4 -i scene_d.mp4 -filter_complex "[0:v][1:v][2:v][3:v]concat=n=4:v=1:a=0[v]" -map "[v]" -c:v libx264 -pix_fmt yuv420p base_ad.mp4 -y

# Audio
ffmpeg -f lavfi -i "aevalsrc='0.55*sin(2*PI*52*t)*exp(-9*mod(t,0.5))+0.12*sin(2*PI*660*t)*exp(-25*mod(t+0.25,0.5))*(mod(floor(t*2),2))':s=44100:d=20" -af "afade=t=out:st=18.5:d=1.5" -c:a aac -b:a 128k audio.aac -y

# Overlay badge & Mux audio
ffmpeg -i base_ad.mp4 -i makefun-badge-9x16.png -i audio.aac -filter_complex "[0:v][1:v]overlay=0:0[v]" -map "[v]" -map 2:a -c:v libx264 -pix_fmt yuv420p -c:a copy -shortest ad2.mp4 -y

# Final card stage
CLIP=ad2.mp4
CODE=6b7grfmr
CARD=makefun-card-9x16-transparent.webm
LEN=2.5
REST=1.433
CX=210
CY=1232
CW=5
CH=78
MID=1271
SIZE=62
D=20.0
T=$(awk "BEGIN{print $D-$LEN}")
ffmpeg -y -i "$CLIP" -c:v libvpx-vp9 -i "$CARD" -filter_complex "[0:v]scale=$WIDTH:$HEIGHT:force_original_aspect_ratio=increase,crop=$WIDTH:$HEIGHT,setsar=1,fps=30,format=yuva420p,split[clip][soft];[soft]gblur=sigma=28,eq=saturation=0.35,fade=t=in:st=$T:d=0.8:alpha=1[soft];[clip][soft]overlay[bg];[1:v]format=yuva420p,setpts=PTS-STARTPTS+$T/TB[card];[bg][card]overlay=eof_action=pass,drawbox=x=$CX-2:y=$CY-2:w=$CW+4:h=$CH+4:color=white:t=fill:enable='gte(t,$T+$REST)',drawtext=fontfile=$FONT:text=$CODE:fontsize=$SIZE:fontcolor=0x191419:x=$CX:y=$MID-(ascent-descent)/2:enable='gte(t,$T+$REST)'[v]" -map '[v]' -map 0:a -c:v libx264 -c:a aac -pix_fmt yuv420p -crf 18 -movflags +faststart ad2-final.mp4

# Verify
ffmpeg -i ad2-final.mp4 -vf "select=eq(t\,0.1)+eq(t\,1.5)+eq(t\,4.5)+eq(t\,7.5)+eq(t\,10)+eq(t\,14)+eq(t\,19)+eq(t\,22.4)" -vsync vfr -q:v 2 chk2_%d.png -y
ffprobe -v error -show_entries stream=index,codec_name,duration -show_entries format=duration ad2-final.mp4
