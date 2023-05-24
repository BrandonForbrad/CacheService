---
title: "FindEntry"
slug: "delete-copy"
excerpt: "CacheTable:FindEntry(player, Value)"
hidden: false
createdAt: "2023-05-24T01:18:58.674Z"
updatedAt: "2023-05-24T01:35:24.393Z"
---
Can be called from the Server or Client.

This function will deep loop within all the tables in the cache and fish out an Entry that has the given Value argument.

### FindEntry Arguements:

player userdata value | Only for NonGlobal

Value | the value that will be found within an entry.

Example Usage for NonGlobal:

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
--Get an item that is level 1.
print(InventoryCache:FindEntry(player,1) ) -- Output: Level
```

Example Usage for Global:

```lua example
local WinnerCache = Cache:Create("Winners", 
	{Global = true, Replicate = true}, 

	{
		["1stPlace"] = "forbrad",
		["2ndPlace"] = "john",
		["3rdPlace"] = "doe",
	}
)

--Get placement
print(WinnerCache:FindEntry("forbrad") ) -- Output: 1stPlace
```