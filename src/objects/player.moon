export class Player extends Actor 
	new: (x, y)=>
		super(x, y)
		@speed = 80
		@look_angle = 0
		@look_x, @look_y = 0, 0
		@box = { x:-6, y:-10, w:12, h:10 }
		
		@last_room = {}
		@have_kicked = false

		@tags = {player: true}

		@dash_timer=0
		@dash_to = { x:0, y:0 }

		@hp = 4
		@hit_timer=0
		@hit_to = { x:0, y:0}
		@invulnerable=0

	start:()=>
		@scene.camera.x = @room.x*data.global.room_size_x + data.global.room_size_x/2 - w_width/2
		@scene.camera.y = @room.y*data.global.room_size_y

	update: (dt)=>
		super dt

		lx, ly, kicked = @update_controls()

		-- Dashing though!
		if @hit_timer>0
			sx, sy = @hit_to.x*@speed, @hit_to.y*@speed
			@move(-sx*dt, -sy*dt)

			@hit_timer = math.max(@hit_timer-dt, 0)

		elseif @dash_timer>0
			sx, sy = @dash_to.x*@speed*@dash_timer*0.55, @dash_to.y*@speed*@dash_timer*0.55
			@move(sx*sx*dt*lume.sign(sx), sy*sy*dt*lume.sign(sy))
			@dash_timer = math.max(@dash_timer-dt, 0)

			-- Steal the ball!
			orb = @collide_with(@x,@y, "orb")
			if orb != nil and not orb.evil
				if orb.following != nil and orb.following !=self
					print orb.following.__class.__name
					orb.following\injure!

				orb.rate = 1
				orb.collides_with = {"solid"}
				orb.following=self
				orb.immune = 1.5
		else
			-- if I moved
			if lx != 0 or ly != 0
				@look_angle = angleLerp(@look_angle, lume.angle(0,0,lx,ly), 5*dt)
				@move(lx*@speed*dt, ly*@speed*dt)

			@look_x, @look_y = lume.vector(@look_angle, 1)

			-- Kick the ball !!!
			if kicked and not @have_kicked
				if @scene.orb.following==self
					@scene.orb\kick(@look_x * 200,@look_y * 200)

				elseif (lx != 0 or ly != 0) and @dash_timer == -0.5
					@dash_to = { x:lx, y:ly }
					@dash_timer = 0.5
			else
				@dash_timer = math.max(@dash_timer-dt, -0.5)

		@room.x = math.floor(@x / data.global.room_size_x)
		@room.y = math.floor(@y / data.global.room_size_y)
		if @room.x != @last_room.x or @room.y != @last_room.y
			print "Changed Rooms! (Now in " .. @room.x .. "," .. @room.y .. ")"
			@last_room.x = @room.x
			@last_room.y = @room.y
			@scene\toggle_active_room(@room.x,@room.y)

		@invulnerable = math.max(@invulnerable-dt,0)
		@have_kicked = kicked

	update_controls:()=>
		lx, ly = 0, 0
		kicked = false
		if @hit_timer == 0
			if lk.isDown("left")
				lx -= 1

			if lk.isDown("right")
				lx += 1

	    	if lk.isDown("up")
				ly -= 1

			if lk.isDown("down")
				ly += 1

			kicked = lk.isDown("space")
		lx, ly = normalize(lx, ly)
		return lx, ly, kicked

	injure: (x, y)=>
		if @invulnerable==0 and @dash_timer<=-0.1
			slowdown(0.01)

			@scene\camera_shake(2,1)
			@invulnerable = 1.5
			@hit_timer = 0.7
			@hit_to.x, @hit_to.y = normalize x-@x, y-@y
			
			@hp -= 1
			if @hp==0
				@scene\fade_to(DefeatScene(),2)

	draw: (x, y)=>
		lg.setColor 0.2, 0.8, 0.5, 1
		if @invulnerable>0
			f = math.floor(@invulnerable*30)%2
			lg.setColor(1-f,0.8,0.5,1)

		w, h = 16*(1+math.max(@dash_timer,0)*0.5), 24*(1-math.max(@dash_timer,0)*0.5)
		lg.rectangle "fill", x - w/2, y - h, w, h

		lg.setColor 0.8, 0.8, 0.2, 0.5
		lg.circle "fill", x, y, 4

		lg.setColor 1, 0.2, 0.1, 0.8
		lg.circle "fill", x+@look_x * 16, y+@look_y*16, 2