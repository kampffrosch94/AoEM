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
	
	func _init(shp , sdmg, sfac , sglobalnode):
		hp  = 10
		dmg = 2
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

