---
title: "FindValue"
slug: "findentry-copy"
excerpt: "CacheTable:FindValue(player, Entry)"
hidden: false
createdAt: "2023-05-24T01:29:11.176Z"
updatedAt: "2023-05-24T01:34:49.334Z"
---
Can be called from the Server or Client.

This function will deep loop within all the tables in the cache and fish out a Value that has the given Entry argument.

### FindEntry Arguements:

player userdata value | Only for NonGlobal

Entry | the entry that will be found within a value.

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
--Get a players available slots
print(InventoryCache:FindValue(player,"Available Slots") ) -- Output: 10
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

--Get 1stPlace player
print(WinnerCache:FindValue("1stPlace") ) -- Output: forbrad
```