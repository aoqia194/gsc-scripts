# Welcome!
Hello, world! I've decided to learn the GSC language for **T6**. So far, I've written a couple features; of which you will see down below in [Features](https://github.com/lattemango/gsc-scripts#features). I hope you have fun using and modifying my scripts (as you can under the [License](https://github.com/lattemango/gsc-scripts/blob/main/LICENSE)! If you have any issues or concerns using my scripts, please let me know in the [Issues](https://github.com/lattemango/gsc-scripts/issues) section!

## Features
Down below I have the features I've currently developed.
 - [x] Chat Commands
 - [x] Database System (JSON)
 - [x] Banking System (utilising the database)
 - [x] Rankup System (utilising the database)
 - [x] Discord Webhook Support
 - [x] HTTP POST Request Support (utilising my [t6-gsc-utils fork](https://github.com/lattemango/t6-gsc-utils/))
 - [x] Database Caching
 - [x] Database Backups

## TODO
 - [ ] Improve Ranking System (prestige after level 100, prestige perks like coloured names)
 - [ ] Weapon Locker (using database)

## Installation
The installation for scripts is actually **really easy**.
1. Download the [source files](https://github.com/lattemango/gsc-scripts/archive/refs/heads/main.zip).
2. Download `t6-gsc-utils.dll` from my [t6-gsc-utils fork](https://github.com/lattemango/t6-gsc-utils/releases/latest/)
3. Find where you downloaded the source files and extract them.
4. Go into the folder that was just extracted and drag the scripts folder into this directory: `%localappdata%\Plutonium\storage\t6`
5. In the folder you dragged the folder to (known as the T6 game storage), make a new folder called `plugins`.
6. Navigate to where you downloaded `t6-gsc-utils.dll`
7. Drop `t6-gsc-utils.dll` into the newly created `plugins` folder.
8. Your T6 game storage should look like this: 		![The T6 storage folder](https://i.imgur.com/F9YO59O.png)

You might not have some files or folders like mine, but all that matters is you have the `plugins` and `scripts` folder. Make sure to check inside the scripts folder for my name `lattemango`. If it's in there, you can be sure that you installed it correctly!

## Discord Webhooks
#### Setup
1. Set up a [webhook](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks) in your Discord server.
2. Run the server at-least once. (Just run for about 10 seconds, then close)
3. Navigate to `%localappdata%\Plutonium\storage\t6\server_data`.
4. Create a new file named `discord_webhook.json`.
5. Open the file and paste in your webhook URL.
#### Customise
I've tried to make this easy for people who want to edit my GSC scripts to support their own embed styles and such. So I made some helper functions and some classes that you can use to customise your POST request's JSON data without having to actually modify the JSON data yourself (which is a big pain).
If you have a look inside [webhook_data.gsc](https://github.com/lattemango/gsc-scripts/blob/main/scripts/zm/lattemango/features/discord_webhook/webhook_data.gsc), you will be able to see how I send the requests, and how I integrate my helper functions, which ultimately get called from [chat_listener.gsc](https://github.com/lattemango/gsc-scripts/blob/main/scripts/zm/lattemango/features/discord_webhook/chat_listener.gsc).

## Mentions
 - [Resxt](https://github.com/Resxt) for the Chat Commands base.
