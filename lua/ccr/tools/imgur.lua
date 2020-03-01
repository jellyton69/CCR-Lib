
CCR.ImgurImages = CCR.ImgurImages || {}

local path = "ccr/imgur_images/"
local matError = Material("error")
local matLoading = Material("xenin/loading.png", "smooth") // TODO: Rename/Add Xenin mat to our lib, its mine anyway

local function dl(imageData)
	assert(imageData, "Invalid image data")

	imageData.type = imageData.type || "png"
	imageData.params = imageData.params || "smooth"

	local p = CCR:NewPromise()

	local img = file.Read(path .. imageData.id .. "." .. imageData.type, "DATA")
	if (img) then
		p:resolve(Material("../data/" .. path .. imageData.id .. "." .. imageData.type, imageData.params || "smooth"))
		return p
	end

	http.Fetch("https://i.imgur.com/" .. imageData.id .. "." .. imageData.type, function(body)
		file.CreateDir(path)
		file.Write(path .. imageData.id .. "." .. imageData.type, body)

		local mat = file.Read(path .. imageData.id .. "." .. imageData.type)
		if (!mat) then
			p:reject()
			return
		end

		CCR:Debug("Successfully downloaded image off Imgur (" .. imageData.id .. ")")

		p:resolve(Material("../data/" .. path .. imageData.id .. "." .. imageData.type, imageData.params))
	end, function()
		p:reject()
	end)

	return p
end

function CCR:GetImgurImage(imageId, imageData)
	if (self.ImgurImages[imageId]) then
		if (istable(self.ImgurImages[imageId])) then // its a promise
			return matLoading
		end

		return self.ImgurImages[imageId]
	end

	//assert(imageData, "No image data")
	if (!imageData) then
		return matError
	end

	if (isstring(imageData)) then
		imageData = {
			id = imageData,
			type = "png"
		}
	end

	self.ImgurImages[imageId] = p // NOTE: Set to promise ABOVE dl() because file.Read is instant

	dl(imageData):next(function(img)
		self.ImgurImages[imageId] = img
	end, function()
		CCR:PromiseError("Failed to download image. (" .. imageData.id .. ")")
	end)

	return matLoading
end

CCR:GetImgurImage("test", {id = "ZF0p28U"})

function CCR:DrawImgurImage(id, x, y, w, h, clr)
	local img = self:GetImgurImage(id)
	if (img == matLoading) then
		self:DrawLoading(x + w / 2, y + h / 2, math.max(math.min(w, h) / 2, 32), color_white)
		return
	end

	surface.SetMaterial(img)
	surface.SetDrawColor(clr || clr_white)
	surface.DrawTexturedRect(x, y, w, h)
end