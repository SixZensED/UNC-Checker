local unc_lib = {}
local passes, fails, undefined,running = 0, 0, 0, 0

local function getGlobal(path)
	local value = getfenv(0)

	for name in string.gmatch(path, "[^.]+") do
		if value == nil then
			return nil
		end
		value = value[name]
	end

	return value
end

local reload = function()
	if game:GetService("CoreGui"):FindFirstChild("unc") then
		game:GetService("CoreGui"):FindFirstChild("unc"):Destroy()
	end
end

unc_lib.create = function()
	reload()
	local unc = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local TextLabel = Instance.new("TextLabel")

	unc.Name = "unc"
	unc.Parent = game:GetService("CoreGui")
	unc.ZIndexBehavior = Enum.ZIndexBehavior.Global
	unc.DisplayOrder = 999

	Frame.Parent = unc
	Frame.Active = true
	Frame.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.Position = UDim2.new(0.267261893, 0, 0.165441141, 0)
	Frame.Size = UDim2.new(0, 781, 0, 545)

	ScrollingFrame.Parent = Frame
	ScrollingFrame.Active = true
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.Position = UDim2.new(0.0140845068, 0, 0.0678899363, 0)
	ScrollingFrame.Size = UDim2.new(0, 760, 0, 497)
	ScrollingFrame.BottomImage = ""
	ScrollingFrame.ScrollBarThickness = 2
	ScrollingFrame.TopImage = ""
	ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	ScrollingFrame.ScrollingEnabled = true
	ScrollingFrame.Name = "scrollingbar"
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
	ScrollingFrame.CanvasPosition = Vector2.new(0,0)

	UIListLayout.Parent = ScrollingFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	TextLabel.Parent = Frame
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0.015364917, 0, 0.0146788992, 0)
	TextLabel.Size = UDim2.new(0, 131, 0, 18)
	TextLabel.Font = Enum.Font.GothamBlack
	local executorName = getexecutorname() or identifyexecutor()
	TextLabel.Text = 'UNC CHECK (1.0.0) : <font color="rgb(255,125,0)">'..executorName..'</font>'
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = 14.000
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.RichText = true
	
	unc_lib.createresult = function(args)
		local method = args.method or "warn"
		local title = args.title or "undefine"
		local Frame = Instance.new("Frame")
		local Frame_2 = Instance.new("Frame")
		local TextLabel2 = Instance.new("TextLabel")

		Frame.Parent = ScrollingFrame
		Frame.Active = true
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BackgroundTransparency = 1.000
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new(0, 745, 0, 36)

		Frame_2.Parent = Frame
		Frame_2.Active = true
		Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame_2.BorderSizePixel = 0
		Frame_2.Position = UDim2.new(0.0149999997, 0, 0.5, 0)
		Frame_2.Size = UDim2.new(0, 5, 0, 5)

		TextLabel2.Parent = Frame
		TextLabel2.Active = true
		TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
		TextLabel2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel2.BackgroundTransparency = 1.000
		TextLabel2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel2.BorderSizePixel = 0
		TextLabel2.Position = UDim2.new(0.515436232, 0, 0.5, 0)
		TextLabel2.Size = UDim2.new(0.969127536, 0, 1, 0)
		TextLabel2.Font = Enum.Font.Gotham
		TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel2.TextSize = 14.000
		TextLabel2.TextWrapped = true
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.Text = title
		
		if method == "success" then
			Frame_2.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
		elseif method == "fail" then
			Frame_2.BackgroundColor3 = Color3.fromRGB(255, 55, 55)
		elseif method == "warn" then
			Frame_2.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
		elseif method == "no test" then
			Frame_2.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
		end
	end
	
	local function test(name, aliases, callback)
		running += 1

		task.spawn(function()
			if not callback then
				unc_lib.createresult({method = "no test",title = name})
			elseif not getGlobal(name) then
				fails += 1
				unc_lib.createresult({method = "fail",title = name.." (is not defined)"})
			else
				local success, message = pcall(callback)

				if success then
					passes += 1
					unc_lib.createresult({method = "success",title = name.. (message and " • " .. message or "")})
				else
					fails += 1
					unc_lib.createresult({method = "fail",title = name.. " failed: " .. message})
				end
			end

			local undefinedAliases = {}

			for _, alias in ipairs(aliases) do
				if getGlobal(alias) == nil then
					table.insert(undefinedAliases, alias)
				end
			end

			if #undefinedAliases > 0 then
				undefined += 1
				unc_lib.createresult({method = "warn",title = name.. " Undefined aliases: " .. table.concat(undefinedAliases, ", ")})
			end

			running -= 1
		end)
	end
	
	test("cache.invalidate", {}, function()
		local container = Instance.new("Folder")
		local part = Instance.new("Part", container)
		cache.invalidate(container:FindFirstChild("Part"))
		assert(part ~= container:FindFirstChild("Part"), "Reference `part` could not be invalidated")
	end)

	test("cache.iscached", {}, function()
		local part = Instance.new("Part")
		assert(cache.iscached(part), "Part should be cached")
		cache.invalidate(part)
		assert(not cache.iscached(part), "Part should not be cached")
	end)

	test("cache.replace", {}, function()
		local part = Instance.new("Part")
		local fire = Instance.new("Fire")
		cache.replace(part, fire)
		assert(part ~= fire, "Part was not replaced with Fire")
	end)

	test("cloneref", {}, function()
		local part = Instance.new("Part")
		local clone = cloneref(part)
		assert(part ~= clone, "Clone should not be equal to original")
		clone.Name = "Test"
		assert(part.Name == "Test", "Clone should have updated the original")
	end)

	test("compareinstances", {}, function()
		local part = Instance.new("Part")
		local clone = cloneref(part)
		assert(part ~= clone, "Clone should not be equal to original")
		assert(compareinstances(part, clone), "Clone should be equal to original when using compareinstances()")
	end)

	local function shallowEqual(t1, t2)
		if t1 == t2 then
			return true
		end

		local UNIQUE_TYPES = {
			["function"] = true,
			["table"] = true,
			["userdata"] = true,
			["thread"] = true,
		}

		for k, v in pairs(t1) do
			if UNIQUE_TYPES[type(v)] then
				if type(t2[k]) ~= type(v) then
					return false
				end
			elseif t2[k] ~= v then
				return false
			end
		end

		for k, v in pairs(t2) do
			if UNIQUE_TYPES[type(v)] then
				if type(t1[k]) ~= type(v) then
					return false
				end
			elseif t1[k] ~= v then
				return false
			end
		end

		return true
	end

	test("checkcaller", {}, function()
		assert(checkcaller(), "Main scope should return true")
	end)

	test("clonefunction", {}, function()
		local function test()
			return "success"
		end
		local copy = clonefunction(test)
		assert(test() == copy(), "The clone should return the same value as the original")
		assert(test ~= copy, "The clone should not be equal to the original")
	end)

	test("getcallingscript", {})

	test("getscriptclosure", {"getscriptfunction"}, function()
		local module = game:GetService("CoreGui").RobloxGui.Modules.Common.Constants
		local constants = getrenv().require(module)
		local generated = getscriptclosure(module)()
		assert(constants ~= generated, "Generated module should not match the original")
		assert(shallowEqual(constants, generated), "Generated constant table should be shallow equal to the original")
	end)

	test("hookfunction", {"replaceclosure"}, function()
		local function test()
			return true
		end
		local ref = hookfunction(test, function()
			return false
		end)
		assert(test() == false, "Function should return false")
		assert(ref() == true, "Original function should return true")
		assert(test ~= ref, "Original function should not be same as the reference")
	end)

	test("iscclosure", {}, function()
		assert(iscclosure(print) == true, "Function 'print' should be a C closure")
		assert(iscclosure(function() end) == false, "Executor function should not be a C closure")
	end)

	test("islclosure", {}, function()
		assert(islclosure(print) == false, "Function 'print' should not be a Lua closure")
		assert(islclosure(function() end) == true, "Executor function should be a Lua closure")
	end)

	test("isexecutorclosure", {"checkclosure", "isourclosure"}, function()
		assert(isexecutorclosure(isexecutorclosure) == true, "Did not return true for an executor global")
		assert(isexecutorclosure(newcclosure(function() end)) == true, "Did not return true for an executor C closure")
		assert(isexecutorclosure(function() end) == true, "Did not return true for an executor Luau closure")
		assert(isexecutorclosure(print) == false, "Did not return false for a Roblox global")
	end)

	test("loadstring", {}, function()
		-- Try to load the Animate script's bytecode
		local animate = game:GetService("Players").LocalPlayer.Character.Animate
		local bytecode = getscriptbytecode(animate)
		local success, funcOrError = pcall(loadstring, bytecode)
		assert(not success, "Luau bytecode should not be loadable!")
		local mathFunc = assert(loadstring("return ... + 1"))
		assert(mathFunc(1) == 2, "Failed to do simple math")
		local success, result = pcall(loadstring, "f")
		assert(not success and type(result) == "string", "Loadstring did not return an error message for a compiler error")
	end)



	test("newcclosure", {}, function()
		local function test()
			return true
		end
		local testC = newcclosure(test)
		assert(test() == testC(), "New C closure should return the same value as the original")
		assert(test ~= testC, "New C closure should not be same as the original")
		assert(iscclosure(testC), "New C closure should be a C closure")
	end)

	test("rconsoleclear", {"consoleclear"})

	test("rconsolecreate", {"consolecreate"})

	test("rconsoledestroy", {"consoledestroy"})

	test("rconsoleinput", {"consoleinput"})

	test("rconsoleprint", {"consoleprint"})

	test("rconsolesettitle", {"rconsolename", "consolesettitle"})

	test("crypt.base64encode", {"crypt.base64.encode", "crypt.base64_encode", "base64.encode", "base64_encode"}, function()
		assert(crypt.base64encode("test") == "dGVzdA==", "Base64 encoding failed")
	end)

	test("crypt.base64decode", {"crypt.base64.decode", "crypt.base64_decode", "base64.decode", "base64_decode"}, function()
		assert(crypt.base64decode("dGVzdA==") == "test", "Base64 decoding failed")
	end)

	test("crypt.encrypt", {}, function()
		local key = crypt.generatekey()
		local encrypted, iv = crypt.encrypt("test", key, nil, "CBC")
		assert(iv, "crypt.encrypt should return an IV")
		local decrypted = crypt.decrypt(encrypted, key, iv, "CBC")
		assert(decrypted == "test", "Failed to decrypt raw string from encrypted data")
	end)

	test("crypt.decrypt", {}, function()
		local key, iv = crypt.generatekey(), crypt.generatekey()
		local encrypted = crypt.encrypt("test", key, iv, "CBC")
		local decrypted = crypt.decrypt(encrypted, key, iv, "CBC")
		assert(decrypted == "test", "Failed to decrypt raw string from encrypted data")
	end)

	test("crypt.generatebytes", {}, function()
		local size = math.random(10, 100)
		local bytes = crypt.generatebytes(size)
		assert(#crypt.base64decode(bytes) == size, "The decoded result should be " .. size .. " bytes long (got " .. #crypt.base64decode(bytes) .. " decoded, " .. #bytes .. " raw)")
	end)

	test("crypt.generatekey", {}, function()
		local key = crypt.generatekey()
		assert(#crypt.base64decode(key) == 32, "Generated key should be 32 bytes long when decoded")
	end)

	test("crypt.hash", {}, function()
		local algorithms = {'sha1', 'sha384', 'sha512', 'md5', 'sha256', 'sha3-224', 'sha3-256', 'sha3-512'}
		for _, algorithm in ipairs(algorithms) do
			local hash = crypt.hash("test", algorithm)
			assert(hash, "crypt.hash on algorithm '" .. algorithm .. "' should return a hash")
		end
	end)

	test("debug.getconstant", {}, function()
		local function test()
			print("Hello, world!")
		end
		assert(debug.getconstant(test, 1) == "print", "First constant must be print")
		assert(debug.getconstant(test, 2) == nil, "Second constant must be nil")
		assert(debug.getconstant(test, 3) == "Hello, world!", "Third constant must be 'Hello, world!'")
	end)

	test("debug.getconstants", {}, function()
		local function test()
			local num = 5000 .. 50000
			print("Hello, world!", num, warn)
		end
		local constants = debug.getconstants(test)
		assert(constants[1] == 50000, "First constant must be 50000")
		assert(constants[2] == "print", "Second constant must be print")
		assert(constants[3] == nil, "Third constant must be nil")
		assert(constants[4] == "Hello, world!", "Fourth constant must be 'Hello, world!'")
		assert(constants[5] == "warn", "Fifth constant must be warn")
	end)

	test("debug.getinfo", {}, function()
		local types = {
			source = "string",
			short_src = "string",
			func = "function",
			what = "string",
			currentline = "number",
			name = "string",
			nups = "number",
			numparams = "number",
			is_vararg = "number",
		}
		local function test(...)
			print(...)
		end
		local info = debug.getinfo(test)
		for k, v in pairs(types) do
			assert(info[k] ~= nil, "Did not return a table with a '" .. k .. "' field")
			assert(type(info[k]) == v, "Did not return a table with " .. k .. " as a " .. v .. " (got " .. type(info[k]) .. ")")
		end
	end)

	test("debug.getproto", {}, function()
		local function test()
			local function proto()
				return true
			end
		end
		local proto = debug.getproto(test, 1, true)[1]
		local realproto = debug.getproto(test, 1)
		assert(proto, "Failed to get the inner function")
		assert(proto() == true, "The inner function did not return anything")
		if not realproto() then
			return "Proto return values are disabled on this executor"
		end
	end)

	test("debug.getprotos", {}, function()
		local function test()
			local function _1()
				return true
			end
			local function _2()
				return true
			end
			local function _3()
				return true
			end
		end
		for i in ipairs(debug.getprotos(test)) do
			local proto = debug.getproto(test, i, true)[1]
			local realproto = debug.getproto(test, i)
			assert(proto(), "Failed to get inner function " .. i)
			if not realproto() then
				return "Proto return values are disabled on this executor"
			end
		end
	end)

	test("debug.getstack", {}, function()
		local _ = "a" .. "b"
		assert(debug.getstack(1, 1) == "ab", "The first item in the stack should be 'ab'")
		assert(debug.getstack(1)[1] == "ab", "The first item in the stack table should be 'ab'")
	end)

	test("debug.getupvalue", {}, function()
		local upvalue = function() end
		local function test()
			print(upvalue)
		end
		assert(debug.getupvalue(test, 1) == upvalue, "Unexpected value returned from debug.getupvalue")
	end)

	test("debug.getupvalues", {}, function()
		local upvalue = function() end
		local function test()
			print(upvalue)
		end
		local upvalues = debug.getupvalues(test)
		assert(upvalues[1] == upvalue, "Unexpected value returned from debug.getupvalues")
	end)

	test("debug.setconstant", {}, function()
		local function test()
			return "fail"
		end
		debug.setconstant(test, 1, "success")
		assert(test() == "success", "debug.setconstant did not set the first constant")
	end)

	test("debug.setstack", {}, function()
		local function test()
			return "fail", debug.setstack(1, 1, "success")
		end
		assert(test() == "success", "debug.setstack did not set the first stack item")
	end)

	test("debug.setupvalue", {}, function()
		local function upvalue()
			return "fail"
		end
		local function test()
			return upvalue()
		end
		debug.setupvalue(test, 1, function()
			return "success"
		end)
		assert(test() == "success", "debug.setupvalue did not set the first upvalue")
	end)

	-- Filesystem

	if isfolder and makefolder and delfolder then
		if isfolder(".tests") then
			delfolder(".tests")
		end
		makefolder(".tests")
	end

	test("readfile", {}, function()
		writefile(".tests/readfile.txt", "success")
		assert(readfile(".tests/readfile.txt") == "success", "Did not return the contents of the file")
	end)

	test("listfiles", {}, function()
		makefolder(".tests/listfiles")
		writefile(".tests/listfiles/test_1.txt", "success")
		writefile(".tests/listfiles/test_2.txt", "success")
		local files = listfiles(".tests/listfiles")
		assert(#files == 2, "Did not return the correct number of files")
		assert(isfile(files[1]), "Did not return a file path")
		assert(readfile(files[1]) == "success", "Did not return the correct files")
		makefolder(".tests/listfiles_2")
		makefolder(".tests/listfiles_2/test_1")
		makefolder(".tests/listfiles_2/test_2")
		local folders = listfiles(".tests/listfiles_2")
		assert(#folders == 2, "Did not return the correct number of folders")
		assert(isfolder(folders[1]), "Did not return a folder path")
	end)

	test("writefile", {}, function()
		writefile(".tests/writefile.txt", "success")
		assert(readfile(".tests/writefile.txt") == "success", "Did not write the file")
		local requiresFileExt = pcall(function()
			writefile(".tests/writefile", "success")
			assert(isfile(".tests/writefile.txt"))
		end)
		if not requiresFileExt then
			return "This executor requires a file extension in writefile"
		end
	end)

	test("makefolder", {}, function()
		makefolder(".tests/makefolder")
		assert(isfolder(".tests/makefolder"), "Did not create the folder")
	end)

	test("appendfile", {}, function()
		writefile(".tests/appendfile.txt", "su")
		appendfile(".tests/appendfile.txt", "cce")
		appendfile(".tests/appendfile.txt", "ss")
		assert(readfile(".tests/appendfile.txt") == "success", "Did not append the file")
	end)

	test("isfile", {}, function()
		writefile(".tests/isfile.txt", "success")
		assert(isfile(".tests/isfile.txt") == true, "Did not return true for a file")
		assert(isfile(".tests") == false, "Did not return false for a folder")
		assert(isfile(".tests/doesnotexist.exe") == false, "Did not return false for a nonexistent path (got " .. tostring(isfile(".tests/doesnotexist.exe")) .. ")")
	end)

	test("isfolder", {}, function()
		assert(isfolder(".tests") == true, "Did not return false for a folder")
		assert(isfolder(".tests/doesnotexist.exe") == false, "Did not return false for a nonexistent path (got " .. tostring(isfolder(".tests/doesnotexist.exe")) .. ")")
	end)

	test("delfolder", {}, function()
		makefolder(".tests/delfolder")
		delfolder(".tests/delfolder")
		assert(isfolder(".tests/delfolder") == false, "Failed to delete folder (isfolder = " .. tostring(isfolder(".tests/delfolder")) .. ")")
	end)

	test("delfile", {}, function()
		writefile(".tests/delfile.txt", "Hello, world!")
		delfile(".tests/delfile.txt")
		assert(isfile(".tests/delfile.txt") == false, "Failed to delete file (isfile = " .. tostring(isfile(".tests/delfile.txt")) .. ")")
	end)

	test("loadfile", {}, function()
		writefile(".tests/loadfile.txt", "return ... + 1")
		assert(assert(loadfile(".tests/loadfile.txt"))(1) == 2, "Failed to load a file with arguments")
		writefile(".tests/loadfile.txt", "f")
		local callback, err = loadfile(".tests/loadfile.txt")
		assert(err and not callback, "Did not return an error message for a compiler error")
	end)

	test("dofile", {})

	test("isrbxactive", {"isgameactive"}, function()
		assert(type(isrbxactive()) == "boolean", "Did not return a boolean value")
	end)

	test("mouse1click", {})

	test("mouse1press", {})

	test("mouse1release", {})

	test("mouse2click", {})

	test("mouse2press", {})

	test("mouse2release", {})

	test("mousemoveabs", {})

	test("mousemoverel", {})

	test("mousescroll", {})

	test("fireclickdetector", {}, function()
		local detector = Instance.new("ClickDetector")
		fireclickdetector(detector, 50, "MouseHoverEnter")
	end)

	test("getcallbackvalue", {}, function()
		local bindable = Instance.new("BindableFunction")
		local function test()
		end
		bindable.OnInvoke = test
		assert(getcallbackvalue(bindable, "OnInvoke") == test, "Did not return the correct value")
	end)

	test("getconnections", {}, function()
		local types = {
			Enabled = "boolean",
			ForeignState = "boolean",
			LuaConnection = "boolean",
			Function = "function",
			Thread = "thread",
			Fire = "function",
			Defer = "function",
			Disconnect = "function",
			Disable = "function",
			Enable = "function",
		}
		local bindable = Instance.new("BindableEvent")
		bindable.Event:Connect(function() end)
		local connection = getconnections(bindable.Event)[1]
		for k, v in pairs(types) do
			assert(connection[k] ~= nil, "Did not return a table with a '" .. k .. "' field")
			assert(type(connection[k]) == v, "Did not return a table with " .. k .. " as a " .. v .. " (got " .. type(connection[k]) .. ")")
		end
	end)

	test("getcustomasset", {}, function()
		writefile(".tests/getcustomasset.txt", "success")
		local contentId = getcustomasset(".tests/getcustomasset.txt")
		assert(type(contentId) == "string", "Did not return a string")
		assert(#contentId > 0, "Returned an empty string")
		assert(string.match(contentId, "rbxasset://") == "rbxasset://", "Did not return an rbxasset url")
	end)

	test("gethiddenproperty", {}, function()
		local fire = Instance.new("Fire")
		local property, isHidden = gethiddenproperty(fire, "size_xml")
		assert(property == 5, "Did not return the correct value")
		assert(isHidden == true, "Did not return whether the property was hidden")
	end)

	test("sethiddenproperty", {}, function()
		local fire = Instance.new("Fire")
		local hidden = sethiddenproperty(fire, "size_xml", 10)
		assert(hidden, "Did not return true for the hidden property")
		assert(gethiddenproperty(fire, "size_xml") == 10, "Did not set the hidden property")
	end)

	test("gethui", {}, function()
		assert(typeof(gethui()) == "Instance", "Did not return an Instance")
	end)

	test("getinstances", {}, function()
		assert(getinstances()[1]:IsA("Instance"), "The first value is not an Instance")
	end)

	test("getnilinstances", {}, function()
		assert(getnilinstances()[1]:IsA("Instance"), "The first value is not an Instance")
		assert(getnilinstances()[1].Parent == nil, "The first value is not parented to nil")
	end)

	test("isscriptable", {}, function()
		local fire = Instance.new("Fire")
		assert(isscriptable(fire, "size_xml") == false, "Did not return false for a non-scriptable property (size_xml)")
		assert(isscriptable(fire, "Size") == true, "Did not return true for a scriptable property (Size)")
	end)

	test("setscriptable", {}, function()
		local fire = Instance.new("Fire")
		local wasScriptable = setscriptable(fire, "size_xml", true)
		assert(wasScriptable == false, "Did not return false for a non-scriptable property (size_xml)")
		assert(isscriptable(fire, "size_xml") == true, "Did not set the scriptable property")
		fire = Instance.new("Fire")
		assert(isscriptable(fire, "size_xml") == false, "⚠️⚠️ setscriptable persists between unique instances ⚠️⚠️")
	end)

	test("setrbxclipboard", {})

	test("getrawmetatable", {}, function()
		local metatable = { __metatable = "Locked!" }
		local object = setmetatable({}, metatable)
		assert(getrawmetatable(object) == metatable, "Did not return the metatable")
	end)

	test("hookmetamethod", {}, function()
		local object = setmetatable({}, { __index = newcclosure(function() return false end), __metatable = "Locked!" })
		local ref = hookmetamethod(object, "__index", function() return true end)
		assert(object.test == true, "Failed to hook a metamethod and change the return value")
		assert(ref() == false, "Did not return the original function")
	end)

	test("getnamecallmethod", {}, function()
		local method
		local ref
		ref = hookmetamethod(game, "__namecall", function(...)
			if not method then
				method = getnamecallmethod()
			end
			return ref(...)
		end)
		game:GetService("Lighting")
		assert(method == "GetService", "Did not get the correct method (GetService)")
	end)

	test("isreadonly", {}, function()
		local object = {}
		table.freeze(object)
		assert(isreadonly(object), "Did not return true for a read-only table")
	end)

	test("setrawmetatable", {}, function()
		local object = setmetatable({}, { __index = function() return false end, __metatable = "Locked!" })
		local objectReturned = setrawmetatable(object, { __index = function() return true end })
		assert(object, "Did not return the original object")
		assert(object.test == true, "Failed to change the metatable")
		if objectReturned then
			return objectReturned == object and "Returned the original object" or "Did not return the original object"
		end
	end)

	test("setreadonly", {}, function()
		local object = { success = false }
		table.freeze(object)
		setreadonly(object, false)
		object.success = true
		assert(object.success, "Did not allow the table to be modified")
	end)

	test("identifyexecutor", {"getexecutorname"}, function()
		local name, version = identifyexecutor()
		assert(type(name) == "string", "Did not return a string for the name")
		return type(version) == "string" and "Returns version as a string" or "Does not return version"
	end)

	test("lz4compress", {}, function()
		local raw = "Hello, world!"
		local compressed = lz4compress(raw)
		assert(type(compressed) == "string", "Compression did not return a string")
		assert(lz4decompress(compressed, #raw) == raw, "Decompression did not return the original string")
	end)

	test("lz4decompress", {}, function()
		local raw = "Hello, world!"
		local compressed = lz4compress(raw)
		assert(type(compressed) == "string", "Compression did not return a string")
		assert(lz4decompress(compressed, #raw) == raw, "Decompression did not return the original string")
	end)

	test("messagebox", {})

	test("queue_on_teleport", {"queueonteleport"})

	test("request", {"http.request", "http_request"}, function()
		local response = request({
			Url = "https://httpbin.org/user-agent",
			Method = "GET",
		})
		assert(type(response) == "table", "Response must be a table")
		assert(response.StatusCode == 200, "Did not return a 200 status code")
		local data = game:GetService("HttpService"):JSONDecode(response.Body)
		assert(type(data) == "table" and type(data["user-agent"]) == "string", "Did not return a table with a user-agent key")
		return "User-Agent: " .. data["user-agent"]
	end)

	test("setclipboard", {"toclipboard"})

	test("setfpscap", {}, function()
		local renderStepped = game:GetService("RunService").RenderStepped
		local function step()
			renderStepped:Wait()
			local sum = 0
			for _ = 1, 5 do
				sum += 1 / renderStepped:Wait()
			end
			return math.round(sum / 5)
		end
		setfpscap(60)
		local step60 = step()
		setfpscap(0)
		local step0 = step()
		return step60 .. "fps @60 • " .. step0 .. "fps @0"
	end)

	test("getgc", {}, function()
		local gc = getgc()
		assert(type(gc) == "table", "Did not return a table")
		assert(#gc > 0, "Did not return a table with any values")
	end)

	test("getgenv", {}, function()
		getgenv().__TEST_GLOBAL = true
		assert(__TEST_GLOBAL, "Failed to set a global variable")
		getgenv().__TEST_GLOBAL = nil
	end)

	test("getloadedmodules", {}, function()
		local modules = getloadedmodules()
		assert(type(modules) == "table", "Did not return a table")
		assert(#modules > 0, "Did not return a table with any values")
		assert(typeof(modules[1]) == "Instance", "First value is not an Instance")
		assert(modules[1]:IsA("ModuleScript"), "First value is not a ModuleScript")
	end)

	test("getrenv", {}, function()
		assert(_G ~= getrenv()._G, "The variable _G in the executor is identical to _G in the game")
	end)

	test("getrunningscripts", {}, function()
		local scripts = getrunningscripts()
		assert(type(scripts) == "table", "Did not return a table")
		assert(#scripts > 0, "Did not return a table with any values")
		assert(typeof(scripts[1]) == "Instance", "First value is not an Instance")
		assert(scripts[1]:IsA("ModuleScript") or scripts[1]:IsA("LocalScript"), "First value is not a ModuleScript or LocalScript")
	end)

	test("getscriptbytecode", {"dumpstring"}, function()
		local animate = game:GetService("Players").LocalPlayer.Character.Animate
		local bytecode = getscriptbytecode(animate)
		assert(type(bytecode) == "string", "Did not return a string for Character.Animate (a " .. animate.ClassName .. ")")
	end)

	test("getscripthash", {}, function()
		local animate = game:GetService("Players").LocalPlayer.Character.Animate:Clone()
		local hash = getscripthash(animate)
		local source = animate.Source
		animate.Source = "print('Hello, world!')"
		task.defer(function()
			animate.Source = source
		end)
		local newHash = getscripthash(animate)
		assert(hash ~= newHash, "Did not return a different hash for a modified script")
		assert(newHash == getscripthash(animate), "Did not return the same hash for a script with the same source")
	end)

	test("getscripts", {}, function()
		local scripts = getscripts()
		assert(type(scripts) == "table", "Did not return a table")
		assert(#scripts > 0, "Did not return a table with any values")
		assert(typeof(scripts[1]) == "Instance", "First value is not an Instance")
		assert(scripts[1]:IsA("ModuleScript") or scripts[1]:IsA("LocalScript"), "First value is not a ModuleScript or LocalScript")
	end)

	test("getsenv", {}, function()
		local animate = game:GetService("Players").LocalPlayer.Character.Animate
		local env = getsenv(animate)
		assert(type(env) == "table", "Did not return a table for Character.Animate (a " .. animate.ClassName .. ")")
		assert(env.script == animate, "The script global is not identical to Character.Animate")
	end)

	test("getthreadidentity", {"getidentity", "getthreadcontext"}, function()
		assert(type(getthreadidentity()) == "number", "Did not return a number")
	end)

	test("setthreadidentity", {"setidentity", "setthreadcontext"}, function()
		setthreadidentity(3)
		assert(getthreadidentity() == 3, "Did not set the thread identity")
	end)

	test("Drawing", {})

	test("Drawing.new", {}, function()
		local drawing = Drawing.new("Square")
		drawing.Visible = false
		local canDestroy = pcall(function()
			drawing:Destroy()
		end)
		assert(canDestroy, "Drawing:Destroy() should not throw an error")
	end)

	test("Drawing.Fonts", {}, function()
		assert(Drawing.Fonts.UI == 0, "Did not return the correct id for UI")
		assert(Drawing.Fonts.System == 1, "Did not return the correct id for System")
		assert(Drawing.Fonts.Plex == 2, "Did not return the correct id for Plex")
		assert(Drawing.Fonts.Monospace == 3, "Did not return the correct id for Monospace")
	end)

	test("isrenderobj", {}, function()
		local drawing = Drawing.new("Image")
		drawing.Visible = true
		assert(isrenderobj(drawing) == true, "Did not return true for an Image")
		assert(isrenderobj(newproxy()) == false, "Did not return false for a blank table")
	end)

	test("getrenderproperty", {}, function()
		local drawing = Drawing.new("Image")
		drawing.Visible = true
		assert(type(getrenderproperty(drawing, "Visible")) == "boolean", "Did not return a boolean value for Image.Visible")
		local success, result = pcall(function()
			return getrenderproperty(drawing, "Color")
		end)
		if not success or not result then
			return "Image.Color is not supported"
		end
	end)

	test("setrenderproperty", {}, function()
		local drawing = Drawing.new("Square")
		drawing.Visible = true
		setrenderproperty(drawing, "Visible", false)
		assert(drawing.Visible == false, "Did not set the value for Square.Visible")
	end)

	test("cleardrawcache", {}, function()
		cleardrawcache()
	end)

	test("WebSocket", {})

	test("WebSocket.connect", {}, function()
		local types = {
			Send = "function",
			Close = "function",
			OnMessage = {"table", "userdata"},
			OnClose = {"table", "userdata"},
		}
		local ws = WebSocket.connect("ws://echo.websocket.events")
		assert(type(ws) == "table" or type(ws) == "userdata", "Did not return a table or userdata")
		for k, v in pairs(types) do
			if type(v) == "table" then
				assert(table.find(v, type(ws[k])), "Did not return a " .. table.concat(v, ", ") .. " for " .. k .. " (a " .. type(ws[k]) .. ")")
			else
				assert(type(ws[k]) == v, "Did not return a " .. v .. " for " .. k .. " (a " .. type(ws[k]) .. ")")
			end
		end
		ws:Close()
	end)
	
	local result = Instance.new("TextLabel")

	result.Name = "result"
	result.Parent = Frame
	result.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	result.BackgroundTransparency = 1.000
	result.BorderColor3 = Color3.fromRGB(0, 0, 0)
	result.BorderSizePixel = 0
	result.Position = UDim2.new(0.795134425, 0, 0.0146788992, 0)
	result.Size = UDim2.new(0, 151, 0, 18)
	result.Font = Enum.Font.GothamBlack
	result.Text = "result"
	result.TextColor3 = Color3.fromRGB(255, 255, 255)
	result.TextSize = 12.000
	result.TextXAlignment = Enum.TextXAlignment.Right

	local function printSummary()
		if running == 0 then
			local totalTests = passes + fails
			local rate = totalTests > 0 and math.round((passes / totalTests) * 100) or 0
			local outOf = passes .. " out of " .. totalTests

			result.Text = "result : ".. rate .. " % success rate (".. outOf .. ")" 
		end
	end

	task.defer(function()
		repeat task.wait() until running == 0
		printSummary()
	end)
end

unc_lib.create()
