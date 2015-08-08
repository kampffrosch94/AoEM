extends Control

func _ready():
	pass

func _on_onedayButton_pressed():
	get_tree().change_scene("res://scenes/event/eventdialog.xml")
