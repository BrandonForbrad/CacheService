---
title: "Clean"
slug: "playerremoved-nonglobal-copy"
excerpt: "CacheTable:Clean(NewCache Table)"
hidden: false
createdAt: "2023-05-24T00:24:56.484Z"
updatedAt: "2023-05-24T00:51:11.866Z"
---
This is only usable within the server. 

This function completely cleans whatever is in the storage of the given cache. It will delete any userdata (Object) values that are in the cache and disconnect any Roblox-made connections. This is perfect for making a recyclable cache. 

### Clean Arguements:

(Non-Global) player userdata/object whose cache to clean 

Example Usage for non-Global:

```lua example
local PRSCache = Cache:Create("PlayerRoundSets", 
	{ Replicate = true}, 

	{
		SpawnLocation = game.Workspace.SpawnLocation,
		TouchedEvent = game.Workspace.SpawnLocation.Touched:Connect(function(part) print(part) end),
		Kills = 0
	}
)

--Player died
PRSCache:Clean(game.Players.forbrad)


```

Example Usage for Global:

```lua example
local CurrentRoundCache  = Cache:Create("CurrentRound", 
	{Global = true,  Replicate = true}, 

	{
		SpawnLocation = game.Workspace.SpawnLocation,
		Map = game.ServerStorage.Maps["Jungle"]:Clone()
		TouchedEvent = game.Workspace.SpawnLocation.Touched:Connect(function(part) print(part) end),
		TimeLeft = 30
	}
)
local RoundTime = 30

task.wait(RoundTime)

--Round Ended
CurrentRoundCache:Clean()


```