---
title: "PlayerAdded (NonGlobal)"
slug: "update-copy-1"
excerpt: "CacheTable:PlayerAdded(CallbackFunction)"
hidden: false
createdAt: "2023-05-24T00:09:51.810Z"
updatedAt: "2023-05-24T00:33:32.236Z"
---
This is only usable within the server. 

This function sets a callback for when a player is added to the cache/game. This only works for NonGlobal (Global property not set to true)

If DatastoreSave property is set to true the callback function will only be called after the data is loaded.

### PlayerAdded Arguements:

Callback function (a function that is called whenever a player is added (player joined) to the cache| Given arguments is NewCache)

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


InventoryCache:PlayerAdded(function(player, NewCache) 
	task.wait(5)
	InventoryCache:Update(player, function(CurrentCache)

		OldCache.Sword.Level = 25


		return OldCache

	end)
end)

```