export class VictoryScene extends Scene
	new: ()=>
		@fade_time_max = 1
		@fade_time = @fade_time_max

	draw: ()=>
		lg.setColor white
		lg.setFont(data.fonts.extrude)

		lg.printf getText("victory_title"),0, 50, w_width/2, "center", 0, 2, 2

		lg.setFont(data.fonts.monocons)
		lg.printf getText("victory_description"),0, 100, w_width, "center"

		lg.setColor 0,0,0, @fade_time/@fade_time_max
		lg.rectangle "fill", 0, 0, w_width, w_height

	update: (dt)=>
		@fade_time = math.max(@fade_time - dt, 0)

	keypressed: (key, scan, isrepeat)=>
		if lume.any({"space","return","escape"}, (x)->x==key)
			changeSceneTo MainMenuScene()