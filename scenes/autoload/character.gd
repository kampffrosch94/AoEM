extends Node

func _ready():
	pass


func createCharacter(hp,dmg,fac):
	return Character.new(hp,dmg,5,fac,get_node("/root/global"))

class Character:
	var hp
	var dmg
	var factionid
	var globalnode
	var actor = null
	
	var movementpoints
	var maxmovementpoints
	
	func _init(shp , sdmg, smaxmovementpoints,sfac , sglobalnode):
		hp  = shp
		dmg = sdmg
		factionid = sfac
		globalnode = sglobalnode
		maxmovementpoints = smaxmovementpoints
		reset_mp()
	
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
	
	func can_move(cost):
		if(cost <= movementpoints):
			return true
		else:
			return false
	
	
	func defeated():
		print ("U is kill.")
		if actor != null:
			actor.queue_free()
			#actor.get_parent().remove_and_delete_child(actor)
			actor = null
	
	func pay_mp(cost):
		movementpoints = movementpoints - cost
	
	func reset_mp():
		movementpoints = maxmovementpoints
	
	func end_turn():
		reset_mp()

