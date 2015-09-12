extends Node

var global = get_node("/root/global")
var charscript = load("res://scenes/common/character.gd")
var playercharacters = []

func ready():
	var char  = charscript.Character.new(10,2,0,get_node("/root/global"))
	char.add_ability('attack')
	char.add_ability('flame')
	playercharacters.append(char)
	
	char = charscript.Character.new(10,2,0,global)
	char.add_ability('attack')

func new_game():
	pass
