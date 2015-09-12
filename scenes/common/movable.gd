#An actor is the graphical representation of a moving object or character
#it handles the GUI stuff so that the character can focus on gameplay mechanics


class Movable:
	extends Sprite
	var map = null
	var coord

	
	var movespeed = 100 #how many pixel per second does the sprite move
	var goalpos #goalposition of the sprite
	var direction #towards goalpos
	
	var movepath = null

	func _ready():
		map = get_node("/root/map")
		goalpos = get_pos()
		set_centered(false)

	func get_direction(start,goal): #returns the directionalvector from one point to another
		var diff = goal - start
		var direction = Vector2(0,0)
		if(diff.x != 0):
			direction.x = diff.x / abs(diff.x)
		if(diff.y != 0):
			direction.y = diff.y / abs(diff.y)
		return direction

	func move_to_coord(scoord):
		coord = scoord
		goalpos = map.map_to_world(scoord)
		direction = get_direction(get_pos(),goalpos)
		set_process(true)

	func move_along_path(path):
		if path != null and path.size() > 0:
			move_to_coord(path[0])
			path.remove(0)
			movepath = path

	func _process(delta):
		var newdirection = get_direction(get_pos(),goalpos)
		if(direction != -newdirection):
			if(direction != newdirection):
				direction = newdirection
			var tomove = delta * direction * movespeed
			set_pos(tomove + get_pos())
		else:
			set_pos(goalpos)
			if movepath != null and !movepath.empty():
				move_to_coord(movepath[0])
				movepath.remove(0)
			else :
				set_pos(goalpos)
				set_process(false)

class Projectile:
	extends Movable
	func _init(texture):
		set_texture(texture)

class Actor:
	extends Movable

	var char
	var highlight

	func _init(bodytexture,schar, scoord = null):
		char = schar;
		char.actor = self
		set_texture(bodytexture)
		coord = scoord

		highlight = Sprite.new()
		highlight.set_texture(load("res://gfx/dc-misc/cursor.png"))
		highlight.set_centered(false)
		highlight.hide()
		add_child(highlight)

	func _exit_tree():
		if map != null:
			map.remove_actor(self)

	func _draw():
		draw_string ( get_node("/root/global").defaultfont, Vector2(22,10), str(char.hp), Color(255,0,0))
		draw_string ( get_node("/root/global").defaultfont, Vector2(22,20), str(char.mp), Color(0,255,0))
		draw_string ( get_node("/root/global").defaultfont, Vector2(22,30), str(char.ap), Color(0,0,255))

	func move_along_path(path):
		if path != null && char.can_move(path.size()):
			char.mp -= path.size()
			update()
			.move_along_path(path)
			return true
		return false

	func melee_ability_move(target,path,ability):
		if path[path.size()-1] == target.coord:
			path.remove(path.size() - 1)
		else:
			print ("Target coord is not at the end of path")
		
		while not char.can_move(path.size()):
			path.remove(path.size() - 1)
		
		move_along_path(path)
		
		if ability.can_use(char) && map.line(target.coord,coord).size()==2:
			ability.use(char,target.char)
			print ("Used melee ability: ", ability.name)
		else:
			print ("Could not use melee ability: ", ability.name )

	func add_equip(equiptexture):
		var equipsprite = Sprite.new()
		equipsprite.set_texture(equiptexture)
		equipsprite.set_centered(false)
		add_child(equipsprite)
		print ("Equipspritepos: ", equipsprite.get_pos())
