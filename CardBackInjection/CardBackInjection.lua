--- STEAMODDED HEADER
--- MOD_NAME: Card Back Injection Ver 2.1.0
--- MOD_ID: CardBackInjection
--- MOD_AUTHOR: [Kenny Stone]
--- MOD_DESCRIPTION: systematically loads all the card back files into the system
----------------------------------------------
------------MOD CODE -------------------------

function CreateCardBackCollection(scale)
    
    local scale = scale or 2
    
    --Set fiter to linear interpolation and nearest, best for pixel art
    love.graphics.setDefaultFilter(
        scale == 1 and 'nearest' or 'linear',
        scale == 1 and 'nearest' or 'linear', 1)

    love.graphics.setLineStyle("rough")

    --local cbi_mod = SMODS.findModByID("CardBackInjection")
    --local cbi_mod_path = cbi_mod.path
    local cbi_mod_path = 'Mods/'
    --local cbi_mod_path2 = love.filesystem.getSaveDirectory().."/Mods/"

    -- Find path to the directory containing card back images
    local asset_directory = cbi_mod_path .. "assets/" .. scale .. "x/"
    --local asset_directory_absolute = cbi_mod_path2 .. "assets/" .. scale .. "x/"
    -- Path to Enhancer.png (497x475 or twice as large) 
    -- Not loading it from original game file in case anything bad happen
    local baseImagePath = cbi_mod_path .. "CardBackInjection/assets/" .. scale .. "x/OGEnhancers.png"

    local all_mod_directories = NFS.getDirectoryItems(cbi_mod_path)

    -- Load the base image
    local baseImage = love.graphics.newImage(baseImagePath)
    local baseImage_height = baseImage:getHeight()
    local baseImage_width = baseImage:getWidth()
    local all_b_images = {}
    local lookup = {}
    local index_x = 0
    local index_y = 5

    -- Load all 'b_' prefixed images
    for _, item in ipairs(all_mod_directories) do
        local info = NFS.getInfo(cbi_mod_path..item)
        if info and info.type == "directory" and item ~= "assets" then
            local d_path = cbi_mod_path .. "/" .. item .. "/assets/" .. scale .. "x/"
            all_asset_files = NFS.getDirectoryItems(d_path)
            for _, file in ipairs(all_asset_files) do
                if file:sub(1, 2) == "b_" and file:sub(-4) == ".png" then
                    local b_imagePath = d_path .. file
                    local b_image = love.graphics.newImage(b_imagePath)
                    local b_image_name = string.sub(file, 3, -5)
                    table.insert(all_b_images, b_image)
                    -- Insert lookup information
                    lookup[b_image_name] = {x=index_x, y=index_y}
                    index_x = (index_x + 1) % 7
                    if index_x == 0 then index_y = index_y + 1 end 
                end
            end
        elseif info and info.type == "directory" and item == "assets" then
            all_asset_files = NFS.getDirectoryItems(asset_directory)
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
        end
    end

    -- Create a canvas to hold the combined image
    local totalHeight = baseImage_height + (math.floor((#all_b_images - 1) / 7) + 1) * math.floor(baseImage_height / 5) -- base image height + number of 'b_' images * their height
    local centers_canvas = love.graphics.newCanvas(baseImage_width, totalHeight, {mipmaps = "auto", })
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
        canvas_x = (canvas_x + image:getWidth()) % baseImage_width
        if canvas_x == 0 then canvas_y = canvas_y + image:getHeight() end
    end

    -- Reset canvas to default
    love.graphics.setCanvas() 

    -- Create an ImageData from the Canvas
    local centers_image_data = centers_canvas:newImageData()

    centers_image_data:encode('png', cbi_mod_path .. "CardBackInjection/assets/" .. scale .. "x/"..'NewEnhancer.png')


    sendDebugMessage('Card Back Collection Creation Completed!')

    return lookup

end

function ReadCardBackInfo(scale)
    
    local scale = scale or 2
    local cbi_mod_path = 'Mods/'
    local asset_directory = cbi_mod_path .. "assets/" .. scale .. "x/"
    local all_mod_directories = NFS.getDirectoryItems(cbi_mod_path)

    local lookup = {}
    local index_x = 0
    local index_y = 5

    -- Load all 'b_' prefixed images
    for _, item in ipairs(all_mod_directories) do
        local info = NFS.getInfo(cbi_mod_path..item)
        if info and info.type == "directory" and item ~= "assets" then
            local d_path = cbi_mod_path .. "/" .. item .. "/assets/" .. scale .. "x/"
            all_asset_files = NFS.getDirectoryItems(d_path)
            for _, file in ipairs(all_asset_files) do
                if file:sub(1, 2) == "b_" and file:sub(-4) == ".png" then
                    local b_image_name = string.sub(file, 3, -5)
                    -- Insert lookup information
                    lookup[b_image_name] = {x=index_x, y=index_y}
                    index_x = (index_x + 1) % 7
                    if index_x == 0 then index_y = index_y + 1 end 
                end
            end
        elseif info and info.type == "directory" and item == "assets" then
            all_asset_files = NFS.getDirectoryItems(asset_directory)
            for _, file in ipairs(all_asset_files) do
                if file:sub(1, 2) == "b_" and file:sub(-4) == ".png" then
                    local b_image_name = string.sub(file, 3, -5)
                    -- Insert lookup information
                    lookup[b_image_name] = {x=index_x, y=index_y}
                    index_x = (index_x + 1) % 7
                    if index_x == 0 then index_y = index_y + 1 end 
                end
            end
        end
    end

    return lookup

end

function InjectCardBack()

    --local new_path = love.filesystem.getSaveDirectory().."/Mods/assets/" .. G.SETTINGS.GRAPHICS.texture_scaling .. "x/NewEnhancer.png"
    --local scale = G.SETTINGS.GRAPHICS.texture_scaling
    local new_path = "Mods/CardBackInjection/assets/".. G.SETTINGS.GRAPHICS.texture_scaling .."x/NewEnhancer.png"

    -- Set asset atlas centers to this new image
    --G.ASSET_ATLAS["centers"].image = love.graphics.newImage(centers_image_Data)
    G.asset_atli[3] = {name = "centers", path = new_path ,px=71,py=95}
    G.ASSET_ATLAS[G.asset_atli[3].name] = {}
    G.ASSET_ATLAS[G.asset_atli[3].name].name = G.asset_atli[3].name
    G.ASSET_ATLAS[G.asset_atli[3].name].image = love.graphics.newImage(G.asset_atli[3].path, {mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling})
    G.ASSET_ATLAS[G.asset_atli[3].name].type = G.asset_atli[3].type
    G.ASSET_ATLAS[G.asset_atli[3].name].px = G.asset_atli[3].px
    G.ASSET_ATLAS[G.asset_atli[3].name].py = G.asset_atli[3].py

    -- Return the lookup table for position
    return lookup

end

-- Function to wrap an existing method with your additional logic
function wrapMethod(class, methodName, additionalFunc)
    local originalMethod = class[methodName]

    class[methodName] = function(self)
        -- Call the additional function
        originalMethod(self)
        --sendDebugMessage('Rendering Reset Triggered!')
        additionalFunc()
        --sendDebugMessage('Card Back Injection Triggered!')
        -- Then call the original method with 'self' and any arguments
        return 
    end
end

function SMODS.INIT.CardBackInjection()

    CreateCardBackCollection(1)
    CreateCardBackCollection(2)

    wrapMethod(Game, "set_render_settings", InjectCardBack)
    G:set_render_settings()

    --sendDebugMessage("Card Back Injection Completed! ")

end


----------------------------------------------
------------MOD CODE END----------------------