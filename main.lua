
function _init()
    lastT = 0
    scenes={}
    entities={}
    player=entity:new({
        x=4*8,
        y=8*8,
        sp=64,
        anim={
            idle={64,65},
            movex={66,67},
            movey={68,69},
        }
    })

    add(entities, player)

    controls.init()

    -- scan the current map for special sprites
    -- 64 = player
    -- 80 = enemy
    -- 96 = mouse
    -- 21 = torch
    -- 12 = trap (blocked)
    -- 28 = trap (open)
    for x=0,15 do
        for y=0,15 do
            local mval = mget(x,y)
            if mval == 21 then
                
                local torch = entity:new({
                    x= x * 8,
                    y= y * 8,
                    sp=21,
                    anim={
                        idle={21,22}
                    }
                })
                add(entities, torch)
                
            end
            -- printh(mval, 'debug.txt')
        end
    end
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