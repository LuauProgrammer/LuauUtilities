--[[
	Author: LuauProgrammer
	Date: 9/4/22
	Script: Communicator
	Notes: Thigh highs~
]]

--//Services

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

--//Tables

local Communicator = {}

--//Variables

local IsServer = RunService:IsServer()
local Bindables = nil
local Remotes = nil

--//Base calls

if IsServer and not Remotes and not Bindables then
	Remotes = Instance.new("Folder",script)
	Bindables = Instance.new("Folder",script)
	Bindables.Name = "Server"
	Remotes.Name = "Shared"
elseif not Remotes and not Bindables then
	Bindables = Instance.new("Folder",script)
	Bindables.Name = "Client"
	Remotes = script:WaitForChild("Remotes")
end

--//Main

function Communicator:CreateRemoteEvent(Name)
	assert(not Remotes:FindFirstChild(Name.."_EVENT"),"A remote event with the name "..Name.." already exists.")
	assert(IsServer,"Only the server can call 'CreateRemoteEvent'")
	local Event = Instance.new("RemoteEvent") --//Don't parent until we set everything up
	Event.Name = Name.."_EVENT" --//Use identifiers so we dont have to make some overcomplicated system
	Event.Parent = Remotes
	return Event
end

function Communicator:CreateRemoteFunction(Name)
	assert(not Remotes:FindFirstChild(Name.."_FUNCTION"),"A remote function with the name "..Name.." already exists.")
	assert(IsServer,"Only the server can call 'CreateRemoteFunction'")
	local Function = Instance.new("RemoteFunction")
	Function.Name = Name.."_FUNCTION"
	Function.Parent = Remotes
	return Function
end

function Communicator:CreateBindableEvent(Name)
	assert(not Bindables:FindFirstChild(Name.."_EVENT"),"A bindable event with the name "..Name.." already exists.")
	local Event = Instance.new("BindableEvent")
	Event.Name = Name.."_EVENT"
	Event.Parent = Bindables
	return Event
end

function Communicator:CreateBindableFunction(Name)
	assert(not Bindables:FindFirstChild(Name.."_FUNCTION"),"A bindable function with the name "..Name.." already exists.")
	local Function = Instance.new("BindableFunction")
	Function.Name = Name.."_FUNCTION"
	Function.Parent = Bindables
	return Function
end

function Communicator:FireRemoteEventToClient(Name,Player,...)
	assert(Remotes:FindFirstChild(Name.."_EVENT"),"A remote event with the name "..Name.." does not exist.")
	assert(IsServer,"Only the server can call 'FireRemoteEventToClient'")
	Remotes[Name.."_EVENT"]:FireClient(Player,...)
end

function Communicator:FireRemoteEventToAllClients(Name,...)
	assert(Remotes:FindFirstChild(Name.."_EVENT"),"A remote event with the name "..Name.." does not exist.")
	assert(IsServer,"Only the server can call 'FireRemoteEventToAllClients'")
	Remotes[Name.."_EVENT"]:FireAllClients(...)
end

function Communicator:FireRemoteEventToOtherClients(Name,Exclude,...)
	assert(Remotes:FindFirstChild(Name.."_EVENT"),"A remote event with the name "..Name.." does not exist.")
	assert(IsServer,"Only the server can call 'FireRemoteEventToOtherClients'")
	for _,Player in ipairs(Players:GetPlayers()) do
		if typeof(Exclude) == "table" and not Exclude[Player] or Player ~= Exclude then
			Remotes[Name.."_EVENT"]:FireClient(Player,...)
		end
	end
end

function Communicator:FireRemoteEventToServer(Name,...)
	assert(Remotes:FindFirstChild(Name.."_EVENT"),"A remote event with the name "..Name.." does not exist.")
	assert(not IsServer,"Only the server can call 'FireRemoteEventToServer'")
	Remotes[Name.."_EVENT"]:FireServer(...)
end

function Communicator:FireBindableEvent(Name,...)
	assert(Bindables:FindFirstChild(Name.."_EVENT"),"A bindable event with the name "..Name.." does not exists.")
	Bindables[Name.."_EVENT"]:Fire(...)
end

function Communicator:InvokeRemoteFunctionToClient(Name,Player,...)
	assert(Remotes:FindFirstChild(Name.."_FUNCTION"),"A remote function with the name "..Name.." does not exist.")
	if IsServer then  --//A conditional check has to be done here as we can't call :InvokeClient or :InvokeServer as a function rather than a method :(
		return Remotes[Name.."_FUNCTION"]:InvokeClient(Player,...)
	else
		return Remotes[Name.."_FUNCTION"]:InvokeServer(...)
	end
end

function Communicator:InvokeRemoteFunctionToAllClients(Name,...) --//This is a virtual function. It will just call FireRemoteFunctionToOtherClients
	assert(Remotes:FindFirstChild(Name.."_FUNCTION"),"A remote event with the name "..Name.." does not exist.")
	assert(IsServer,"Only the server can call 'InvokeRemoteFunctionToAllClients'")
	return self:InvokeRemoteFunctionToOtherClients(Name,nil,...) --//Just use the other function cause why not
end

function Communicator:InvokeRemoteFunctionToOtherClients(Name,Exclude,...)
	assert(Remotes:FindFirstChild(Name.."_FUNCTION"),"A remote function with the name "..Name.." does not exist.")
	assert(IsServer,"Only the server can call 'InvokeRemoteFunctionToOtherClients'")
	local Table = {}
	local Arguments = {...} --//Hacky method as we cant use vararg outside of vararg functions 
	for _,Player in ipairs(Players:GetPlayers()) do
		if typeof(Exclude) == "table" and not Exclude[Player] or Player ~= Exclude then
			pcall(function() --//Considering that InvokeClient will yield and error if the client disconnects, we wrap it in a pcall. Only do it here since it'd be stupid to have it in every little function.
				Table[Player] = Remotes[Name.."_FUNCTION"]:InvokeClient(Player,unpack(Arguments))  --//Now, unpack the arguments :3
			end)
		end
	end
	return Table
end

function Communicator:InvokeRemoteFunctionToServer(Name,...)
	assert(Remotes:FindFirstChild(Name.."_FUNCTION"),"A remote function with the name "..Name.." does not exist.")
	assert(not IsServer,"Only the client can call 'InvokeRemoteFunctionToServer'")
	return Remotes[Name.."_FUNCTION"]:InvokeServer(...)
end

function Communicator:InvokeBindableFunction(Name,...)
	assert(Bindables:FindFirstChild(Name.."_EVENT"),"A bindable function with the name "..Name.." does not exists.")
	return Bindables[Name.."_FUNCTION"]:Invoke(...)
end

function Communicator:WaitForRemoteEvent(Name) --//Oh boy here it comes
	return Remotes:WaitForChild(Name.."_EVENT")
end

function Communicator:WaitForRemoteFunction(Name)
	return Remotes:WaitForChild(Name.."_FUNCTION")
end

function Communicator:WaitForBindableFunction(Name)
	return Bindables:WaitForChild(Name.."_FUNCTION")
end

function Communicator:WaitForBindableEvent(Name)
	return Bindables:WaitForChild(Name.."_EVENT")
end

function Communicator:ConnectRemoteEvent(Name,Callback)
	assert(Remotes:FindFirstChild(Name.."_EVENT"),"A remote event with the name "..Name.." does not exist.")
	local Connection = IsServer and Remotes[Name.."_EVENT"].OnClientEvent or Remotes[Name.."_EVENT"].OnServerEvent
	return Connection:Connect(Callback)
end

function Communicator:ConnectBindableEvent(Name,Callback)
	assert(Bindables:FindFirstChild(Name.."_EVENT"),"A bindable event with the name "..Name.." does not exist.")
	return Bindables[Name.."_EVENT"].Event:Connect(Callback)
end

function Communicator:SetBindableFunctionCallback(Name,Callback)
	assert(Bindables:FindFirstChild(Name.."_FUNCTION"),"A bindable function with the name "..Name.." does not exist.")
	Bindables[Name.."_FUNCTION"].OnInvoke = Callback
end

function Communicator:SetRemoteFunctionCallback(Name,Callback)
	assert(Remotes:FindFirstChild(Name.."_FUNCTION"),"A remote function with the name "..Name.." does not exist.")
	local Property = IsServer and "OnServerInvoke" or "OnClientInvoke"
	Callback[Property] = Callback
end

return Communicator
