export class GameScene extends Scene
	new: ()=>
		@entities = {}
		@entities_to_add = {}
		@entities_to_remove = {}
		@camera = {x:0, y:0, shake_intensity:0, shake_time:0}

		@generator = require("generator")
		@generator\init(self)
		@generator\make_dungeon!
		
	draw: ()=>
		shake_x = lume.random(-@camera.shake_intensity,@camera.shake_intensity) * math.min(@camera.shake_time,1)
		shake_y = lume.random(-@camera.shake_intensity,@camera.shake_intensity) * math.min(@camera.shake_time,1)
		@camera.x = lume.lerp(@camera.x, @player.room.x*data.global.room_size_x + data.global.room_size_x/2 - w_width/2, 0.02) + shake_x
		@camera.y = lume.lerp(@camera.y, @player.room.y*data.global.room_size_y, 0.02) + shake_y

		if (data.global.show_scene_name)
			lg.setFont(data.fonts.min4)
			lg.print "Game scene",10,10

		for i,e in ipairs(@entities)
			rx, ry = lume.round(e.x) - lume.round(@camera.x) + e.ox, lume.round(e.y) - lume.round(@camera.y) + e.oy
			e\draw(rx, ry)
			if debug_mode and e.debug_draw != nil
				e\debug_draw(rx, ry)
		@draw_ui!

	update: (dt)=>

		-- remove entities
		for i,e in ipairs(@entities_to_remove)
			lume.remove(@entities, e)

		-- add entities
		for i,e in ipairs(@entities_to_add)
			lume.push(@entities, e)

		@entities_to_add = {}
		@entities_to_remove = {}

		@entities = lume.sort(@entities, (a,b)-> return (a.y + a.depth) < (b.y + b.depth))

		-- run update loop
		for i,e in ipairs(@entities)
			e\update(dt)

		@camera.shake_time = math.max(@camera.shake_time-dt,0)

	keypressed: (key, scan, isrepeat)=>
		-- Pause
		if key=="p"
			changeSceneTo PauseScene(self)

		if key=="d"
			changeSceneTo DefeatScene()

	add: (e)=>
		lume.push(@entities_to_add, e)
		e.scene = self
		return e

	remove: (e)=>
		lume.push(@entities_to_remove, e)

	draw_ui: ()=>
		ui_x = 0
		ui_y = data.global.room_size_y
		lg.setColor(0.2,0.2,0.5,1)
		lg.rectangle("fill", ui_x, ui_y , w_width, w_height - data.global.room_size_y)

		mm_size = 4
		for i,room in ipairs(@generator.rooms)
			if (room.style=="start")
				lg.setColor(1,0.2,0.5,0.5)
			elseif (room.style=="exit")
				lg.setColor(0.2,1,0.5,0.5)
			else
				lg.setColor(0.5,0.5,0.8,0.5)
			lg.rectangle("fill",ui_x + 2 + room.x*(mm_size+1), ui_y + 2 + room.y*(mm_size+1), mm_size, mm_size)
				
		x, y = @player.room.x, @player.room.y
		lg.setColor(1,1,1,0.5)
		lg.rectangle("fill",ui_x + 2 + x*(mm_size+1), ui_y + 2 + y*(mm_size+1), mm_size, mm_size)

	camera_shake: (ammount, time)=>
		@camera.shake_intensity = math.max(@camera.shake_intensity, ammount)
		@camera.shake_time = math.max(@camera.shake_time, time)