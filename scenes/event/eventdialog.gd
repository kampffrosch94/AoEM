extends Control

var logger
var textfield
var buttonarray
var scrollcontainer 
var box 



func _ready():
	logger = get_node("/root/global").logger
	textfield = get_node("text")
	scrollcontainer = get_node("scrollcontainer")
	box = get_node("scrollcontainer/box")
	
	grab_focus()
	
	textfield.add_text("An Event occurs: \n\nSome ruffians want a piece of you. How do you react?")

	add_choice(1,"I shall fight them bravely and with honor.")
	add_choice(2,"Run awwwayyyyy!")
	

func add_choice(id,text):
	var button = Labelbutton.new(id,text)
	box.add_child(button)

func reset():
	reset_choices()
	textfield.clear()

func reset_choices():
	for child in box.get_children():
		box.remove_child(child)

func choice(id,text):
	logger.i("eventdialog","Made choice: " + str(id) + "  " +text,true)
	if id == 1:
		get_tree().change_scene("res://scenes/battlemap/battlemap.xml")
	if id == 2:
		reset()
		textfield.add_text("The gods smite you for your cowardice. You see your life flashing before your eyes before you finally meet your end.")
		textfield.add_text("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
		textfield.add_image(load("res://gfx/fine.jpeg"))
		add_choice(3,"This is fine.")
	
	if id == 3:
		logger.t("eventdialog","Inside choice 3",true)
		get_tree().change_scene("res://scenes/title/titlescreen.xml")

class Labelbutton:
	extends Label
	
	var id = null
	
	func _ready():
		set_process_input(true)
	
	func _init(id,text):
		self.id = id
		set_text(text)
	
	func _input(event):
		if event.type == InputEvent.MOUSE_BUTTON and event.is_pressed():
			var xmin = get_global_pos().x
			var ymin = get_global_pos().y
			var xmax = xmin + get_size().x
			var ymax = ymin + get_size().y
			if event.pos.x >= xmin and event.pos.x <= xmax:
				if event.pos.y >= ymin and event.pos.y <= ymax:
					get_node("/root/eventdialog").choice(id,get_text())
	