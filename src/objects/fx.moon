export class FadeOut extends Entity
	new: (where_to,time)=>
		super(0,0)
		@where_to = where_to
		@time = time
		@t=0

	update:(dt)=>
		@t = math.min(@t + dt, @time)
		if @t==@time
			changeSceneTo @where_to

	post_draw:(x,y)=>
		lg.setColor(0,0,0,@t/@time)

		lg.rectangle("fill",0,0,w_width,w_height)