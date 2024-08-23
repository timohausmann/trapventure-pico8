
controls={
    init=function()
        print("♥ hello controls")
    end,
    update=function(player)
        
        if(player == nil) return
        if(player.dead) return
        
        player.vx = 0
        player.vy = 0
        
        if(fading) return

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

        if btnp(🅾️) or btnp(❎) then
            for t in all(traps) do
                t:toggle()
            end
        end
    end
}