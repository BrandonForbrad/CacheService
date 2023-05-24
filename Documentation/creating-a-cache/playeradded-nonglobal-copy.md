---
title: "PlayerRemoved (NonGlobal)"
slug: "playeradded-nonglobal-copy"
excerpt: "CacheTable:PlayerRemoved(CallbackFunction)"
hidden: false
createdAt: "2023-05-24T00:18:43.225Z"
updatedAt: "2023-05-24T00:33:07.586Z"
---
This is only usable within the server. 

This function sets a callback for when a player is removed from the cache/game. This only works for NonGlobal (Global property not set to true)

If DatastoreSave property is set to true the callback function will only be called after the data is saved.

### PlayerRemoved Arguements:

Callback function (a function that is called whenever a player is removed (player left) from the cache | Given arguments is OldCache)

Example Usage:

```lua example
local InventoryCache = Cache:Create("Inventory", 
	{DatastoreSave = true, Replicate = true}, 

	{
		["Available Slots"] = 10,
		{Item = "Basic Sword",Level = 1, XP = 1},
		{Item = "Apple"},
	}
)


InventoryCache:PlayerRemoved(function(player, OldCache) 
	 print(player.Name, "has left the server with", OldCache)
end)

```