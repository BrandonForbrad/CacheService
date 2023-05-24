---
title: "OnUpdate (Client)"
slug: "onupdate-server-copy"
excerpt: "CacheTable:OnUpdate(CallbackFunction)"
hidden: false
createdAt: "2023-05-23T23:58:53.287Z"
updatedAt: "2023-05-24T00:35:19.126Z"
---
You can only use Cache:GetCache() on a cache that has the Replicate Property Set to true

An OnUpdate function that is used on the client where you provide a callback function that is called whenever the local player's cache is updated. This is perfect for stuff like updating your UI.

### OnUpdate Arguements:

Callback function (a function that is called whenever the cache is updated | Given arguments is the NewCache and the OldCache)

Example Usage on Client:

```lua example
local MyInventory = Cache:GetCache("Inventory")

MyInventory:OnUpdate(function( NewCache, OldCache)
	print("Updating inventory UI with,", NewCache)
end) 
```