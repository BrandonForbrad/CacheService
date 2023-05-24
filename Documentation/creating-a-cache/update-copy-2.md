---
title: "Delete"
slug: "update-copy-2"
excerpt: "CacheTable:Delete()"
hidden: false
createdAt: "2023-05-24T01:04:20.336Z"
updatedAt: "2023-05-24T01:13:21.308Z"
---
You can only delete a cache within the server.

A function that is used to completely clean and delete a cache. Perfect for player-spawned events. After a cache is deleted it can no longer be used and all of the events under the cache are disconnected or removed. (Binds, Remotes, and Player Leaving/Joining connections)

### Delete Arguements:

No required Arguments

Example Usage:

```lua example
local SwarmSpawnCache  = Cache:Create("Forbrads swarm", 
	{Global = true}, 

	{
		Swarms = {game.ReplicatedStorage.NPCs.BadGuy:Clone(),game.ReplicatedStorage.NPCs.BadGuy:Clone()},
		StartTime = 10, 

	}
)
task.wait(20)

SwarmSpawnCache:Delete()
```