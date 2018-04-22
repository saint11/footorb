export class Block extends Actor
	new: (x, y, w, h, room)=>
		super(x,y, room)
		@box = {x:0, y:0, w:w,h:h}
		@tags = { solid:true }
		@fade = false
	draw: (x, y)=>
		lg.setColor white
		lg.rectangle("line", x, y, @box.w, @box.h)