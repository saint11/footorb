export class Ghoulie extends Actor
	new:(x,y, goal)=>
		super(x,y)
		@goal = goal
		@speed = 20
		@box = {x:-10, y:-5, w:20, h:10}
		@time = 0

		@charge = 0
		@charge_max = 1

	update:(dt)=>
		super(dt)
		@time += dt

		move_angle = lume.angle(@goal.x, @goal.y, @scene.orb.x, @scene.orb.y)
		move_to_x, move_to_y = lume.vector(move_angle, 32)
		move_to_x *= 2
		move_to_x += @goal.x
		move_to_y += @goal.y + 8

		move_x = lume.sign(move_to_x - @x)
		move_y = lume.sign(move_to_y - @y)
		if math.abs(move_x)<0.5 then move_x=0
		if math.abs(move_y)<0.5 then move_y=0

		@move(move_x*dt * @speed, move_y*dt * @speed)

		orb = @collide_with(@x,@y, "orb")
		if orb != nil and orb.following == nil and not orb.evil
			orb.speedX = 0
			orb.speedY = 0
			@charge += dt
			if @charge>@charge_max
				@charge = 0
				sx, sy = normalize(@scene.player.x - @x, @scene.player.y - @y)
				orb.evil = true
				orb\kick(sx*350, sy*350)

		player = @collide_with(@x,@y, "player")
		if player != nil
			player\injure()

	draw:(x,y)=>
		lg.setColor(1,1,0,1)
		lg.rectangle("fill", x + @box.x, y+ @box.y, @box.w,@box.h)

	debug_draw:(x,y)=>
		super(x,y)
		move_angle = lume.angle(@goal.x, @goal.y, @scene.orb.x, @scene.orb.y)
		move_to_x, move_to_y = lume.vector(move_angle, 32)
		move_to_x *= 2
		move_to_x += @goal.x
		move_to_y += @goal.y + 8
		move_x = move_to_x - @x
		move_y = move_to_y - @y

		love.graphics.circle("fill", @goal.x, @goal.y, 5)
		love.graphics.line(@goal.x - @x + x,@goal.y- @y +y, move_x + x, move_y + y)