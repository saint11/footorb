{
	init:(scene)=>
		@s = scene

	make_dungeon:()=>
		w = data.global.dungeon_size_x
		h = data.global.dungeon_size_y
		rw = data.global.room_size_x
		rh = data.global.room_size_y

		sucessful=false
		fail_count = 0
		while true
			@rooms = {}

			@builder = {x:0,y:0}
			@start_room = {
				x:lume.round(w/2), y:lume.round(h/2), style: "start",
				door_up:true, door_down:true, door_left:true, door_right:true
			}
			lume.push(@rooms, @start_room)
			sucessful,main_branch = @make_branch(lume.round(w/2), lume.round(h/2), 4, "main")
			if sucessful
				-- Level Exit
				main_branch[#main_branch].style = "exit"
				
				@rooms = lume.concat(@rooms, main_branch)
				
				branch = main_branch[lume.round(#main_branch/2)]
				
				sucessful, powerup_branch = @make_branch(branch.x, branch.y, 5, "powerup")
				if sucessful
					@rooms = lume.concat(@rooms, powerup_branch)
					break
			else
				fail_count +=1
				if fail_count>100
					print "Major failure in the dungeon generation"
					love.event.quit!
					break

		for i,room in ipairs(@rooms)
			@makeroom(room)

	makeroom: (room)=>
		w = data.global.room_size_x
		h = data.global.room_size_y
		x = room.x * w
		y = room.y * h
		door_w = data.global.door_size

		-- top wall
		@s\add(Block(x, y, w/2 - door_w/2, 16))
		@s\add(Block(x + w/2 + door_w/2, y, w/2 - door_w/2, 16))
		if room.door_up
			@s\add(Block(x + w/2 - door_w/2, y, door_w, 16))

		-- -- bottom wall
		@s\add(Block(x,y+h-16,w/2 - door_w/2,16))
		@s\add(Block(x + w/2 + door_w/2, y+h-16, w/2 - door_w/2, 16))
		if room.door_down
			@s\add(Block(x + w/2 - door_w/2, y+h-16, door_w, 16))

		-- -- left wall
		@s\add(Block(x,y+16,16,h/2 - door_w/2 - 16))
		@s\add(Block(x,y + h/2 + door_w/2,16,h/2 - door_w/2 - 16))
		if room.door_left
			@s\add(Block(x,y + h/2 - door_w/2,16,door_w))

		-- -- right wall
		@s\add(Block(x + w-16, y+16,16,h/2 - door_w/2 - 16))
		@s\add(Block(x + w-16, y + h/2 + door_w/2,16,h/2 - door_w/2 - 16))
		if room.door_right
			@s\add(Block(x + w-16,y + h/2 - door_w/2,16,door_w))

		-- Spawn objects
		if room.style == "start"
			@s.player = @s\add(Player((room.x + 0.5)*w, (room.y + 0.5)*h))
			@s.orb = @s\add(Orb((room.x + 0.5)*w, (room.y + 0.5)*h))
			@s.orb.following = @s.player
			@s\add(Goal((room.x + 0.25)*w, (room.y + 0.08)*h))
		elseif room.style == "exit"
			@s\add(Goal((room.x + 0.25)*w, (room.y + 0.08)*h))


	make_branch:( x, y, size, name )=>
		print("  building '".. name .. "' branch with " .. size .. " rooms")
		@builder.x = x
		@builder.y = y

		branch_size = 0
		current_branch = {}
		previous_room = @get_room_at(x,y)
		
		try = 0
		while true do
			direction = random_direction()
			nextX, nextY = @builder.x + direction.x, @builder.y + direction.y
			
			if @check_for_empty_room(nextX, nextY, current_branch)
				@builder.x = nextX
				@builder.y = nextY
				room = {
					x:nextX, y:nextY, style: name,
					door_up:true, door_down:true, door_left:true, door_right:true
				}

				-- Opening doors
				if (direction.x>0) then room.door_left=false
				if (direction.x<0) then room.door_right=false
				if (direction.y>0) then room.door_up=false
				if (direction.y<0) then room.door_down=false
				if previous_room~=nil then
					prev_direction = {}
					prev_direction.x = previous_room.x-room.x
					prev_direction.y = previous_room.y-room.y
					if (prev_direction.x>0) then previous_room.door_left=false
					if (prev_direction.x<0) then previous_room.door_right=false
					if (prev_direction.y>0) then previous_room.door_up=false
					if (prev_direction.y<0) then previous_room.door_down=false

				previous_room = room
				lume.push(current_branch, room)
			
				branch_size = branch_size + 1
				if branch_size>= size then

					print("  done!")
					return true, current_branch
			
			else
				try = try + 1
			if try>30 then return false

	get_room_at:(x,y)=>
		for i,r in ipairs(@rooms)
			if (r.x==x and r.y==y)
				return r
		return nil
	
	check_for_empty_room:(x, y, current_branch)=>
		if (x<0 or y<0 or x>=data.global.dungeon_size_x or y>=data.global.dungeon_size_y)
			return false
		for i,r in ipairs(current_branch)
			if (r.x==x and r.y==y)
				return false

		for i,r in ipairs(@rooms)
			if (r.x==x and r.y==y)
				return false
		
		return true
}