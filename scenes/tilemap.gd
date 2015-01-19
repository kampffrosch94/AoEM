
extends TileMap

var camera
var blockingtiles

var actors = null
var lastclickedactor = null

var pf

func _ready():
	blockingtiles = [-1,1]
	camera = get_node("camera")
	set_process_input(true)

	#tests for pathfinder
	print("Beginn Pathfinder tests")
	pf = Pathfinder.new(20,20,self)
	


#	path = pf.findpath(start, goal)
#	
#	var start = Vector2(0,0)
#	var goal = Vector2(3,7)
#	pf.print_all_tiles()
#	if path == null:
#		print ("Path is null")
#	else:
#		print ("Pathstart, from: ", start ," to: ", goal )
#		for part in path:
#			print(part, "  Blocked?: ", is_cell_blocking(part))
#		print ("Pathend, length: ", path.size() )
	




func add_actor(actor):
	if actors == null:
		actors = [actor]
	else:
		actors.append(actor)

func is_cell_blocking(pos):
	return (  blockingtiles.find( get_cell(pos.x,pos.y) )  != -1 )


func set_lastclickedactor(actor):
	lastclickedactor = actor

func _input(event):
	if event.type==InputEvent.MOUSE_BUTTON:
		if (event.button_index == 1) and event.is_pressed():
			var pos = world_to_map(camera.get_actual_pos(event.pos))
			var foundactor = null
			for actor in actors :
				var actorpos = world_to_map(actor.get_pos())
				print("Actorpos: ",actorpos)
				if pos == actorpos:
					foundactor = actor 
					break
			if foundactor != null:
				foundactor.on_click()
			else:
				print ("Click Tile: ",pos, " Blocking?:", is_cell_blocking(pos))
				print ("lastclickedactor: ", lastclickedactor)
				if (lastclickedactor != null) and (!is_cell_blocking(pos)):
					print("Move Actor")
					var path = pf.findpath(world_to_map(lastclickedactor.get_pos()),pos)
					lastclickedactor.move_along_path(path)
					lastclickedactor = null


class Pathfinder:
	class Tile:
		var pos = Vector2()
		var H # estimate of pathcost to goal
		var G # pathcost of already traveled path
		var F # G + H
		var blocked 
		func _init(startpos, b = false):
			pos = startpos
			blocked = b
			G = 9999999999999
			F = G 
	
	var tiles #dict of all the tiles, key is pos
	var width
	var height
	
	func _init(width, height, map):
		self.width = width
		self.height = height
		tiles = {}
		for w in range(-width,width + 1):
			for h in range(-height,height + 1):
				var pos = Vector2(w,h)
				var newtile = Tile.new(pos,map.is_cell_blocking(pos))
				tiles[pos] = newtile
	
	func print_all_tiles():
		for w in range(-width,width + 1):
			for h in range(-height,height + 1):
				var pos = Vector2(w,h)
				print("Pos: " , tiles[pos].pos , " Blocked: ", tiles[pos].blocked)
	
	
	func distance(a,b): #walking distance between two tiles without obstacles
		#walking is also possible diagonally
		var dx = abs(a.x - b.x)
		var dy = abs(a.y - b.y)
		return abs(dx - dy)
	
	
	
	func findpath(startpos,goalpos):
		var start = tiles[startpos]
		var goal = tiles[goalpos]
		var came_from = {}
		var open = [start]
		var closed = []
		
		start.H = distance(startpos,goalpos)
		start.G = 0
		start.F = start.G + start.H
		
		while !open.empty():
			var current = open[0]
			for tile in open:
				if tile.F < current.F:
					current = tile
			
			if current == goal:
				return reconstructpath(goal,came_from)
			
			open.erase(current)
			closed.append(current)
			
			if current.blocked:
				continue
			
			for neighbor in get_neighbors(current):
				if neighbor in closed:
					continue
				var tentative_G = current.G + 1
				
				if (not neighbor in open) or (neighbor.G > tentative_G) :
					came_from[neighbor.pos] = current.pos
					neighbor.G = tentative_G
					neighbor.H = distance(neighbor.pos,goal.pos)
					neighbor.F = neighbor.G + neighbor.H
					if (not neighbor in open):
						open.append(neighbor)
		return null
	
	func get_tile(pos):
		if (pos.x <= width and pos.x >= -width) and (pos.y >= -height and pos.y <= height) : 
			return tiles[pos]
		else:
			print ("Return null Pos :" , pos)
			return null
	
	func get_neighbors(middle):
		var neighbors = []
		
		
		for i in range(-1,2): # -1 and 0 and 1
			for e in range(-1,2):
				if not (i == 0 and e == 0):
					neighbors.append( get_tile(middle.pos + Vector2(i,e))) 
		
		while neighbors.find(null) != -1:
			neighbors.erase(null)
		return neighbors
		

	func reconstructpath(current,came_from):
		print ("Path is getting reconstructed")
		var path = []
		while(current.pos in came_from.keys()):
			path.append(current.pos)
			var nextpos = came_from[current.pos]
			current = tiles[nextpos]
		return reversearray(path)
	
	func reversearray(array):
		var reverse = []
		for i in range(array.size()):
			reverse.append(array[array.size() - 1 - i])
		return reverse
	
