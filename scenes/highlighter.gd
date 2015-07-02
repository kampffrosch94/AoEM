extends Node2D

var highlighted_cells = []
var cellsize = Vector2(32,32)
var highlightcolor =  Color(255,255,0,0.5)
var map

func _ready():
	map = get_node("/root/map")

func _draw():
	for cell in highlighted_cells: 
		var startcorner = map.map_to_world(Vector2(cell.x ,cell.y ))
		draw_rect(Rect2(startcorner, cellsize),highlightcolor)

func add_cells(cells):
	for cell in cells:
		add_cell(cell)

func add_cell(cell):
	if(highlighted_cells.find(cell) == -1):
		highlighted_cells.append(cell)

func reset():
	highlighted_cells = []