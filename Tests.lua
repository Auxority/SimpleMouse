local Mouse = require(script.Parent)

local m = Mouse.new()
m.Signals.LeftButtonDown:Connect(function()
	print("The left mouse button was pressed")
end)

m.Signals.LeftButtonUp:Connect(function()
	print("The left mouse button was released")
end)

m.Signals.RightButtonDown:Connect(function()
	print("The right mouse button was pressed")
end)

m.Signals.RightButtonUp:Connect(function()
	print("The right mouse button was released")
end)

m.Signals.MiddleButtonDown:Connect(function()
	print("The middle mouse button was pressed")
end)

m.Signals.MiddleButtonUp:Connect(function()
	print("The middle mouse button was released")
end)

m.Signals.Move:Connect(function()
	print("The mouse moved")
end)

m.Signals.ScrollForward:Connect(function()
	print("The scrollwheel scrolled forwards")
end)

m.Signals.ScrollBackward:Connect(function()
	print("The scrollwheel scrolled backwards")
end)

print("Performing mouse module test in 3 seconds!")
task.wait(3)

-- Some validation checks of the output of methods
local VALID_FILTER_TYPES = Enum.RaycastFilterType:GetEnumItems()

print("\nMouse module - Test report:\n")
print(typeof(m:GetRayLength()) == "number", "Ray length:", m:GetRayLength())
print(typeof(m:GetFilterType()) == "EnumItem", "Filter type:", m:GetFilterType())
print(typeof(m:GetIgnoreWater()) == "boolean", "Ignore water:", m:GetIgnoreWater())
print(typeof(m:GetCollisionGroup()) == "string", "Collision group:", m:GetCollisionGroup())
print(typeof(m.Properties.Location) == "Vector2", "2D mouse location", m.Properties.Location)
print(typeof(m.Properties.ScreenSize) == "Vector2", "Screen size:", m.Properties.ScreenSize)
print(typeof(m.Properties.Position) == "Vector3", "3D mouse position:", m.Properties.Position)
print(typeof(m.Properties.Target) == "Instance" or typeof(m.Properties.Target) == "nil", "Target:", m.Properties.Target)
print(typeof(m.Properties.Origin) == "Vector3", "Ray origin:", m.Properties.Origin)
print(typeof(m.Properties.Direction) == "Vector3", "Ray direction:", m.Properties.Direction)
print(typeof(m.Properties.TargetFilters:Get()) == "table", "Target filters:", m.Properties.TargetFilters:Get())

-- Some validation checks of methods which change settings
m:DisableIcon()
m:EnableIcon()
m:SetRayLength(500)
m:SetFilterType(Enum.RaycastFilterType.Whitelist)
m:SetFilterType(Enum.RaycastFilterType.Blacklist)
m:SetIgnoreWater(false)
m:SetIgnoreWater(true)
m.Properties.TargetFilters:Set({workspace})
m.Properties.TargetFilters:Add(workspace)
m.Properties.TargetFilters:Remove(workspace)
m:SetCollisionGroup("Default")
print("\nMouse module - Test report end\n")
