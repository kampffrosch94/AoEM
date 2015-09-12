extends Control

func _ready():
	var charscript = load("res://scenes/common/character.gd")


	var char  = charscript.Character.new(10,2,0,get_node("/root/global"))
	char.add_ability(attack)
	char.add_ability(flame)
	var texture = load("res://gfx/player/base/human_m.png")
	
	var apc = load("res://scenes/common/movable.gd").Actor.new(texture,char)
	apc.set_pos(Vector2(50,50))
	add_child(apc)

func _on_onedayButton_pressed():
	get_tree().change_scene("res://scenes/event/eventdialog.xml")
