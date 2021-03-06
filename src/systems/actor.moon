export class Actor extends Entity
	new: (x, y)=>
		super(x, y)
		@dx, @dy = 0, 0
		@box = {x:0,y:0,w:16,h:16}
		@collides_with = {"solid"}
		@room = {
			x: math.floor(@x / data.global.room_size_x)
			y: math.floor(@y / data.global.room_size_y)
		}
		
		@active = true
		@fade = true

	collide_with:(x, y, tags)=>
		if type(tags) != "table"
			tags = {tags}
		for k,o in pairs(@scene.entities)
			if o!=self and o.tags!=nil and lume.any(tags,(x)->return o.tags[x]==true) and o.active
				if intersects(
					{x: x + @box.x, y: y + @box.y, w: @box.w, h: @box.h},
					{x: o.x + o.box.x, y: o.y + o.box.y, w: o.box.w, h: o.box.h})
					return o
		return nil

	move:(x,y)=>
		@dx = @dx + x
		@dy = @dy + y

		bufferX = math.abs(@dx)
		bufferY = math.abs(@dy)
		signX = lume.sign(@dx)
		signY = lume.sign(@dy)

		while bufferX>1 do
			other = @collide_with(@x+signX,@y, @collides_with)
			if other!=nil then
				bufferX=0
				if @on_collide~=nil then @on_collide(other)
				if @on_collidedX~=nil
					@on_collidedX(self)
				else
					@speedX = 0
			else
				bufferX = bufferX - 1
				@x = @x + signX

		while bufferY>1 do
			other = @collide_with(@x,@y+signY,@collides_with)
			if other~=nil then
				bufferY=0
				if @on_collide~=nil then @on_collide(other)
				if @on_collidedY~=nil
					@on_collidedY(self)
				else
					@speedY = 0
			else
				bufferY = bufferY - 1
				@y = @y + signY
			
		@dx = bufferX*signX
		@dy = bufferY*signY

	debug_draw:(x, y)=>
		lg.setColor 1, 0, 0, 1
		lg.rectangle("line", x + @box.x, y + @box.y, @box.w, @box.h)

		lg.setFont(data.fonts.min5)
		lg.setColor 1, 1, 1, 1
		love.graphics.print(@room.x..","..@room.y, x, y + 8)