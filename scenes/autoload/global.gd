extends Node

var playerfactionid = 0

var defaultfont

func _ready():
	var l = Label.new()
	defaultfont = l.get_font('asdf')
