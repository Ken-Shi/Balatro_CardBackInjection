--- STEAMODDED HEADER
--- MOD_NAME: Card Back Injection
--- MOD_ID: CardBackInjection
--- MOD_AUTHOR: [Kenny Stone, JoStro]
--- MOD_DESCRIPTION: trying to change card backs
----------------------------------------------
------------MOD CODE -------------------------

function SMODS.INIT.CardBackInjection()

    local cbi_mod = SMODS.findModByID("CardBackInjection")

    -- Find path to the directory containing card back images
    local directory = cbi_mod.path .. "assets/" .. G.SETTINGS.GRAPHICS.texture_scaling .. "x/"
    -- Path to Enhancer.png (497x475 or twice as large) 
    -- Not loading it from original game file in case anything bad happen
    local baseImagePath = cbi_mod.path .. "assets/" .. G.SETTINGS.GRAPHICS.texture_scaling .. "x/OGEnhancers.png" 
    
    local files = love.filesystem.getDirectoryItems(directory)
    
    local scale = tonumber(G.SETTINGS.GRAPHICS.texture_scaling)

    -- Load the base image
    local baseImage = love.graphics.newImage(baseImagePath)
    local images = {}
    local lookup = {}
    local index_x = 0
    local index_y = 5

    -- Load all 'b_' prefixed images
    for _, file in ipairs(files) do
        if file:sub(1, 2) == "b_" and file:sub(-4) == ".png" then
            local imagePath = directory .. file
            local image = love.graphics.newImage(imagePath)
            local image_name = string.sub(file, 3, -5)
            if image:getWidth() == 71 * scale and image:getHeight() == 95 * scale then
                table.insert(images, image)
                -- Insert lookup information
                lookup[image_name] = {x=index_x, y=index_y}
                index_x = (index_x + 1) % 7
                if index_x == 0 then index_y = index_y + 1 end 
            end
        end
    end

    -- Create a canvas to hold the combined image
    local totalHeight = 475 + math.floor((#images - 1) / 7) * 95 -- base image height + number of 'b_' images * their height
    local canvas = love.graphics.newCanvas(497 * scale, totalHeight * scale)
    love.graphics.setCanvas(canvas)

    -- Put the OG enhancer on there first
    love.graphics.draw(baseImage, 0, 0)
    local canvas_x = 0
    local canvas_y = baseImage:getHeight()
    
    -- Draw the base image and then append all 'b_' images
    for _, image in ipairs(images) do
        --love.graphics.draw(image, 0, 0)
        love.graphics.draw(image, canvas_x, canvas_y)
        canvas_x = (canvas_x + image:getWidth()) % baseImage:getWidth()
        if canvas_x == 0 then canvas_y = canvas_y + image:getHeight() end
    end

    -- Reset canvas to default
    love.graphics.setCanvas() 

    -- Create an ImageData from the Canvas
    local imageData = canvas:newImageData()

    -- Set asset atlas centers to this new image
    G.ASSET_ATLAS["centers"].image = love.graphics.newImage(imageData, {mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling})

    -- Return the lookup table for position
    return lookup

end


----------------------------------------------
------------MOD CODE END----------------------