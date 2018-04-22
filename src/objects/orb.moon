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

		@shooting = false
		@evil = false
		@immune = 0
		
		@rate = 1
		@respawn = 5

    update: (dt)=>
    	super dt

    	@bounce_cooldown = math.max(0, @bounce_cooldown - dt)
    	@immune = math.max(0, @immune - dt)
		@speedZ -= dt * 150
		@z = math.max(0,@z + @speedZ * dt)
		if not @hit_goal
			-- Bounce on the ground
			if @z==0
				@speedZ = -@speedZ * 0.8
				@speedX *= 0.5
				@speedY *= 0.5
				@evil = false
				@shooting = false
				if math.abs(@speedZ)<=0.5
					@speedZ = 0

			-- Follow the player
			if @following != nil
				target_x = @following.x + @following.look_x * 24
				target_y = @following.y + @following.look_y * 24

				mx = 0
				if math.abs(target_x - @x) > 2
					mx = lume.sign(target_x - @x) * math.min(math.abs(target_x - @x)*15, 200)
				my = 0
				if math.abs(target_y - @y) > 2
					my = lume.sign(target_y - @y) * math.min(math.abs(target_y - @y)*15, 200)

				@move(mx * dt * @rate, my * dt * @rate)

				if not isCloser(@x, @y, target_x, target_y, 8)
					if not isCloser(@x, @y, target_x, target_y, 32)
						@following=nil
					if @bounce_cooldown==0 and @z==0
						@speedZ = -60
						@bounce_cooldown=2

			-- Move around
			else
				@move(@speedX * dt, @speedY * dt)

				if math.abs(@speedX)<=0.1 and math.abs(@speedY)<=0.1
					@respawn = math.max(@respawn-dt, 0)
				if @respawn == 0
					print "Orb respawned!"
					@respawn = 5
					@speedX, @speedY = 0, 0
					@x, @y = (@scene.player.room.x + 0.5) * data.global.room_size_x, (@scene.player.room.y + 0.5) * data.global.room_size_y

				-- if is evil
				if @evil
					player = @collide_with(@x,@y, "player")
					if player != nil
						player\injure()
						@evil = false

				-- is the player around
				if isCloser(@x, @y, @scene.player.x, @scene.player.y, 14) and @bounce_cooldown==0
					@rate = 1
					@following = @scene.player
					@collides_with = {"solid"}
					@bounce_cooldown=2
	draw: (x, y)=>
		lg.setColor .2,.2,.2,.5
		lg.circle "fill", x, y, 5 * @scale

		if @evil
			lg.setColor 1,0,0,1
		else
			lg.setColor white

		if @immune>0
			lg.setColor 1, 1, math.floor(time*200)%2, 1

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

	kick:(sx, sy)=>
		@shooting = true
		@following = nil
		@speedX = sx
		@speedY = sy
		@speedZ = 60
		@z = 1
		@collides_with = {"solid", "door"}
		@scene\camera_shake(2,0.2)
