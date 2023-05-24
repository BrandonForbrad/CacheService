local CacheService = {}
local RunService = game:GetService("RunService")
local Promise = require(script.Promise)

CacheService.List = {}

CacheService.ServerIndexed = false
CacheService.ClientIndexed = false

CacheService.ProfileTemplate = {}

CacheService.LocalCache = {}


local function deepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

local function deepSearch(tab, Find, Search)
	local found = nil

	for Entry,Value in pairs(tab)  do
		if type(Value) == "table" then
			found = deepSearch(Value, Find, Search)
		else
			if Search == "Entry" then
				if Entry == Find then
					found = Value
					break
				end
			end
			if Search == "Value" then
				if Value == Find then
					found = Entry
					break
				end
			end
		end
	end


	return found	
end	
local function deepClean(original)
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = deepClean(v)
		else
			if typeof(v) == "RBXScriptConnection" then
				v:Disconnect()
			elseif type(v) == "userdata" then
				pcall(function() 
					v:Destroy()
				end)

			end

		end


	end

end


function CacheService:ReadCache(CacheName : "String (Cache Name)" , player : "Player Object")
	if RunService:IsServer() then
		return deepCopy( CacheService.List[CacheName].Storage[player.UserId] )
	end
	
	if RunService:IsClient() then 
		return deepCopy( CacheService.LocalCache[CacheName] )
	end
end

function CacheService:GetCache(CacheName : "String (Cache Name)")
	if RunService:IsServer() then
		return CacheService.List[CacheName]
	end
	if RunService:IsClient() then 
		game.Players.LocalPlayer.PlayerScripts:WaitForChild("Client")
		if not CacheService.ClientIndexed then
			CacheService.ClientIndexed = true
			CacheService.Client = game.Players.LocalPlayer.PlayerScripts.Client
		end
		local Set = {}

		function Set:FindValue(Entry : "Entry")
			return deepSearch(CacheService.LocalCache[CacheName], Entry, "Entry")
		end
		function Set:FindEntry(Value : "Value")
			return deepSearch(CacheService.LocalCache[CacheName], Value, "Value")
		end
		function Set:OnUpdate(func : "Bindable Callback | NewCache, OldCache")

			local UpdateBind = Instance.new("BindableEvent", CacheService.Client.Binds)
			UpdateBind.Name = CacheName.."|".."OnUpdate"

			UpdateBind.Event:Connect(func)

			return UpdateBind
		end
		return Set
		
	end
end
function CacheService:Create(CacheName : "String (Cache Name)"  , Info : "Cache Information Table", DefaultCache)
	assert(not RunService:IsClient(), "You can not create a cache on the client. (Server access only)")

	if Info.Replicate then
		local UpdateRemote = Instance.new("RemoteFunction", script.Events)
		UpdateRemote.Name = CacheName.."|".."OnUpdate"
	end
	

	if not CacheService.ServerIndexed then
		CacheService.ServerIndexed = true
		
		CacheService.Server = script.Server
		CacheService.Client = script.Client
		
		
		CacheService:Index()
		
	end
	
	--RunService.Heartbeat:Wait()
	
	local Set =  {
		Info = Info,
		Storage = {},
		
	}
	
	function Set:Delete()
		deepClean(CacheService.List[CacheName].Storage)
		for _,Bind in pairs(CacheService.Server.Binds:GetChildren()) do
			if Bind.Name == CacheName.."|".."OnUpdate" then
				Bind:Destroy()
			end
		end
		if Info.Replicate then
			script.Events[CacheName.."|".."OnUpdate"]:Destroy()
		end
		CacheService.List[CacheName] = nil
	end
	if Info.Expire ~= nil then
		coroutine.wrap(function() 
			task.wait(Info.Expire)
			Set:Delete()
		end)()
		
	end
	if Info.Global then
		function Set:FindValue(Entry : "Entry")
			return deepSearch(CacheService.List[CacheName].Storage, Entry, "Entry")
		end
		function Set:FindEntry(Value : "Value")
			return deepSearch(CacheService.List[CacheName].Storage, Value, "Value")
		end
	else
		function Set:FindValue(player : "Player Object (Ignore if global)", Entry : "Entry")
			return deepSearch(CacheService.List[CacheName].Storage[player.UserId], Entry, "Entry")
		end
		function Set:FindEntry(player : "Player Object (Ignore if global)", Value : "Value")
			return deepSearch(CacheService.List[CacheName].Storage[player.UserId], Value, "Value")
		end
	end
	

	if Info.DatastoreSave then
		CacheService.ProfileTemplate[CacheName] = DefaultCache
	end
	
	
	function Set:OnUpdate(func : "Bindable Callback | player (If not Global), NewCache, OldCache")
		
		local UpdateBind = Instance.new("BindableEvent", CacheService.Server.Binds)
		UpdateBind.Name = CacheName.."|".."OnUpdate"
		
		UpdateBind.Event:Connect(func)
		
		return UpdateBind
	end
	
	
	function Set:Update(player, transform : "Updater function | transform function")
		
		
		-- IF A GLOBA
		if Info.Global then
			local transform = player
			local OldCache =  CacheService.List[CacheName].Storage
			CacheService.List[CacheName].Storage = transform( deepCopy( OldCache ))
			
			for _,Bind in pairs(CacheService.Server.Binds:GetChildren()) do
				if Bind.Name == CacheName.."|".."OnUpdate" then
					Bind:Fire(CacheService.List[CacheName].Storage, deepCopy( OldCache ))	
				end
			end
			
			
			if Info.Replicate == true then
				for _,Event in pairs(script.Events:GetChildren()) do
					if Event.Name == CacheName.."|OnUpdate" then
						
						for _,player in pairs(game.Players:GetChildren()) do
							Promise.new(function(resolve) 
								player:WaitForChild("ClientListenReady", 5) 
								local Invoker = Event:InvokeClient(player, deepCopy( CacheService.List[CacheName].Storage  ) )
								resolve()
							end):timeout(5)
						end
						


					end
				end
			end
			

			return
		end
		
		--- NON GLOBAL CASH
		local OldCache =  CacheService.List[CacheName].Storage[player.UserId]
		CacheService.List[CacheName].Storage[player.UserId] = transform( deepCopy( OldCache ))
		
		for _,Bind in pairs(CacheService.Server.Binds:GetChildren()) do
			if Bind.Name == CacheName.."|".."OnUpdate" then
				Bind:Fire(player, CacheService.List[CacheName].Storage[player.UserId], deepCopy( OldCache ))
			end
		end
		
		local InUpdateRequest = {}
		if Info.Replicate == true and InUpdateRequest[player.UserId] == nil then
			InUpdateRequest[player.UserId] = true
			for _,Event in pairs(script.Events:GetChildren()) do
				if Event.Name == CacheName.."|OnUpdate" then
					Promise.new(function(resolve) 
						player:WaitForChild("ClientListenReady", 5)
						local Invoker = Event:InvokeClient(player, deepCopy( CacheService.List[CacheName].Storage[player.UserId]  ) )
						resolve()
					end):timeout(5):catch(function() 
						--warn(CacheName, "unable to update clients cache (Timeout 5 seconds)")
						InUpdateRequest[player.UserId] = nil
					end):andThen(function() 
						InUpdateRequest[player.UserId] = nil
					end)
					
					
				end
			end
		end
		
	end

	if Info.Global then
		function  Set:Clean(NewCache : "New cache table" ) 
			deepClean(CacheService.List[CacheName].Storage)
			
			Set:Update(function() return NewCache	end)
		end
		CacheService.List[CacheName] = Set
		
		return Set --- IF ITS A GLOBAL DONT DO PLAYER ADDED EVENTS
	else

		function  Set:Clean(player : "Player Object (Skip If Not Global)", NewCache : "New cache table" ) 
			deepClean(CacheService.List[CacheName].Storage[player.UserId] )

			Set:Update(player,  function() return NewCache	end)
		end
	end
	

	function Set:PlayerAdded(func : "Connected Callback | player, NewCache")
		local Conn
		Conn = game.Players.PlayerAdded:Connect(function(player) 
			if CacheService.List[CacheName] == nil then
				Conn:Disconnect()
				return
			end
			if Info.DatastoreSave  == true then
				repeat
					RunService.Heartbeat:Wait()
				until CacheService.List[CacheName].Storage[player.UserId] ~= nil or player.Parent == nil	
			else
				CacheService.List[CacheName].Storage[player.UserId] = DefaultCache
			end
			
			
			if player.Parent ~= nil then
				Set:Update(player,function() return CacheService.List[CacheName].Storage[player.UserId]  end)
				func(player, CacheService.List[CacheName].Storage[player.UserId])
			end
		end)
		
		return Conn
	end
	
	function Set:PlayerRemoved(func : "Connected Callback | player, OldCache")
		local Conn
		Conn = game.Players.PlayerRemoving:Connect(function(player) 
			if CacheService.List[CacheName] == nil then
				Conn:Disconnect()
				return
			end
			local OldCache = deepCopy( CacheService.List[CacheName].Storage[player.UserId] )
			if Info.DatastoreSave == true then
				repeat
					RunService.Heartbeat:Wait()
				until CacheService.List[CacheName].Storage[player.UserId] == nil	
			else
				Set:Clean(player, nil)
			end


			func(player, OldCache)
		end)
		return
	end
	
	
	
	CacheService.List[CacheName] = Set
	
	return Set
end


function CacheService:Index(info:"DO NOT USE THIS FUNCTION")
	CacheService.Server.Parent = game.ServerScriptService
	CacheService.Client.Parent = game.StarterPlayer.StarterPlayerScripts
	
	script.Events.ClientListenReady.OnServerEvent:Connect(function(player)
		if player:FindFirstChild("ClientListenReady") ~= nil then return end
		local CLR = Instance.new("Configuration", player)
		CLR.Name = "ClientListenReady"
	end)
	
	for _,Script in pairs(CacheService.Client:GetDescendants()) do
		if Script:IsA("LocalScript") then
			Script.Enabled = true
		end
	end
	
	for _,Script in pairs(CacheService.Server:GetDescendants()) do
		if Script:IsA("Script") then
			Script.Enabled = true
		end
	end
	
	game.Players.PlayerAdded:Connect(function(player) 
		for CacheName,Cache in pairs(CacheService.List) do
			if Cache.Info.Global then
				for _,Event in pairs(script.Events:GetChildren()) do
					if Event.Name == CacheName.."|OnUpdate" then
						Promise.new(function(resolve) 
							player:WaitForChild("ClientListenReady", 5) 
							local Invoker = Event:InvokeClient(player, deepCopy( CacheService.List[CacheName].Storage  ) )
							resolve()
						end):timeout(5)

					end
				end
			end
		end
	end)
	
	coroutine.wrap(function() 
		RunService.Heartbeat:Wait()

		local InitEventsReady =  Instance.new("Configuration",script)
		InitEventsReady.Name = "InitEventsReady"
	end)()
	
end



return CacheService
