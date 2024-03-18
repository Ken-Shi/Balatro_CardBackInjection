--- STEAMODDED HEADER
--- MOD_NAME: Card Back Injection Ver 1.0.0
--- MOD_ID: CardBackInjection
--- MOD_AUTHOR: [Kenny Stone, JoStro]
--- MOD_DESCRIPTION: systematically loads all the card back files into the system
----------------------------------------------
------------MOD CODE -------------------------

function InjectCardBack()

    G.SETTINGS.GRAPHICS.texture_scaling = G.SETTINGS.GRAPHICS.texture_scaling or 2
    --Set fiter to linear interpolation and nearest, best for pixel art
    love.graphics.setDefaultFilter(
        G.SETTINGS.GRAPHICS.texture_scaling == 1 and 'nearest' or 'linear',
        G.SETTINGS.GRAPHICS.texture_scaling == 1 and 'nearest' or 'linear', 1)

    love.graphics.setLineStyle("rough")

    local cbi_mod = SMODS.findModByID("CardBackInjection")

    -- Find path to the directory containing card back images
    local asset_directory = cbi_mod.path .. "assets/" .. G.SETTINGS.GRAPHICS.texture_scaling .. "x/"
    -- Path to Enhancer.png (497x475 or twice as large) 
    -- Not loading it from original game file in case anything bad happen
    local baseImagePath = cbi_mod.path .. "assets/" .. G.SETTINGS.GRAPHICS.texture_scaling .. "x/OGEnhancers.png" 
    
    local all_asset_files = love.filesystem.getDirectoryItems(asset_directory)
    
    local scale = tonumber(G.SETTINGS.GRAPHICS.texture_scaling)

    -- Load the base image
    local baseImage = love.graphics.newImage(baseImagePath)
    local baseImage_height = baseImage:getHeight()
    local baseImage_width = baseImage:getWidth()
    local all_b_images = {}
    local lookup = {}
    local index_x = 0
    local index_y = 5

    -- Load all 'b_' prefixed images
    for _, file in ipairs(all_asset_files) do
        if file:sub(1, 2) == "b_" and file:sub(-4) == ".png" then
            local b_imagePath = asset_directory .. file
            local b_image = love.graphics.newImage(b_imagePath)
            local b_image_name = string.sub(file, 3, -5)
            table.insert(all_b_images, b_image)
            -- Insert lookup information
            lookup[b_image_name] = {x=index_x, y=index_y}
            index_x = (index_x + 1) % 7
            if index_x == 0 then index_y = index_y + 1 end 
        end
    end

    -- Create a canvas to hold the combined image
    local totalHeight = baseImage_height + (math.floor((#all_b_images - 1) / 7) + 1) * math.floor(baseImage_height / 5) -- base image height + number of 'b_' images * their height
    --sendDebugMessage(baseImage_width)
    --sendDebugMessage(totalHeight)
    local centers_canvas = love.graphics.newCanvas(baseImage_width, totalHeight, {mipmaps = "auto",dpiscale=scale})
    love.graphics.clear(1,1,1,0)
    love.graphics.setCanvas(centers_canvas)

    -- Put the OG enhancer on there first
    love.graphics.draw(baseImage, 0, 0)
    local canvas_x = 0
    local canvas_y = baseImage_height
    
    -- Draw the base image and then append all 'b_' images
    for _, image in ipairs(all_b_images) do
        --love.graphics.draw(image, 0, 0)
        love.graphics.draw(image, canvas_x, canvas_y)
        sendDebugMessage("image found and drawn at: ")
        sendDebugMessage(canvas_x)
        sendDebugMessage(canvas_y)
        canvas_x = (canvas_x + image:getWidth()) % baseImage_width
        if canvas_x == 0 then canvas_y = canvas_y + image:getHeight() end
    end

    -- Reset canvas to default
    love.graphics.setCanvas() 

    -- Create an ImageData from the Canvas
    local centers_image_data = centers_canvas:newImageData()

    -- Set asset atlas centers to this new image
    --G.ASSET_ATLAS["centers"].image = love.graphics.newImage(centers_image_Data)
    G.asset_atli[3] = {name = "centers", path = centers_image_data ,px=71,py=95}
    for i=1, #G.asset_atli do
        G.ASSET_ATLAS[G.asset_atli[i].name] = {}
        G.ASSET_ATLAS[G.asset_atli[i].name].name = G.asset_atli[i].name
        G.ASSET_ATLAS[G.asset_atli[i].name].image = love.graphics.newImage(G.asset_atli[i].path, {mipmaps = true, dpiscale = scale})
        G.ASSET_ATLAS[G.asset_atli[i].name].type = G.asset_atli[i].type
        G.ASSET_ATLAS[G.asset_atli[i].name].px = G.asset_atli[i].px
        G.ASSET_ATLAS[G.asset_atli[i].name].py = G.asset_atli[i].py
    end

    -- Return the lookup table for position
    return lookup

end

function SMODS.INIT.CardBackInjection()

    G.cardback_info = InjectCardBack()
    sendDebugMessage("Card Back Injection Completed! ")
    --sendDebugMessage(G.cardback_info["xplaying"].x)
    --sendDebugMessage(G.cardback_info["xplaying"].y)

end


----------------------------------------------
------------MOD CODE END----------------------