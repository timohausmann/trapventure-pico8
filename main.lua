
function _init()
    lastT = 0
    scenes={}
    entities={}
    traps={}
    player=nil

    sprites = {
        player = 64,
        enemy = 80,
        mouse = 96,
        torch = 21,
        trapClosed = 12,
        trapOpen = 28,
    }
    
    -- scan the current map for special sprites
    for x=0,15 do
        for y=0,15 do
            local mval = mget(x,y)
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
                    }
                })
                mset(x, y, 0) -- erase spawn tile
            end
        end
    end

    -- make sure player is highest draw
    add(entities, player)
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
    -- print("roflmao")

    cls()
    map(0, 0, 0, 0, 16, 16)

    for ent in all(entities) do
        ent:draw()
    end
end