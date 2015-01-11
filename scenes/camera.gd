extends Camera2D

var move = null
var firstpress = true
var origpos

func _ready():
	make_current()
	set_process(true)


func _process(delta):
	if(Input.is_mouse_button_pressed(3)):
		get_tree().set_input_as_handled()
		if(firstpress):
			firstpress = false
		else:
			move = origpos - Input.get_mouse_pos()
			set_pos(get_pos() + move)
		origpos = Input.get_mouse_pos() 
	else:
		firstpress = true
		

func get_actual_pos(pos): #Worldpos from event.pos
	return pos * get_zoom() + get_pos() - OS.get_video_mode_size()/2 * get_zoom()