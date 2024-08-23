
function _init()
    lastT = 0 --unused
    currMap = 0
    scenes = {}
    entities = {}
    traps = {}
    player = nil
    fading = false
    fadeCount = 0

    sprites = {
        player = 64,
        enemy = 80,
        mouse = 96,
        torch = 21,
        trapClosed = 12,
        trapOpen = 28,
    }
    
    loadMap(currMap)
end

function _update()

    -- local t = time()
    -- local dt = t - lastT
    -- lastT = t

    controls.update(player)

    for ent in all(entities) do
        ent:update(dt)
    end
end

function _draw()

    cls()

    local mapX, mapY = getMapOffset()
    map(mapX, mapY, 0, 0, 16, 16)

    for ent in all(entities) do
        ent:draw()
    end

    if fading then
        fadeCount = fadeCount + 1
        local normalized = (fadeCount/30)
        
        -- fade out
        if normalized <= 1 then
            for y=0, normalized*127 do
                rect(0, y, 127, y+1, 0)
            end
        end

        -- load next map
        if normalized == 1 then
            loadMap(currMap+1)
        end

        -- fade in
        if normalized > 1 then
            for y=(normalized-1)*127, 127 do
                rect(0, y, 127, y+1, 0)
            end
        end

        -- end fade
        if normalized >= 2 then
            fading = false
            fadeCount = 0
        end
    end
end

function getMapOffset() 
    local mapX = currMap * 16
    local mapY = 0

    return mapX, mapY
end

function nextMap() 
    fading = true
end

function loadMap(index) 
    -- reset
    entities = {}
    traps = {}
    player = nil
    currMap = index

    local mapX, mapY = getMapOffset()

    -- scan the current map for special sprites
    for x=0,15 do
        for y=0,15 do
            local mval = mget(mapX + x, mapY + y)
            -- traps
            if mval == sprites.trapOpen or mval == sprites.trapClosed then
                local t = trap:new({
                    x = x * 8,
                    y = y * 8,
                    open = mval == sprites.trapOpen,
                });
                add(traps, t)

            -- torches
            elseif mval == sprites.torch then
                local torch = entity:new({
                    x = x * 8,
                    y = y * 8,
                    sp = sprites.torch,
                    anim = {
                        idle={21,22}
                    }
                })
                add(entities, torch)

            -- player
            elseif mval == sprites.player then
                player = entity:new({
                    x = x * 8,
                    y = y * 8,
                    sp = sprites.player,
                    anim={
                        idle={64,65},
                        movex={66,67},
                        movey={68,69},
                        death={70,70},
                    }
                })
                mset(mapX + x, mapY + y, 0) -- erase spawn tile

            -- enemy
            elseif mval == sprites.enemy then
                enemy = entity:new({
                    x = x * 8,
                    y = y * 8,
                    sp = sprites.enemy,
                    anim={
                        idle={80,81},
                        movex={82,83},
                        movey={84,85},
                        death={86,86},
                    }
                })
                mset(mapX + x, mapY + y, 0) -- erase spawn tile
                add(entities, enemy)
            end
        end
    end

    -- make sure player is highest draw
    add(entities, player)
end