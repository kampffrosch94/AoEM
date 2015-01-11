extends Sprite

var width
var height
var map
var camera


const movespeed = 100 #how many pixel per second does the sprite move
var goalpos #goalposition of the sprite
var direction #towards goalpos

func _ready():
	width = get_texture().get_width()
	height = get_texture().get_height()
	camera = get_node("../camera")
	map = get_node("/root/map")
	goalpos = get_pos()
	set_process_input(true)
	
func _input(event):
	if((event.type==InputEvent.MOUSE_BUTTON)):
		if((event.button_index == 1) and event.is_pressed()): 
			var pos = camera.get_actual_pos(event.pos)
			if((pos.x >= get_pos().x )  and (pos.y >= get_pos().y )  and (pos.x <= get_pos().x + width ) and (pos.y <= get_pos().y + height) ):
				print ("Click Actor")
				map.set_lastclickedactor(self)
				get_tree().set_input_as_handled()


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


func _process(delta):
	var newdirection = get_direction(get_pos(),goalpos)
	if(direction != -newdirection):
		if(direction != newdirection):
			direction = newdirection
		var tomove = delta * direction * movespeed
		set_pos(tomove + get_pos())
	else:
		set_pos(goalpos)
		set_process(false)

func _on_Button_pressed():
	var coord = Vector2(0,0)
	move_to_coord(coord)


func _on_Button_2_pressed():
	var coord = Vector2(0,5)
	goalpos = map.map_to_world(coord)
	set_pos(goalpos)
