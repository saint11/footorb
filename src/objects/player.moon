export class Player extends Actor 
	new: (x, y)=>
		super(x, y)
		@speed = 80
		@look_angle = 0
		@look_x, @look_y = 0, 0
		@box = { x:-5, y:-8, w:10, h:8 }
		@room = {0, 0}

    update: (dt)=>
    	super dt
    	lx, ly = 0, 0
		if lk.isDown("left")
			lx -= 1

		if lk.isDown("right")
			lx += 1

    	if lk.isDown("up")
			ly -= 1

		if lk.isDown("down")
			ly += 1
		
		-- if I moved
		if lx != 0 or ly != 0
			@look_angle = angleLerp(@look_angle, lume.angle(0,0,lx,ly), 5*dt)
			@move(lx*@speed*dt, ly*@speed*dt)

		@look_x, @look_y = lume.vector(@look_angle, 1)

		-- Kick the ball !!!
		if lk.isDown("space")
			if @scene.orb.following==self
				@scene.orb.following = nil
				@scene.orb.speedX = @look_x * 200
				@scene.orb.speedY = @look_y * 200
				@scene.orb.speedZ = 60

				@scene\camera_shake(2,0.2)

		@room = {
			x: math.floor(@x / data.global.room_size_x)
			y: math.floor(@y / data.global.room_size_y)
		}

	draw: (x, y)=>
		lg.setColor 0.2, 0.8, 0.5, 1
		lg.rectangle "fill", x - 8, y - 24, 16, 24

		lg.setColor 0.8, 0.8, 0.2, 0.5
		lg.circle "fill", x, y, 4

		lg.setColor 1, 0.2, 0.1, 0.8
		lg.circle "fill", x+@look_x * 16, y+@look_y*16, 2