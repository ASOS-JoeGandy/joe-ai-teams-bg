# Pre-reqs

* only works on mac

`brew` should be setup on the mac 

install pre-reqs
`brew install cmake protobuf rust git wget python@3.10`

# Running stable diffusion UI

Uses some pre programmed stable diffusion parameters and the stable diffusion local api

Start by starting up the webui for stable diffusion,

`cd <project root>/stable-diffusion-webui`

Download a model, I use ghostmix, https://civitai.com/api/download/models/76907

Drop this file within `<project root>/stable-diffusion-webui/models/Stable-diffusion`

> If this directory doesn't exist, you can manually create it, or run webui.sh once and it should make the directory

Now run 

`./webui.sh` within `<project root>/stable-diffusion-webui`

Leave this terminal running the background to keep the web server up

A window should open in the browser with the ui, You can play around with this, but the next step will automatically generate images for you

# Generating the images

You need a source.jpg in the root of the repository before generating images, i've left my background as a test.

Running `node generate-images.js test` in the project root

You can trigger lots of prompts with

Running `node generate-images.js sunny garden "new york" london paris "90s cartoon" futuristic`

> If you don't have node see https://medium.com/@priscillashamin/how-to-install-and-configure-nvm-on-mac-os-43e3366c75a6 and setup nvm, then use `nvm use node`

Each generation takes around a minute on the m1 macbook, so just be careful queuing up 100s

The parameters are pre-decided to give okish results, but can tweak cfg_scale, denoising_strength if they're way off

    `denoising_strength` is how far from the source the image should stray
    `cfg_scale` is how aggressively it should pursue your prompt

# Have it automatically change your teams background

Make the script executable with `chmod +x ./teamsBg.sh`

Run `./teamsBg.sh` on the root of the repo

This will automatically go to the teams folder where backgrounds are stored, remove them all and replace it with a random AI image.

You'll need to set this as your background in teams, it should appear under custom backgrounds in the normal place (You won't need to do this again after this)

This is great but obviously this will only change your background when you run the teamsBg.sh script

To make this run automatically just copy the plist file to the launchd directory

`sudo cp ./teamsBg.plist /Library/LaunchDaemons/com.teams.bg.plist`

Then

`sudo launchctl load -w /Library/LaunchDaemons/com.name.Name.plist`

Now it'll change your background at 12 minutes past every hour
