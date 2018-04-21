export class Entity 
	new: (x, y)=>
		@x = x
		@y = y

		@ox, @oy = 0, 0

    update: (dt)=>

	draw: ()=>

	removeSelf:()=>
		@scene.remove(self)