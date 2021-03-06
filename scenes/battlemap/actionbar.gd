#This is the actionbar, a contextmenu for the abilities of a selected character.
extends HButtonArray

var logger

func _ready():
	logger = get_node("/root/global").logger
	grab_focus()
	#define Shortcut events
	var event = InputEvent()
	event.type = InputEvent.KEY
#	event.pressed = false
	InputMap.add_action("actionbarkey")
	
	for i in range(49,59):
		event.scancode = i
		InputMap.action_add_event("actionbarkey", event)
	
func _input_event(event):
	if(event.is_action("actionbarkey") && event.is_pressed()):
		var id = event.scancode - 49
		set_selected(id)
	elif event.type == InputEvent.KEY and event.is_pressed() and event.scancode == 69:
		get_node("/root/map")._on_endturnbutton_pressed()


func load_abilities(char):
	clear()
	for ability in char.abilities:
		add_icon_button(ability.icon, "")