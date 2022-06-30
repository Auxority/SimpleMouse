local TargetFilters = {}
TargetFilters.__index = TargetFilters

function TargetFilters.new()
	local tf = {}
	tf.instances = {}
	return setmetatable(tf, TargetFilters)
end

-- Gets the list of instances which will be ignored by the raycast
function TargetFilters:Get(): {Instance}
	return self.instances
end

-- Sets the list of instances which will be ignored by the raycast
function TargetFilters:Set(instances: {Instance}): nil
	self.instances = instances
end

-- Adds a new instance to the list of instances the raycast ignores
function TargetFilters:Add(descendant: Instance): nil
	table.insert(self.instances, descendant)
end

-- Removes an instance from the list of instances the raycast ignores
function TargetFilters:Remove(descendant: Instance): nil
	local index = table.find(self.instances, descendant)
	table.remove(self.instances, index)
end

-- Clears the list of instances the raycast ignores
function TargetFilters:Clear(): nil
	self.instances = {}
end

return TargetFilters
