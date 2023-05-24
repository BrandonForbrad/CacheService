---
title: "Intro"
slug: "intro"
excerpt: "Downloading and Initializing"
hidden: false
createdAt: "2023-05-23T21:32:35.230Z"
updatedAt: "2023-05-23T21:55:07.864Z"
---
Download rbxm file here: <https://github.com/BrandonForbrad/CachedDatabase/blob/main/DataService.rbxm>

Go into your Roblox studio right click replicated storage and click "Insert from file". Like this gif:

In the File Explorer find your rbxm file that should be in the downloads folder. 

[Gif Link](https://gyazo.com/a2edf7ced91a6a56e6aab2406f47e593.gif)

How to require your module.  
This works with both LocalScripts and Server Scripts

```lua example
local Cache = require(game.ReplicatedStorage.CacheService)
--Get the module using require

```