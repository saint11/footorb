export getText=(globalKeyEntry)->
	lume.format(data.global[globalKeyEntry],data.global)

export isCloser=(x, y, x2, y2, distance)->
	lume.distance(x, y, x2, y2, true) < distance*distance

export shortAngleDist=(a0,a1)->
    max = math.pi*2
    da = (a1 - a0) % max
    return 2*da % max - da

export angleLerp=(a0,a1,t)->
    return a0 + shortAngleDist(a0,a1)*t

export intersects=(rect1, rect2)->
	return (rect1.x + rect1.w >= rect2.x and rect1.y + rect1.h >= rect2.y) and (rect1.y <= rect2.y + rect2.h and rect1.x <= rect2.x + rect2.w)


export random_direction=()->
  r = {}
  value=0
  if love.math.random()>0.5 then
    value=1
  else
    value=-1

  if love.math.random()>0.5 then
    r.x=value
    r.y=0
  else
    r.y=value
    r.x=0
  return r
