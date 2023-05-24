local CacheServiceMod = script.CacheServiceMod.Value
local CacheService = require(CacheServiceMod)

CacheService.Client = script.Parent
local function deepCopy(original)
	if original == nil then return nil end
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

local function Listen(Event)
	local Args = string.split(Event.Name, "|")
	if Args[2] ~= "OnUpdate" then return end
	local CacheName = Args[1]

	
	Event.OnClientInvoke = function(NewCache)
		for _,Bind in pairs(CacheService.Client.Binds:GetChildren()) do
			if Bind.Name == Args[1].."|OnUpdate" then
				Bind:Fire(NewCache, deepCopy(CacheService.LocalCache[CacheName]))
			end
		end
		
		CacheService.LocalCache[CacheName] = NewCache
		
		
	end
	
end


for _,Event in pairs(CacheServiceMod.Events:GetChildren()) do Listen(Event) end
CacheServiceMod.Events.ChildAdded:Connect(Listen)

CacheServiceMod:WaitForChild("InitEventsReady")

CacheServiceMod.Events.ClientListenReady:FireServer()
