
controls={
    init=function()
        print("♥ hello controls")
    end,
    update=function(player)
        
        player.vx = 0
        player.vy = 0
        
        if btn(➡️) then
            player.vx = 1
        elseif btn(⬅️) then
            player.vx = -1
        end

        if btn(⬇️) then
            player.vy = 1
        elseif btn(⬆️) then
            player.vy = -1
        end
    end
}