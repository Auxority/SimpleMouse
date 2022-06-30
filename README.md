# SimpleMouse
A Roblox luau module that attempts to make interacting with the UserInputService simpler.

# About
SimpleMouse is a module I made to simplify the access to the UserInputService of Roblox.
It is based on the (almost backwards compatible) mouse module that attempts to copy the behaviour of the [Mouse class](https://developer.roblox.com/en-us/api-reference/class/Mouse) using new services.
That module can be downloaded [here](https://devforum.roblox.com/t/release-mouse-module-v2/1850705)

But SimpleMouse takes this a step further and introduces more methods and control. The goal is to make your development with mouse interactions easier.

# Showcase
## Detecting left mouse button clicks and creating explosions at the 3D position of the mouse.
https://user-images.githubusercontent.com/35202343/176704853-4606a5d4-dd2a-4503-a2dc-c91b28f87654.mp4

<details>
  <summary>The code to achieve the result shown in the video</summary>

  ```lua

  -- Loads a service that is used to remove parts after a certain period of time
  local Debris = game:GetService("Debris")

  -- Loads the simple mouse module
  local SimpleMouse = require(script.SimpleMouse)

  -- Creates a new instance for the mouse module
  local mouse = SimpleMouse.new()

  -- Detects when the left mouse button is pressed, and runs the function when detected.
  mouse.Signals.LeftButtonDown:Connect(function()
  -- Checks if the mouse has a target position to hit
  if mouse.Properties.Position then
    -- Creates a new explosion
    local e = Instance.new("Explosion")
		-- Sets the position of the explosion to the 3D position of the mouse
		e.Position = mouse.Properties.Position
		-- Makes it so the explosion won't kill any player
		e.BlastRadius = 0
		-- Sets the parent of the explosion to workspace
		e.Parent = workspace
		-- Removes the explosion from workspace after 1 second
		Debris:AddItem(e, 1)
	end
end)
```
</details>

## Detecting mouse movement using the middle mouse button as a toggle
https://user-images.githubusercontent.com/35202343/176704924-cfe1f3e2-3e86-4e31-acad-1a66cabfc097.mp4

<details>
  <summary>The code to achieve the result shown in the video</summary>
  
  ```lua
  -- Loads a service that is used to remove parts after a certain period of time
  local Debris = game:GetService("Debris")

  -- Loads the mouse module
  local SimpleMouse = require(script.SimpleMouse)

  -- Creates a new instance for the mouse module
  local mouse = SimpleMouse.new()

  -- Whether the middle mouse button is pressed or not
  local isMiddleButtonPressed = false

  -- Detects when the middle mouse button is pressed
  mouse.Signals.MiddleButtonDown:Connect(function()
    isMiddleButtonPressed = true
  end)

  -- Detects when the middle mouse button is released
  mouse.Signals.MiddleButtonUp:Connect(function()
    isMiddleButtonPressed = false
  end)

  -- Detects when the mouse position changes
  mouse.Signals.Move:Connect(function()
    -- Check if the mouse has a target position in 3D
    if mouse.Properties.Position and isMiddleButtonPressed then
      -- Create a new part instance
      local p = Instance.new("Part")
      -- Makes sure the part is not affected by gravity.
      p.Anchored = true
      -- Makes sure other parts do not collide with this part
      p.CanCollide = false
      -- Changes the material of the part to smooth plastic
      p.Material = Enum.Material.SmoothPlastic
      -- Changes the size of the part to a block
      p.Size = Vector3.new(1, 1, 1)
      -- Sets the color of the part to red
      p.Color = Color3.fromRGB(200, 90, 90)
      -- Sets the position of the part
      p.CFrame = CFrame.new(mouse.Properties.Position)
      -- Add the part to the workspace
      p.Parent = workspace
      -- Remove the part from workspace after 1 second
      Debris:AddItem(p, 1)
    end
  end)
  ```
</details>

# Documentation
If you want to know more about the available properties and functions, they are listed here.
<details>
  <summary>Click to view the documentation</summary>
  
  ### Loading the simple mouse module
  To use the module, you first have to load it.
  
  ![image](https://user-images.githubusercontent.com/35202343/176688354-cb7622d1-474f-43cc-85b4-0d8549adc51a.png)
  
  If you place the module inside a local script like this, the code used to load the module would be:
  
  ```lua
  local SimpleMouse = require(script.SimpleMouse)
  ```
  
  And to actually use the module, you have to create an instance. Which can be done like so:
  
  ```lua
  local mouse = SimpleMouse.new()
  ```
  
  ## Accessing the properties
  To view the properties of the mouse, I've added a property called Properties to the mouse instance.
  It can be accessed like this:
  
  ```lua
  local properties = mouse.Properties
  ```
  
  Now I will briefly cover each property.
  
  ### Location (Vector2)
  This is the 2D (x, y) location of the mouse on the screen.
  
  ### Delta (Vector2)
  This is the change of location in horizontal and vertical directions between the current frame and the last frame.
  This function only returns the correct value when the mouse is locked (Shift-lock or fully zoomed in)
  
  ### ScreenSize (Vector2)
  This is the size (width and height) of the screen. X representing the width and Y representing the height.
  
  ### Origin (Vector3)
  This is the origin of the mouse in 3D space. Also known as the location of the camera.
  
  ### Direction (Vector3)
  This is a [normalized vector](https://en.wikipedia.org/wiki/Unit_vector), which is the direction the mouse is pointing towards from the origin.
  
  ### Target (Instance | nil)
  This is an Instance (e.g. a part) that the mouse is currently hovering over.
  
  ### TargetFilters (Custom)
  This is a custom class which manages the targets which the mouse should ignore.
  Specifically, the rays that the mouse casts will pass through every part that belongs to the list of instances.
  
  It has five methods that you can use:
  
  - **Get()** - Gets the list of instances which the mouse ignores.
  - **Set({instance1, instance2})** - Sets the list of instances which the mouse ignores.
  - **Add(instance1)** - Adds an instance to the list of instances the mouse ignores.
  - **Remove(instance1)** - Removes an instance from the list of instances the mouse ignores.
  - **Clear()** - Clears the list of instances the mouse ignores.
  
  ## Mouse methods
  Ofcourse the module also supports some methods.
  These methods can be accessed in a regular way.
  But to understand some methods, it might be handy to know what raycasting means, so [here](https://developer.roblox.com/en-us/articles/Raycasting) is some more information on that.
  The supported methods are the following:
  - **GetRayLength()** - Gets the ray length the mouse uses to cast rays.
  - **SetRayLength(rayLength: number)** - Sets the ray length the mouse uses to cast rays.
  - **EnableIcon()** - Enables the icon of the mouse.
  - **DisableIcon()** - Disables the icon of the mouse.
  - **GetFilterType()** - Gets the filtertype the mouse uses to cast rays.
  - **SetFilterType(filterType: Enum.RaycastFilterType)** - Sets the filertype the mouse uses to cast rays.
  - **GetCollisionGroup()** - Gets the name of the collision group the mouse casts rays within.
  - **GetIgnoreWater()** - Checks if the mouse ignores the water terrain type while casting rays.
  - **SetIgnoreWater(ignoreWater: boolean)** - Changes if the mouse should ignore the water terrain type while casting rays.
  
  ## Mouse signals
  Mouse signals are interactions a user has with the mouse. These are grouped under the Signals property. And can be accessed like so:
  
  ```lua
  local signals = mouse.Signals
  ```
  
  This is the list of supported interactions:
  - **LeftButtonDown** - The signal that is used to detect when the left mouse button is pressed
  - **LeftButtonUp** - The signal that is used to detect when the left mouse button is released
  - **RightButtonDown** - The signal that is used to detect when the right mouse button is pressed
  - **RightButtonUp** - The signal that is used to detect when the right mouse button is released
  - **MiddleButtonDown** - The signal that is used to detect when the middle mouse button is pressed
  - **MiddleButtonUp** - The signal that is used to detect when the middle mouse button is released
  - **Move** - The signal that is used to detect when the mouse location changes
  - **ScrollForward** - The signal that is used to detect when the scrollwheel is scrolled forwards
  - **ScrollBackward** - The signal that is used to detect when the scrollwheel is scrolled backwards
  
  You can connect your own code to these interactions. An example of which is shown below:
  
  ```lua
  signals.LeftButtonDown:Connect(function()
    print("The left mouse button has been pressed!")
  end)
  
  -- But you can also connect the signals to your own code like this:
  local function printMessage()
    print("The left mouse button has been released!")
  end
  
  signals.LeftButtonUp:Connect(printMessage)
  ```
</details>

If you have any suggestions, questions or feedback. Feel free to let me know.
