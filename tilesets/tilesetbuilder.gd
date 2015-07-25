tool
func _run():    
	var tileset = TileSet.new()
	var respaths = []
	respaths.append("gfx/dc-dngn/floor/grey_dirt0.png")
	respaths.append("gfx/dc-dngn/wall/brick_dark0.png")
	for respath in respaths:
		var res = load("res://"+respath)
		var id = tileset.get_last_unused_tile_id()
		tileset.create_tile(id)
		tileset.tile_set_name(id,respath)
		tileset.tile_set_texture(id,res)
	ResourceSaver.save("res://tilesets/tilesdungeon.xml", tileset)