
extends Sprite

var width
var height
var camera

func _ready():
	width = get_texture().get_width()
	height = get_texture().get_height()
	camera = get_node("../camera")
	set_process_input(true)
	
func _input(event):
	if((event.type==InputEvent.MOUSE_BUTTON)):
		if((event.button_index == 1) and event.is_pressed()): 
			var pos = camera.get_actual_pos(event.pos)
			if((pos.x >= get_pos().x )  and (pos.y >= get_pos().y )  and (pos.x <= get_pos().x + width ) and (pos.y <= get_pos().y + height) ):
				print ("Click Enemy")
				get_tree().set_input_as_handled()

