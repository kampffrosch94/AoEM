#This class (TileMap) is the mainscene for a fight
#It handles user input on the and graphical representation of the map,
#aswell as the actors.
#
#It´s subclass Pathfinder handles pathfinding (with A*) 

extends TileMap

var camera
var actionbar

var blockingtiles

var actors = null
var active_actor = null


var pf #pathfinder

var highlighter = null

var abilityconfirm = false
var abilitytoconfirm = null
var abilitylocation = null

func _ready():
	#initialize
	blockingtiles = [-1,1]
	camera = get_node("camera")
	actionbar = get_node("camera/actionbar")
	highlighter = get_node("highlighter")
	set_process_unhandled_input(true)
	
	pf = Pathfinder.new(20,20,self)


	#random tests
	var start = Vector2(5,5)
	var end = Vector2(1,3)
	print("line of sight:")
	print(line_of_sight(start,end))


	print("Cellsize: ", get_cell_size())
	
	print("End Test")
	#random tests end


	#create Actors
	var charscript = load("res://scenes/autoload/character.gd")
	
	var attack = charscript.Ability.new("regular Attack",load("res://gfx/spells/earth/maxwells_silver_hammer.png"),1)
	var attackeffectscaling = charscript.Scaling.new()
	attackeffectscaling.dmgscaling = 1
	var attackeffect = charscript.Effect.new(0,attackeffectscaling)
	attack.add_effect(attackeffect)
	
	var flame = charscript.Ability.new("Flame",load("res://gfx/spells/fire/flame_tongue.png"),30)
	flame.add_effect(attackeffect)
	var heal = charscript.Ability.new("Heal",load("res://gfx/spells/necromancy/regeneration.png"),2)

	var char  = charscript.Character.new(10,2,0,get_node("/root/global"))
	char.add_ability(attack)
	char.add_ability(flame)
	var texture = load("res://gfx/player/base/human_m.png")
	var act = createActor(texture,char, 20,10)
	act.add_equip(load("res://gfx/sword.png"))
	
	var char  = charscript.Character.new(10,2,0,get_node("/root/global"))
	char.add_ability(attack)
	char.add_ability(heal)
	var texture = load("res://gfx/player/base/human_m.png")
	createActor(texture,char, 1,2)
	
	var char  = charscript.Character.new(4,1,1,get_node("/root/global"))
	char.add_ability(attack)
	var texture = load("res://gfx/dc-mon/siren.png")
	createActor(texture,char, 3,2)
	
	var char  = charscript.Character.new(4,1,1,get_node("/root/global"))
	char.add_ability(attack)
	var texture = load("res://gfx/dc-mon/siren.png")
	createActor(texture,char, 3,3)





func createActor(texture, char, x,y):
	var pos = Vector2(x,y)
	var apc = load("res://scenes/movable.gd").Actor.new(texture,char, pos)
	
	#apc.init(texture,char, pos)
	apc.set_pos(map_to_world(pos))
	add_child(apc)
	return apc

func add_actor(actor):
	if actors == null:
		actors = [actor]
	else:
		actors.append(actor)

func remove_actor(actor):
	actors.erase(actor)

func change_focus(actor):
	if active_actor != null:
		active_actor.highlight.hide()
	if actor != null:
		actionbar.load_abilities(actor.char)
		actor.highlight.show()
	active_actor = actor

func findactoratcoord(pos):
	for actor in actors :
		var actorpos = world_to_map(actor.get_pos())
		if pos == actorpos:
			return actor
	return null

func _unhandled_input(event):
	if event.type==InputEvent.MOUSE_BUTTON:
		if (event.button_index == 1) and event.is_pressed():
			var pos = world_to_map(camera.get_actual_pos(event.pos))
			var foundactor = findactoratcoord(pos)
			if foundactor != null:
				clickactor(foundactor)
			else:
				clicktile(pos)

func clickactor(actor):
	if actor.char.is_pc():
		print ("Clicked PC")
		change_focus(actor)
	else:
		print ("Clicked Enemy")
		if active_actor != null:
			var activeability = active_actor.char.abilities[actionbar.get_selected()]
			print("current ability range: ", activeability.maxrange)
			if activeability.maxrange == 1: #melee
				var path = pf.findpath(active_actor.coord, actor.coord)
				if(path != null):
					active_actor.melee_ability_move(actor,path,activeability)
					change_focus(null)
			elif activeability.maxrange > 1: #ranged
				if abilityconfirm:
					abilityconfirm = false
					highlighter.reset()
					var activeability = active_actor.char.abilities[actionbar.get_selected()]
					if abilitytoconfirm == activeability && abilitylocation == actor.coord:
						activeability.use(active_actor.char,actor.char)
				elif activeability.can_use(active_actor.char):
					var line = line_to(active_actor.coord,actor.coord)
					if line_of_sight(active_actor.coord,actor.coord) && line.size() <= activeability.maxrange:
						abilityconfirm = true
						abilitytoconfirm = activeability
						abilitylocation = actor.coord
						highlighter.add_cells(line)
						highlighter.update()


func clicktile(pos):
	print ("Click Tile: ",pos, " Blocking?:", is_cell_blocking(pos))
	print ("active_actor: ", active_actor)
	if (active_actor != null) and (!is_cell_blocking(pos)):
		print("Move Actor of PC")
		var start = active_actor.coord
		
		var path = pf.findpath(start,pos)
		if path != null:
			active_actor.move_along_path(path)

func _on_endturnbutton_pressed():
	print("End Turn (player)")
	if actors != null and actors.size() > 0:
		for actor in actors:
			if actor.char.is_pc():
				actor.char.end_turn()
				actor.update()
	enemy_turn()

func enemy_turn():
	for actor in actors:
		if not actor.char.is_pc():
			if actor.char.can_act():
				enemy_act(actor)
	
	for actor in actors:
		if not actor.char.is_pc():
			actor.char.end_turn()
			actor.update()

func enemy_act(enemy):
	var playeractors = {}
	for actor in actors:
		if actor.char.is_pc():
			var path = pf.findpath(enemy.coord,actor.coord)
			if path != null:
				playeractors[actor] = path
	
	var nearestpa= null
	for pa in playeractors:
		if nearestpa == null:
			nearestpa = pa
		if playeractors[pa].size() < playeractors[nearestpa].size():
			nearestpa = pa
	
	if nearestpa != null:
		enemy.melee_ability_move(nearestpa, playeractors[nearestpa],enemy.char.abilities[0])

func is_cell_blocking(pos):
	if (  blockingtiles.find( get_cell(pos.x,pos.y) )  != -1 ):
		return true
	elif(actors != null):
		var actorposis = []
		for actor in actors:
			actorposis.append(actor.coord)
		if pos in actorposis :
			return true
	return false

func is_cell_transparent(pos):
	if (blockingtiles.find( get_cell(pos.x,pos.y) )  == -1 ):
		return true
	else:
		return false

func line(start, end):
	var vec = end - start
	if abs(vec.x)  >= abs(vec.y) :
		vec.y = abs(vec.y / vec.x ) * sign(vec.y)
		vec.x = sign(vec.x)
	else:
		vec.x = abs(vec.x / vec.y) * sign(vec.x)
		vec.y = sign(vec.y)
	
	var line = [start]
	var currentpos = start
	
	while not end in line :
		currentpos += vec
		line.append(Vector2(round(currentpos.x),round(currentpos.y)))
	
	return line

func line_between(start,end):
	var line = line(start,end)
	line.remove(line.size() - 1)
	line.remove(0)
	return line

func line_to(start,end):
	var line = line(start,end)
	line.remove(0)
	return line

func line_of_sight(start,end):
	var line = line_between(start,end)
	for pos in line:
		if not is_cell_transparent(pos):
			return false
	return true
	

class Pathfinder:
	class Tile:
		var pos = Vector2()
		var H # estimate of pathcost to goal
		var G # pathcost of already traveled path
		var F # G + H
		var cost
		var blocked 
		func _init(startpos, b = false):
			pos = startpos
			blocked = b
			G = 9999999999999
			F = G 
			cost = 1
		
	
	var tiles #dict of all the tiles, key is pos
	var width
	var height
	var map
	
	func _init(width, height, smap):
		map = smap
		self.width = width
		self.height = height
		tiles = {}
		for w in range(-width,width + 1):
			for h in range(-height,height + 1):
				var pos = Vector2(w,h)
				var newtile = Tile.new(pos,map.is_cell_blocking(pos))
				tiles[pos] = newtile
	
	func update_blocking():
		for w in range(-width,width + 1):
			for h in range(-height,height + 1):
				var pos = Vector2(w,h)
				tiles[pos].blocked = map.is_cell_blocking(pos)
	
	
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
	
		update_blocking()
		
		var start = tiles[startpos]
		var goal = tiles[goalpos]
		var came_from = {}
		var open = [start]
		var closed = []
		
		start.H = distance(startpos,goalpos)
		start.G = 0
		start.F = start.G + start.H
		
		start.blocked = false #the moving guy shouldnt block himself
		
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
				var tentative_G = current.G + current.cost
				
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
		
		
		neighbors.append( get_tile(middle.pos + Vector2(-1,0))) 
		neighbors.append( get_tile(middle.pos + Vector2(1,0))) 
		neighbors.append( get_tile(middle.pos + Vector2(0,1))) 
		neighbors.append( get_tile(middle.pos + Vector2(0,-1))) 
		neighbors.append( get_tile(middle.pos + Vector2(-1,1))) 
		neighbors.append( get_tile(middle.pos + Vector2(1,1))) 
		neighbors.append( get_tile(middle.pos + Vector2(1,-1))) 
		neighbors.append( get_tile(middle.pos + Vector2(-1,-1))) 
		
		while neighbors.find(null) != -1:
			neighbors.erase(null)
		return neighbors
		

	func reconstructpath(current,came_from):
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
	



