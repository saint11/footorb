export class Actor extends Entity
	new: (x, y, room)=>
		super(x, y)
		@dx, @dy = 0, 0
		@box = {x:0,y:0,w:16,h:16}
		@room = room

		@depth = 0

		@active = true

	collide:(x,y,tag)=>
		return @collide_with(x,y,tag)

	collide_with:(x, y, tag)=>
		for k,o in pairs(@scene.entities)
			if o!=self and o.tags!=nil and o.tags[tag]==true and o.active
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
			other = @collide_with(@x+signX,@y,"solid")
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
			other = @collide_with(@x,@y+signY,"solid")
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