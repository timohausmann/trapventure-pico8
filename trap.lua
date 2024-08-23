trap = class:new({
    x = 0,
    y = 0,
    open = false,

    toggle = function(self)
        self.open = not self.open

        if(self.open) then
            mset(self.x / 8, self.y / 8, sprites.trapOpen)
        else 
            mset(self.x / 8, self.y / 8, sprites.trapClosed)
        end
    end,
})