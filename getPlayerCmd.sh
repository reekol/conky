#!/bin/sh

#Get command
case $1 in
    'play-pause')
        cmd='/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause';;
    'next')
        cmd='/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next';;
    'previous')
        cmd='/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous';;
    'stop')
        cmd='/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop';;
    'info')
    	cmd='/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata';;
    *)
esac

#Send command to qdbus
if [[ `qdbus | egrep -i 'org.mpris.MediaPlayer2|plasma-browser-integration' | wc -l` -eq 1 ]]; then
    qdbus `qdbus | egrep -i 'org.mpris.MediaPlayer2|plasma-browser-integration'` $cmd
else
    qdbus `cat $PWD/cache/currentPlaying.txt` $cmd
fi

unset cmd
