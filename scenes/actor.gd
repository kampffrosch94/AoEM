extends Sprite

var map
var camera
var char

const movespeed = 100 #how many pixel per second does the sprite move
var goalpos #goalposition of the sprite
var direction #towards goalpos

func _ready():
	var characterFactoryNode = get_node("/root/character")
	char =  characterFactoryNode.Playercharacter.new()
	camera = get_node("../camera")
	map = get_node("/root/map")
	map.add_actor(self)
	goalpos = get_pos()


func on_click():
	if(char.is_pc()):
		print ("Click PC")
		map.set_lastclickedpc(self)
	else:
		print ("Click Enemy")
	




func get_direction(start,goal): #returns the directionalvector from one point to another
	var diff = goal - start
	var direction = Vector2(0,0)
	if(diff.x != 0):
		direction.x = diff.x / abs(diff.x)
	if(diff.y != 0):
		direction.y = diff.y / abs(diff.y)
	return direction

func move_to_coord(coord):
	goalpos = map.map_to_world(coord)
	direction = get_direction(get_pos(),goalpos)
	set_process(true)

var movepath = null

func move_along_path(path):
	if path != null:
		move_to_coord(path[0])
		path.remove(0)
		movepath = path
	else:
		print ("Path is null")
	


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

func _on_Button_pressed():
	var coord = Vector2(0,0)
	move_to_coord(coord)


func _on_Button_2_pressed():
	var coord = Vector2(0,5)
	goalpos = map.map_to_world(coord)
	set_pos(goalpos)


