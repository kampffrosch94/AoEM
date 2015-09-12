extends Control

func _ready():
	var charscript = load("res://scenes/common/character.gd")


	var char  = charscript.Character.new(10,2,0,get_node("/root/global"))
	char.add_ability('attack')
	char.add_ability('flame')
	char.texturename = "human_m"
	
	var apc = char.create_actor()
	apc.set_pos(Vector2(50,50))
	add_child(apc)

func _on_onedayButton_pressed():
	get_tree().change_scene("res://scenes/event/eventdialog.xml")
