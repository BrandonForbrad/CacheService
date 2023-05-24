---
title: "Creating a cache"
slug: "creating-a-cache"
hidden: false
createdAt: "2023-05-23T21:54:17.062Z"
updatedAt: "2023-05-23T21:54:17.062Z"
---
You can only create a cache within the server. 

### Cache Arguements: 

CacheName (String name of the cache | A unique string name for the cache to be identified by)

Properties (Table list of properties | DatastoreSave, Replicate, Global, Expire )

DefaultCache (Table cache | The default cache table)

Example Usage:

```lua Example

local InventoryCache = Cache:Create("Inventory", 
	{DatastoreSave = true, Replicate = true}, 
	
	{
		["Available Slots"] = 10,
		{Item = "Basic Sword",Level = 1, XP = 1},
		{Item = "Apple"},
	}
)
```