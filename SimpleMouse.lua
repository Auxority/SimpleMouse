-- Import services
local PhysicsService = game:GetService("PhysicsService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local CustomSignal = require(script.CustomSignal)
local HelperMethods = require(script.HelperMethods)
local TargetFilters = require(script.TargetFilters)

-- Declare module
local Mouse = {}
Mouse.__index = Mouse
Mouse._DEFAULTS = {
	IGNORE_GAME_PROCESSED_EVENTS = true,
	RAY_LENGTH = 500,
	FILTER_TYPE = Enum.RaycastFilterType.Blacklist,
	COLLISION_GROUP = "Default",
	IGNORE_WATER = true
}

-- Create a new mouse instance
function Mouse.new()
	local m = {}
	
	-- These private properties should not be accessed directly, but through methods instead.
	m._internal = {
		-- Whether the mouse should ignore game processed events
		_ignoreGameProcessedEvents = Mouse._DEFAULTS.IGNORE_GAME_PROCESSED_EVENTS,
		-- The distance the mouse will use for raycasts
		_rayLength = Mouse._DEFAULTS.RAY_LENGTH,
		-- The type of filter used for raycasts of the mouse
		_filterType = Mouse._DEFAULTS.FILTER_TYPE,
		-- The collision group that is raycast within. Other collision groups are ignored.
		_collisionGroup = Mouse._DEFAULTS.COLLISION_GROUP,
		-- Whether the mouse should ignore water when raycasting
		_ignoreWater = Mouse._DEFAULTS.IGNORE_WATER
	}
	
	-- These public properties can be read from directly, whenever you need them. Writing to them directly is not recommended.
	m.Properties = {
		-- The 2D location of the mouse on the screen
		Location = Vector2.new(),
		-- The change in x,y of the mouse location between the current frame and the last frame
		Delta = Vector2.new(),
		-- The 2D size of the screen
		ScreenSize = Vector2.new(),
		-- The origin of the mouse in 3D space
		Origin = Vector3.new(),
		-- The direction of the mouse in 3D space
		Direction = Vector3.new(),
		-- 3D position of the mouse
		Position = Vector3.new(),
		-- The target that intersects with the ray of the mouse in 3D space
		Target = nil,
		-- The targets the mouse will ignore when finding a target. Uses a custom TargetFilters class to manage the list.
		TargetFilters = TargetFilters.new()
	}
	
	-- These are the signals to detect the mouse interactions
	m.Signals = {
		-- The signal that is used to detect when the left mouse button is pressed
		LeftButtonDown = CustomSignal.new(),
		-- The signal that is used to detect when the left mouse button is released
		LeftButtonUp = CustomSignal.new(),
		-- The signal that is used to detect when the right mouse button is pressed
		RightButtonDown = CustomSignal.new(),
		-- The signal that is used to detect when the right mouse button is released
		RightButtonUp = CustomSignal.new(),
		-- The signal that is used to detect when the middle mouse button is pressed
		MiddleButtonDown = CustomSignal.new(),
		-- The signal that is used to detect when the middle mouse button is released
		MiddleButtonUp = CustomSignal.new(),
		-- The signal that is used to detect when the mouse location changes
		Move = CustomSignal.new(),
		-- The signal that is used to detect when the scrollwheel is scrolled forwards
		ScrollForward = CustomSignal.new(),
		-- The signal that is used to detect when the scrollwheel is scrolled backwards
		ScrollBackward = CustomSignal.new()
	}

	-- A method that is used to connect UserInputService to the signals
	HelperMethods.connectSignals(m)

	return setmetatable(m, Mouse)
end

-- Get the ray length of the rays the mouse uses
function Mouse:GetRayLength(): number
	return self._internal._rayLength	
end

-- Set the ray length of the rays the mouse uses
function Mouse:SetRayLength(rayLength: number): nil
	if typeof(rayLength) == "number" then
		self._internal._rayLength = rayLength
	else
		warn("Ray length must be a number. Ray length remains unchanged.")
	end
end

-- Enables the icon of the mouse
function Mouse:EnableIcon(): nil
	UserInputService.MouseIconEnabled = true
end

-- Disables the icon of the mouse
function Mouse:DisableIcon(): nil
	UserInputService.MouseIconEnabled = false
end

-- Gets the raycast filtertype
function Mouse:GetFilterType(): Enum.RaycastFilterType
	return self._internal._filterType
end

-- Sets the raycast filtertype
function Mouse:SetFilterType(filterType: Enum.RaycastFilterType): nil
	if typeof(filterType) == "EnumItem" then
		self._internal._filterType = filterType
	else
		warn("Invalid raycast filter type. Filter type remains unchanged.")
	end
end

-- Gets the raycast's collision group
function Mouse:GetCollisionGroup(): string
	return self._internal._collisionGroup
end

-- Sets the raycast's collision group
function Mouse:SetCollisionGroup(name: string): nil
	local ok, err = pcall(PhysicsService.GetCollisionGroupId, PhysicsService, name)
	if ok then
		self._internal._collisionGroup = name
	else
		warn("Error: Invalid collision group name provided.\n" .. name .. " could not be found in the collision groups.\nCollision group remains unchanged.")
	end
end

-- Checks if water is ignored while raycasting or not
function Mouse:GetIgnoreWater(): boolean
	return self._internal._ignoreWater
end

-- Enables or disables whether water should be ignored while raycasting
function Mouse:SetIgnoreWater(ignoreWater: boolean): nil
	self._internal._ignoreWater = ignoreWater and true or false
end

return Mouse
