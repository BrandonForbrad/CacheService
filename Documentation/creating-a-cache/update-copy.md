---
title: "OnUpdate (Server)"
slug: "update-copy"
excerpt: "CacheTable:OnUpdate(CallbackFunction)"
hidden: false
createdAt: "2023-05-23T22:16:35.638Z"
updatedAt: "2023-05-24T00:36:27.008Z"
---
Have the Replicate property set to true to have the client be able to get the cache.

An OnUpdate function is used on the server where you provide a callback function that is called whenever the player's cache is updated.  
Have the DatastoreSave property set to true to have your Non-Global cache saved to the player's database. 

### OnUpdate Arguements:

Callback function (a function that is called whenever the cache is updated | Given arguments is the NewCache and the OldCache)

Example Usage for non-Global:

```lua example
local InventoryCache = Cache:Create("Inventory", 
	{DatastoreSave = true, Replicate = true}, 

	{
		["Available Slots"] = 10,
		{Item = "Basic Sword",Level = 1, XP = 1},
		{Item = "Apple"},
	}
)
local player = game.Players.forbrad --The player object
InventoryCache:OnUpdate(function(player, NewCache, OldCache)
	if OldCache["Available Slots"] ~= NewCache["Available Slots"] then
		print(player, "now has", NewCache["Available Slots"], "available slots left")
	end
end) 
```

Example Usage for Global:

```lua example
local RoundCache = Cache:Create("Round Stats", 
	{Global = true, Replicate = true}, 

	{
	  Round = 1,
	  Zombies = 5,
	  PlayersLeft = 10
	}
)

RoundCache:OnUpdate(function(NewCache, OldCache)
	if OldCache.Round ~= NewCache.Round then
		print(NewCache.Round,"has started")
	end
end) 
```