export class Orb extends Actor 
	new: (x, y)=>
		super(x, y)

		@z = 0
		@scale = 1

		@speedZ = -50
		@speedX = 0
		@speedY = 0

		@following = nil
		@bounce_cooldown  = 0
		
		@box = {x:-4,y:-4,w:8,h:8}
		@tags = {orb:true}
		@fade=false

		@hit_goal = false


    update: (dt)=>
    	super dt

    	@bounce_cooldown = math.max(0, @bounce_cooldown - dt)
		@speedZ -= dt * 150
		@z = math.max(0,@z + @speedZ * dt)
		if not @hit_goal
			-- Bounce on the groung
			if @z==0
				@speedZ = -@speedZ * 0.8
				@speedX *= 0.5
				@speedY *= 0.5
				if math.abs(@speedZ)<=0.5
					@speedZ = 0

			-- Follow the player
			if @following != nil
				target_x = @following.x + @following.look_x * 24
				target_y = @following.y + @following.look_y * 24

				if not isCloser(@x, @y, target_x, target_y, 8) and @bounce_cooldown==0 and @z==0
					@speedZ = -60
					@bounce_cooldown=2

				mx = 0
				if math.abs(target_x - @x) > 2
					mx = lume.sign(target_x - @x) * math.min(math.abs(target_x - @x)*15, 200)
				my = 0
				if math.abs(target_y - @y) > 2
					my = lume.sign(target_y - @y) * math.min(math.abs(target_y - @y)*15, 200)

				@move(mx * dt, my * dt)

			-- Move around
			else
				@move(@speedX * dt, @speedY * dt)

				-- is the player around
				if isCloser(@x, @y, @scene.player.x, @scene.player.y, 10) and @bounce_cooldown==0
					@following = @scene.player
					@bounce_cooldown=2
	draw: (x, y)=>
		lg.setColor .2,.2,.2,.5
		lg.circle "fill", x, y, 5 * @scale

		lg.setColor white
		lg.circle "fill", x, y - @z, 5 * @scale

	on_collidedX:()=>
		@speedX = -@speedX
		if @following == nil
			@scene\camera_shake(1,0.2)


	on_collidedY:()=>
		@speedY = -@speedY
		if @following == nil
			@scene\camera_shake(1,0.2)

	on_hit_goal:()=>
		if not @hit_goal
			@scene\camera_shake(2.5,1)
			@hit_goal = true
			@add_tween(1, self, {scale: 0}, "inBack")