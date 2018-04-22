export class Attacker extends Actor
	new:(x,y)=>
		super(x,y)
		@max_speed = 50
		@speed = {x:0, y:0}
		@time = 0

		@hp = 2
		@invulnerable = 0
		@stunned = 0
		@collides_with = {"solid","door"}

		@dangerous = true
	update:(dt)=>
		super(dt)
		if @stunned==0
			if @scene.orb.following==@scene.player
				if @time>4
					-- charge player with accel
					move_x, move_y = normalize @scene.player.x - @x, @scene.player.y - @y
					@speed.x = clamp(@speed.x + move_x * 140 * dt, @max_speed)
					@speed.y = clamp(@speed.y + move_y * 140 * dt, @max_speed)

					@move(@speed.x * dt, @speed.y * dt)
				else
					move_x, move_y = normalize @scene.player.x - @x, @scene.player.y - @y
					@move(-move_x*dt * @max_speed*0.5, -move_y*dt * @max_speed*0.5)
			else
					move_x, move_y = normalize @scene.player.x - @x, @scene.player.y - @y
					@move(move_x*dt * @max_speed*1.5, move_y*dt * @max_speed*1.5)
		else
			move_x, move_y = normalize @scene.orb.x - @x, @scene.orb.y - @y
			@move(-move_x*dt * @max_speed*0.25, -move_y*dt * @max_speed*0.25)

		orb = @collide_with(@x,@y, "orb")
		if orb != nil and orb.following == nil
			orb.speedX = -orb.speedX
			orb.speedY = -orb.speedY
			@injure!

		player = @collide_with(@x,@y, "player")
		if player != nil
			player\injure(@x, @y)
			@stunned = 3
		
		@time += dt * lume.random(0.2,1.8)
		if @time>8 then @time=0
		@invulnerable = math.max(@invulnerable-dt, 0)
		@stunned = math.max(@stunned-dt, 0)

	draw:(x,y)=>
		lg.setColor(1,0,0,1)
		if @invulnerable>0
			f = math.floor(@invulnerable*30)%2
			lg.setColor(1-f,f,f,1)

		lg.rectangle("fill", x + @box.x, y+ @box.y, @box.w,@box.h)

	injure:()=>
		if @invulnerable==0
			@invulnerable = 0.8
			@hp -= 1
			if @hp==0 then @remove_self()