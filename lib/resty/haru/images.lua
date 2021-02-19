local lib          = require "resty.haru.library"
local image        = require "resty.haru.image"
local ffi          = require "ffi"
local ffi_cast     = ffi.cast
local sub          = string.sub
local lower        = string.lower
local setmetatable = setmetatable

local images       = {}
images.__index     = images

function images.new(context)
    return setmetatable({ context = context }, images)
end

function images:load(file)
    local context
    local ext = lower(sub(file, -4))
    if ext == '.png' then
        context = lib.HPDF_LoadPngImageFromFile(self.context, file)
    elseif ext == ".jpg" then
        context = lib.HPDF_LoadJpegImageFromFile(self.context, file)
    end
    if context == nil then return nil end
    return image.new(context)
end

function images:load_from_mem(ext, buffer, w, h, space, bits_per_component)

    local context
    if ext == "raw" then
        context = lib.HPDF_LoadRawImageFromMem(self.context, buffer, w, h, space, bits_per_component)
    elseif ext == "jpg" then
        context = lib.HPDF_LoadJpegImageFromMem(self.context,buffer, w)
    elseif ext == "png" then
        context = lib.HPDF_LoadPngImageFromMem(self.context,buffer, w)
    end

    if ffi_cast("void *", context) <= nil then return nil end

    return image.new(context)
end

return images
