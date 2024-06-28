#!/bin/bash -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
AI_IMAGES_DIRECTORY=$SCRIPT_DIR/ai-images
AI_IMAGES_COUNT=$(ls 2>/dev/null -Ubad1 -- "$AI_IMAGES_DIRECTORY"/* | wc -l)
TEAMS_BG_DIRECTORY=~/Library/Containers/com.microsoft.teams2/Data/Library/Application\ Support/Microsoft/MSTeams/Backgrounds/Uploads
TEAMS_BG_FILE_COUNT=$(ls 2>/dev/null -Ubad1 -- "$TEAMS_BG_DIRECTORY"/* | wc -l)
STATIC_UUID="C30ABE74-2415-43FD-9278-1AFCDD19AA3F"

if [[ $AI_IMAGES_COUNT -eq 0 ]]
then
    echo "[ERROR]"
    echo "$AI_IMAGES_COUNT files are in: $AI_IMAGES_DIRECTORY"
    echo "We would expect this directoory to contain your AI generated images"
    echo "Ensure you've ready the readme.md and generated some images"
    exit;
fi

if [[ $TEAMS_BG_FILE_COUNT -gt 2 ]]
then
    echo "[ERROR]"
    echo "$TEAMS_BG_FILE_COUNT files are in: $TEAMS_BG_DIRECTORY"
    echo "Remove all the files with: rm $TEAMS_BG_DIRECTORY/*"
    echo "But this will delete ALL your custom backgrounds so backup first"
    exit;
fi

if [[ "$(pmset -g | grep ' sleep')" == *"coreaudiod"* ]]
then 
    echo "[ERROR]"
    echo "Audio devices are being used so we're not changing your bg"
    echo "Try and the end of your teams call"
    exit;
else
    echo "[INFO] - removing old background images"
    rm "$TEAMS_BG_DIRECTORY"/* || true
    
    echo "[INFO] - we'll staticly name the new image: $STATIC_UUID.png"
    uuid_static="$STATIC_UUID"

    # Get random file
    echo "[INFO] - Getting random image from $AI_IMAGES_DIRECTORY"
    ls $AI_IMAGES_DIRECTORY/*.png|sort -R |tail -1 |while read file; do
        echo "[INFO] - Copying $file to be your new teams bg"
        cp $file "$TEAMS_BG_DIRECTORY/${uuid_static}_thumb.png"
        cp $file "$TEAMS_BG_DIRECTORY/$uuid_static.png"
    done

    echo "[INFO] - Your background should change now"
fi
echo "Creating .plist file"
echo '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' > teamsBg.plist
echo '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> teamsBg.plist
echo '<plist version="1.0">' >> teamsBg.plist
echo '  <dict>' >> teamsBg.plist
echo '    <key>Label</key>' >> teamsBg.plist
echo '    <string>com.teams.bg</string>' >> teamsBg.plist
echo '    <key>ProgramArguments</key>' >> teamsBg.plist
echo '    <array>' >> teamsBg.plist
echo '      <string>'$SCRIPT_DIR/teamsBgs.sh'</string>' >> teamsBg.plist
echo '    </array>' >> teamsBg.plist
echo '    <key>StartCalendarInterval</key>' >> teamsBg.plist
echo '    <dict>' >> teamsBg.plist
echo '       <key>Minute</key>' >> teamsBg.plist
echo '       <integer>45</integer>' >> teamsBg.plist
echo '    </dict>' >> teamsBg.plist
echo '  </dict>' >> teamsBg.plist
echo '</plist>' >> teamsBg.plist
