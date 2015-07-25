#A basic camera to see a part of the tilemap.
#Can be moved while clicking the middle mouse button.

extends Camera2D

var move
var firstpress = true
var origpos
var logger

func _ready():
	logger = get_node("/root/global").logger
	make_current()
	set_centered(true)

func handle_movement():
	logger.d("camera","handling cameramovement",true)
	firstpress = true
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("camera_move"):
		get_tree().set_input_as_handled()
		if(firstpress):
			firstpress = false
		else:
			move = origpos - get_viewport().get_mouse_pos()
			set_pos(get_pos() + move)
		origpos = get_viewport().get_mouse_pos()
	else:
		set_process(false)
		logger.d("camera","completed handling cameramovement",true)

func get_actual_pos(pos): #Worldpos from event.pos
	return pos * get_zoom() + get_pos() - OS.get_video_mode_size()/2 * get_zoom()