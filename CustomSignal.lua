local CustomConnection = require(script.CustomConnection)

local CustomSignal = {}
CustomSignal.__index = CustomSignal

function CustomSignal.new()
	local signal = {}
	signal.connections = {}
	
	return setmetatable(signal, CustomSignal)
end

function CustomSignal:Connect(func: () -> nil)
	local newConnection = CustomConnection.new(func)
	table.insert(self.connections, newConnection)
	return newConnection
end

function CustomSignal:RemoveDisconnectedSignals()
	local len = #self.connections
	for i = len, 1, -1 do
		if self.connections[i].Connected == false then
			table.remove(self.connections, i)
		end
	end
end

function CustomSignal:Run()
	self:RemoveDisconnectedSignals()
	for i, connection in pairs(self.connections) do
		connection:Run()
	end
end

return CustomSignal
