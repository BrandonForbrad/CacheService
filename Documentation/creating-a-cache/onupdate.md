---
title: "Update"
slug: "onupdate"
excerpt: "CacheTable:Update(TransformFucntion)"
hidden: false
createdAt: "2023-05-23T21:59:59.388Z"
updatedAt: "2023-05-24T00:37:19.312Z"
---
You can only Update a cache within the server. 

A function that is used to transform/change a certain cache.

### Update Arguements:

TransformFunction (A function that sets the current cache to what the function argument returns. | Given arguments is the Current Cache) 

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
InventoryCache:Update(player,function(CurrentCache)
	CurrentCache["Available Slots"] = 15

	return CurrentCache
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

RoundCache:Update(function(CurrentCache)
	CurrentCache.Round += 1

	return CurrentCache
end) 
```