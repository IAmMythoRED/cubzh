--- This module allows you to create UI toast messages

ui = require("uikit")
ease = require("ease")
conf = require("config")
local PADDING = require("uitheme").current.paddingTiny

local mod = {}

defaultConfig = {
	text = "test",
	ui = ui,
}

mod.create = function(_, config)
	config = conf:merge(defaultConfig, config)
	local ui = config.ui

	local badge = ui:createNode()

	local frame = ui:createFrame(Color(255, 0, 0))
	frame:setParent(badge)

	local text = ui:createText(config.text, Color.White, "small")
	text:setParent(frame)
	text.pos = { PADDING, PADDING }

	badge.frame = frame
	badge.text = text

	if refreshBadge == nil then
		refreshBadge = function(badge)
			badge.frame.Height = badge.text.Height + PADDING * 2
			badge.frame.Width = math.max(badge.text.Width + PADDING * 2, badge.frame.Height)

			badge.text.pos =
				{ badge.frame.Width * 0.5 - badge.text.Width * 0.5, badge.frame.Height * 0.5 - badge.text.Height * 0.5 }

			badge.frame.pos = { -badge.frame.Width * 0.5, -badge.frame.Height * 0.5 }
			badge.object.LocalPosition.Z = -995
			badge.object.Scale = 0.7
		end
	end

	badge.parentDidResize = refreshBadge
	badge:parentDidResize()

	logoAnim = {}
	logoAnim.start = function()
		ease:inOutSine(badge.object, 0.15, {
			onDone = function()
				ease:inOutSine(badge.object, 0.15, {
					onDone = function()
						logoAnim.start()
					end,
				}).Scale =
					Number3(0.9, 0.9, 0.9)
			end,
		}).Scale =
			Number3(1.1, 1.1, 1.1)
	end
	logoAnim.start()

	return badge
end

return mod
