extends Node

var playerfactionid = 0
var abilitymanager
var texturemanager

var defaultfont
var logger


func _ready():
	var l = Label.new()
	defaultfont = l.get_font('asdf')
	logger = load("res://scenes/common/logger.gd").Logger.new()
	abilitymanager = load("res://scenes/common/character.gd").AbilityManager.new()
	texturemanager = load("res://scenes/common/character.gd").TextureManager.new()
