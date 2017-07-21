local component = require("component")
local unicode = require("unicode")
local term = require("term")

local GUI = {}

function GUI.SetColor(foreground, background)
	component.gpu.setForeground(foreground)
	component.gpu.setBackground(background)
end

function GUI.GetColor()
	return component.gpu.getForeground(), component.gpu.getBackground()
end

function GUI.DrawProgressBar(x, y, width, height, foreground, background, percent)
	local activeWidth = math.ceil(width * percent / 100)
	GUI.DrawRect(x, y, width, height, 0x696969, background, "─")
	GUI.DrawRect(x, y, activeWidth, height, foreground, background, "─")
end

function GUI.DrawRect(x, y, w, h, colorF, colorB, symbol)
	if colorF and colorB then
		GUI.SetColor(colorF, colorB)
	end
	if symbol then
		component.gpu.fill(x, y, w, h, symbol)
	else
		component.gpu.fill(x, y, w, h, ' ')
	end
end

function GUI.DrawButton(x, y, text, isDeep, colorF, colorB)
	if colorF and colorB then
		GUI.SetColor(colorF, colorB)
	end

	local MaxString = 0

	local line = 1
	while text[line] do
		if unicode.len(text[line]) > MaxString then
			MaxString = unicode.len(text[line])
		end
		line = line + 1
	end
	line = nil

	if isDeep then
		GUI.DrawRect(x, y, MaxString + 2, #text, 0xFFFFFF, 0x333333)
		
		local yPos = y
		for i = 1, #text do
			if text[i] then
				component.gpu.set(x + 1, yPos, text[i])
				yPos = yPos + 1
			else
				break
			end
		end
		yPos = nil
	else
		GUI.DrawRect(x, y, MaxString, #text, 0xFFFFFF, 0x333333)
		
		local yPos = y
		for i = 1, #text do
			if text[i] then
				component.gpu.set(x, yPos, text[i])
				yPos = yPos + 1
			else
				break
			end
		end
		yPos = nil
	end
end

function GUI.DrawText(x, y, text, colorF, colorB)
	if colorF and colorB then
		GUI.SetColor(colorF, colorB)
	end

	term.setCursor(x, y)
	term.write(text)
end

return GUI