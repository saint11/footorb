export class Block extends Actor
	new: (x, y, w, h, room_x, room_y)=>
		super(x,y)
		@room = {x: room_x, y:room_y}
		@box = {x:0, y:0, w:w,h:h}
		@tags = { solid:true }
		@fade = false

	draw: (x, y)=>
		lg.setColor white
		lg.rectangle("line", x, y, @box.w, @box.h)

export class Door extends Actor
	new: (x, y, w, h, room_x, room_y)=>
		super(x,y)
		@room = {x: room_x, y:room_y}
		@box = {x:0, y:0, w:w,h:h}
		@tags = { solid:false, door:true }
		@fade = false

	update: (dt)=>
		if @closed
			if @collide_with(@x, @y, "player")==nil
				@tags.solid = true
		else
			@tags.solid = false

	draw: (x, y)=>
		if @tags.solid
			lg.setColor white
			lg.rectangle("fill", x, y, @box.w, @box.h)

		lg.setColor 1,1,1,0.3
		lg.rectangle("fill", x, y, @box.w, @box.h)

	close_doors:(x, y)=>
		@closed = true

	open_doors:()=>
		@closed = false