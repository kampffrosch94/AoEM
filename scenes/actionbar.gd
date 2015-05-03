
extends HButtonArray


func _ready():
	grab_focus()
	#define Shortcut events
	var event = InputEvent()
	event.type = InputEvent.KEY
#	event.pressed = false
	InputMap.add_action("actionbarkey")
	
	event.scancode = 49
	InputMap.action_add_event("actionbarkey", event)
	
	event.scancode = 50
	InputMap.action_add_event("actionbarkey", event)
	
func _input_event(event):
	if(event.is_action("actionbarkey") && event.is_pressed()):
		var id = event.scancode - 49
		set_selected(id)

