local CustomConnection = {}
CustomConnection.__index = CustomConnection

function CustomConnection.new(func: () -> nil)
	local cc = {}
	cc.Connected = true
	cc._func = func
	
	return setmetatable(cc, CustomConnection)
end

function CustomConnection:Run()
	if self.Connected then
		self._func()
	end
end

function CustomConnection:Disconnect()
	self.Connected = false
end

return CustomConnection
