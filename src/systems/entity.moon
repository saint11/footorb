export class Entity 
	new: (x, y)=>
		@x = x
		@y = y

		@ox, @oy = 0, 0

		@tweens={}

    update: (dt)=>
    	for i,t in lume.ripairs(@tweens)
    		if t\update(dt)
    			@tweens[i] =nil

	add_tween:(...)=>
		lume.push(@tweens,tween.new(...))

	removeSelf:()=>
		@scene.remove(self)