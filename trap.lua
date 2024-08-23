trap = class:new({
    x = 0,
    y = 0,
    open = false,

    toggle = function(self)
        self.open = not self.open

        local mapX, mapY = getMapOffset()
        local nextSprite = self.open and sprites.trapOpen or sprites.trapClosed

        mset(mapX + self.x / 8, mapY + self.y / 8, nextSprite)

        sfx(6)
    end,
})