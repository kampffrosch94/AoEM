extends Node

func _ready():
	pass


func createCharacter(hp,dmg,fac):
	return Character.new(hp,dmg,fac,get_node("/root/global"))

class Character:
	var hp
	var dmg
	var factionid
	var globalnode
	var actor = null
	
	func _init(shp , sdmg, sfac , sglobalnode):
		hp  = shp
		dmg = sdmg
		factionid = sfac
		globalnode = sglobalnode
	
	func is_pc():
		if factionid == globalnode.playerfactionid : 
			return true
		else:
			return false
			
	func attack(char):
		char.beattacked(dmg)
	
	func beattacked(edmg):
		hp = hp - edmg
		print ("New hp: ",hp)
		if hp <= 0 :
			defeated()
	
	func defeated():
		print ("U is kill.")
		if actor != null:
			actor.queue_free()
			#actor.get_parent().remove_and_delete_child(actor)
			actor = null

