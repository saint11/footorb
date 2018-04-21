export class Goal extends Actor
	new:(x,y)=>
		super(x, y)
		@box= { x:-24, y:-8, w:48, h:16}
		@depth = -100
		@score = false

		@time = 0

	update:(dt)=>
		@time+=dt
		if @collide_with(@x,@y, "orb")
			@score=true
			
	draw:(rx, ry)=>
		if @score
			lg.setColor(lume.random(1), lume.random(1), lume.random(1), 1)
		else
			glow = (1+math.sin(@time))/2
			lg.setColor(glow*0.2,glow*0.2,glow*0.2, 1)
		lg.rectangle("fill", rx + @box.x, ry + @box.y, @box.w, @box.h)

			