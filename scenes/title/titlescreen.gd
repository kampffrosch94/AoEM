extends TextureFrame

func _ready():
	pass



func _on_continueButton_pressed():
	get_tree().change_scene("res://scenes/base/base.xml")



func _on_exitButton_pressed():
	get_tree().quit()
