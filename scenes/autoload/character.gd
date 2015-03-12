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
	
	var mp
	var maxmp
	
	var ap #actionpoints, for attacking atm
	var maxap
	
	func _init(shp , sdmg, smaxmp,sfac , sglobalnode):
		hp  = shp
		dmg = sdmg
		factionid = sfac
		globalnode = sglobalnode
		maxmp = smaxmp
		maxap = 1
		reset_mp()
		reset_ap()
	
	func is_pc():
		if factionid == globalnode.playerfactionid : 
			return true
		else:
			return false
			
	func attack(char):
		ap = ap - 1
		char.beattacked(dmg)
		if(char.actor != null):
			char.actor.update()
		if(actor != null):
			actor.update()
	
	func beattacked(edmg):
		hp = hp - edmg
		print ("New hp: ",hp)
		if hp <= 0 :
			defeated()
	
	func can_move(cost):
		if(cost <= mp):
			return true
		else:
			return false
	
	func can_act():
		if ap > 0:
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
		mp = mp - cost
	
	func reset_mp():
		mp = maxmp
	
	func reset_ap():
		ap = maxap
	
	func end_turn():
		reset_mp()
		reset_ap()

