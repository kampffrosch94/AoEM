extends Node

var playerfactionid = 0

var defaultfont
var logger

func _ready():
	var l = Label.new()
	defaultfont = l.get_font('asdf')
	logger = load("res://scenes/common/logger.gd").Logger.new()
	logger.d("test","no echo")
	logger.d("test","jo echo",true)
	
