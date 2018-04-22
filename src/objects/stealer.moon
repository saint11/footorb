export class Stealer extends Actor
	new:(x,y)=>
		super(x,y)
		@speed = 30

	update:(dt)=>
		super(dt)
		if @scene.orb.following != self
			move_x, move_y = normalize @scene.orb.x - @x, @scene.orb.y - @y
			@move(move_x*dt * @speed, move_y*dt * @speed)

			orb = @collide_with(@x,@y, "orb")
			if orb != nil and orb.immune==0
				@look_x, @look_y = 0, 0
				orb.following = self
				orb.speedX = 0
				orb.speedY = 0
		else
			move_x, move_y = normalize @scene.player.x - @x, @scene.player.y - @y
			@move(-move_x*dt * @speed, -move_y*dt * @speed)
			@look_x, @look_y = -move_x, -move_y

		-- player = @collide_with(@x,@y, "player")
		-- if player != nil
		-- 	player\injure()

	draw:(x,y)=>
		lg.setColor(0.9,0.5,0,1)
		lg.rectangle("fill", x + @box.x, y+ @box.y, @box.w,@box.h)