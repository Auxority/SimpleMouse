local UserInputService = game:GetService("UserInputService")

local HelperMethods = {}

local Camera = workspace.Camera

local function mustIgnoreInput(m, gameProcessedEvent): boolean
	return m._ignoreGameProcessedEvents and gameProcessedEvent
end

local function getRaycastParameters(m)
	local parameters = RaycastParams.new()
	parameters.CollisionGroup = m._internal._collisionGroup
	parameters.FilterDescendantsInstances = m.Properties.TargetFilters:Get()
	parameters.FilterType = m._internal._filterType
	parameters.IgnoreWater = m._internal._ignoreWater
	return parameters
end

local function castRay(m)
	return workspace:Raycast(m.Properties.Origin, m.Properties.Direction * m._internal._rayLength, getRaycastParameters(m))
end

local function updateLocation(m, input)
	m.Properties.Location = UserInputService:GetMouseLocation()
	m.Properties.Delta = UserInputService:GetMouseDelta()
	m.Properties.ScreenSize = Camera.ViewportSize

	local unitRay = Camera:ViewportPointToRay(m.Properties.Location.X, m.Properties.Location.Y)
	m.Properties.Origin = unitRay.Origin
	m.Properties.Direction = unitRay.Direction
	
	local raycastResult = castRay(m)
	
	if raycastResult then
		m.Properties.Position = raycastResult.Position
		m.Properties.Target = raycastResult.Instance
	else
		m.Properties.Position = nil
		m.Properties.Target = nil
	end
end

local function onInputBegan(m, input, gameProcessedEvent)
	if mustIgnoreInput(m, gameProcessedEvent) then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		m.Signals.LeftButtonDown:Run()
	end

	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		m.Signals.RightButtonDown:Run()
	end
	
	if input.UserInputType == Enum.UserInputType.MouseButton3 then
		m.Signals.MiddleButtonDown:Run()
	end
end

local function onInputEnded(m, input, gameProcessedEvent)
	if mustIgnoreInput(m, gameProcessedEvent) then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		m.Signals.LeftButtonUp:Run()
	end

	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		m.Signals.RightButtonUp:Run()
	end
	
	if input.UserInputType == Enum.UserInputType.MouseButton3 then
		m.Signals.MiddleButtonUp:Run()
	end
end

local function onInputChanged(m, input, gameProcessedEvent)
	if mustIgnoreInput(m, gameProcessedEvent) then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement then
		updateLocation(m, input)
		m.Signals.Move:Run()
	end

	if input.UserInputType == Enum.UserInputType.MouseWheel then
		if input.Position.Z == 1 then
			m.Signals.ScrollForward:Run()
		elseif input.Position.Z == -1 then
			m.Signals.ScrollBackward:Run()
		end
	end
end

function HelperMethods.connectSignals(m)
	UserInputService.InputChanged:Connect(function(input, gameProcessedEvent)
		onInputChanged(m, input, gameProcessedEvent)
	end)

	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		onInputBegan(m, input, gameProcessedEvent)
	end)

	UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
		onInputEnded(m, input, gameProcessedEvent)
	end)
end

return HelperMethods
