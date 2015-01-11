
extends TileMap

var camera
var blockingtiles

var lastclickedsprite = null

func _ready():
	blockingtiles = [1]
	camera = get_node("camera")
	set_process_unhandled_input(true)

func _unhandled_input(event):
	if((event.type==InputEvent.MOUSE_BUTTON)):
		if((event.button_index == 1) and event.is_pressed()):
			var pos = world_to_map(camera.get_actual_pos(event.pos))
			print ("Click Tile: ", pos )
			if(  blockingtiles.find( get_cell(pos.x,pos.y) )  != -1 ) :
				print ("Blocked")
