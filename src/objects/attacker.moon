export class Attacker extends Actor
	new:(x,y)=>
		super(x,y)
		@speed = 30

	update:(dt)=>
		super(dt)

		move_x, move_y = normalize @scene.player.x - @x, @scene.player.y - @y
		@move(move_x*dt * @speed, move_y*dt * @speed)

		orb = @collide_with(@x,@y, "orb")
		if orb != nil and orb.following == nil
			orb.speedX = -orb.speedX
			orb.speedY = -orb.speedY
			@remove_self()

		player = @collide_with(@x,@y, "player")
		if player != nil
			player\injure()

	draw:(x,y)=>
		lg.setColor(1,0,0,1)
		lg.rectangle("fill", x + @box.x, y+ @box.y, @box.w,@box.h)