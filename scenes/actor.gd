extends Sprite

var map

var char
var coord


const movespeed = 100 #how many pixel per second does the sprite move
var goalpos #goalposition of the sprite
var direction #towards goalpos

func init(bodytexture,schar, scoord):
	char = schar;
	char.actor = self
	set_texture(bodytexture)
	coord = scoord


func _ready():

	map = get_node("/root/map")
	map.add_actor(self)
	goalpos = get_pos()

func _exit_tree():
	map.remove_actor(self)


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

var movepath = null

func move_along_path(path):
	if path != null:
		if path.size() <= char.actionpoints:
			move_to_coord(path[0])
			path.remove(0)
			movepath = path
		else:
			print ("Not enough actionpoints")
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


