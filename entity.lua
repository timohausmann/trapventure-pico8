entity = class:new({
    x = 0,
    y = 0,
    vx = 0,
    vy = 0,
    speed = 1,
    sp = 61,
    anim = {},
    animSpeed = 0.25,
    animCurr = nil,
    flipx = false,
    dead = false,

    update = function(self, dt)
        dt = 1 -- real dt janky AF

        if self.dead then
            self.vy *= 0.99;
            self.vy += 0.5;

			self.x += self.vx;
			self.y += self.vy;
        end

        local lastX = self.x
        local lastY = self.y
        
        local limitedVx, limitedVy = self:limitSpeed(self.vx, self.vy, 1)
        
        self.x = self.x + limitedVx * self.speed * dt
        self.y = self.y + limitedVy * self.speed * dt

        if not self.dead then
            -- obstacles collision
            if self:collide(0) then
                self.x = lastX
                self.y = lastY
            end

            -- trap collision
            if self:collide(1) then
                self:die()
            end

            -- stairs collision
            if self:collide(2) and not fading then
                nextMap()
            end
        end

        self.flipx = self.vx < 0
        
        -- determine animation
        self.animCurr = nil
        if self.dead then
            self.animCurr = self.anim.death
        elseif self.vx ~= 0 and self.anim.movex ~= nil then 
            self.animCurr = self.anim.movex
        elseif self.vy ~= 0 and self.anim.movey ~= nil then
            self.animCurr = self.anim.movey
        elseif self.anim.idle ~= nil then
            self.animCurr = self.anim.idle
        end

        local t = time()
        if self.animCurr then
            local animL = self.animCurr[2] - self.animCurr[1]
            self.sp = self.animCurr[1] + flr(t / self.animSpeed) % (animL + 1)
        end
    end,

    draw = function(self)
        spr(self.sp, self.x, self.y, 1, 1, self.flipx)
        print(flr(time() / self.animSpeed % 2))
    end,

    -- Function to limit the speed of a vector
    limitSpeed = function(self, x, y, maxSpeed)
        local length = sqrt(x^2 + y^2)
        if length > maxSpeed then
            local normalizedX, normalizedY = x / length, y / length
            return normalizedX * maxSpeed, normalizedY * maxSpeed
        else
            return x, y
        end
    end,

    collide = function(self, flag)

        local mapX, mapY = getMapOffset()
        
        local x1 = mapX + flr((self.x + 2) / 8) -- reduce x hitbox by 2 on each side
        local y1 = mapY + flr(self.y / 8)
        local x2 = mapX + flr((self.x + 5) / 8)
        local y2 = mapY + flr((self.y + 7) / 8)

        local a = fget(mget(x1, y1), flag)
        local b = fget(mget(x2, y1), flag)
        local c = fget(mget(x2, y2), flag)
        local d = fget(mget(x1, y2), flag)

        return a or b or c or d
    end,

    die = function(self)
        self.dead = true
        self.vy = -6
    end
})