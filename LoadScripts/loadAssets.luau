local ContentProvider = game:GetService("ContentProvider")
local animsToLoad = {
	"rbxassetid://16183127552",
	"rbxassetid://16183135922",
	"rbxassetid://16183141141",
	"rbxassetid://16194407379",
	"rbxassetid://16194400131",
	"rbxassetid://123075318125026",
}

local animations = {}
for _, assetId in ipairs(animsToLoad) do
	local animation = Instance.new("Animation")
	animation.AnimationId = assetId
	table.insert(animations, animation)
end

ContentProvider:PreloadAsync(animations)