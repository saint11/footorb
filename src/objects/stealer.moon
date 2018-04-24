export class Stealer extends Actor
	new:(x,y)=>
		super(x,y)
		@speed = 30
		@collides_with = {"solid","door"}
		
		@dangerous = true

		@hp = 1
		@has_ball = false
		@has_ball_timer = 0

		@invulnerable=0

	update:(dt)=>
		super(dt)
		if @scene.orb.following != self
			
			move_x, move_y = normalize @scene.orb.x - @x, @scene.orb.y - @y
			@move(move_x*dt * @speed, move_y*dt * @speed)

			-- Got the orb!
			orb = @collide_with(@x,@y, "orb")
			if orb != nil and orb.immune==0
				@look_x, @look_y = 0, 0
				orb.following = self
				orb.speedX = 0
				orb.speedY = 0
				orb.rate = 0.75
		else
			@has_ball = true
			@has_ball_timer = math.min(@has_ball_timer + dt, 0.1)
			move_x, move_y = normalize @scene.player.x - @x, @scene.player.y - @y
			@move(-move_x*dt * @speed, -move_y*dt * @speed)
			@look_x, @look_y = -move_x, -move_y

		-- player = @collide_with(@x,@y, "player")
		-- if player != nil
		-- 	player\injure()

	draw:(x,y)=>
		if @has_ball
			lg.setColor(8,0.2,0,1)
		else
			lg.setColor(0.9,0.5,0,1)
		lg.rectangle("fill", x + @box.x, y+ @box.y, @box.w,@box.h)

	injure:()=>
		print "hit!"
		if @invulnerable==0
			slowdown(0.01)
			@invulnerable = 0.8
			@hp -= 1
			if @hp==0 then @remove_self()