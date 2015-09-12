#A character is as the name suggests the representation of a character.
#It contains all the stats and abilities.
#If the character has a visual representation (actor), it knows it.

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
	
	var abilities = []
	
	func _init(shp , sdmg,sfac,sglobalnode):
		hp  = shp
		dmg = sdmg
		factionid = sfac
		globalnode = sglobalnode
		maxmp = 5
		maxap = 1
		reset_mp()
		reset_ap()
	
	func add_ability(abilityname):
		var ability = globalnode.abilitymanager.getAbility(abilityname)
		abilities.append(ability)
	
	func is_pc():
		if factionid == globalnode.playerfactionid : 
			return true
		else:
			return false
			
	
	func beattacked(edmg):
		takedmg(edmg)
	
	func takedmg(edmg):
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
	
	func update_actor():
		if actor != null:
			actor.update()
	
	func defeated():
		print ("U is kill.")
		if actor != null:
			actor.queue_free()
			actor = null
	
	
	func reset_mp():
		mp = maxmp
	
	func reset_ap():
		ap = maxap
	
	func end_turn():
		reset_mp()
		reset_ap()



class Ability:
	var name
	var icon
	
	var maxrange
	var effects =  []
	
	var apcost = 1
	var target_friendly = false
	
	
	func _init(sname,sicon,smaxrange = 1, starget_friendly = false):
		name = sname
		icon = sicon
		maxrange = smaxrange
		target_friendly = starget_friendly
	
	func add_effect(e):
		effects.append(e)

	func can_use(user):
		if user.ap >= apcost:
			return true
		else:
			return false

	func use(user,target):
		if user.ap < apcost:
			return false
		for effect in effects:
			effect.use(user,target) 
		user.ap -= apcost
		return true


class Effect:
	var terraineffect = false #if true it works on the mapfields, else only on characters
	const dmg = 0
	var type
	var scaling

	func _init(stype,sscaling):
		type = stype
		scaling = sscaling

	func use(user,target):
		if type == dmg:
			target.takedmg(scaling.scale(user))
		user.update_actor()
		target.update_actor()

class Scaling:
	var base = 0
	var dmgscaling = 0

	func scale(user):
		return base + user.dmg * dmgscaling
	
	func _init():
		pass

class AbilityManager:
	var abilityeffects
	var abilities
	
	func _init():
		abilityeffects = {}
		abilities = {}
		print("Error incoming")
		var attackscaling = load("res://scenes/common/character.gd").Scaling.new()
		attackscaling.dmgscaling = 1
		var attackeffect = load("res://scenes/common/character.gd").Effect.new(0,attackscaling)
		abilityeffects['attackeffect'] = attackeffect
		
		var healscaling = load("res://scenes/common/character.gd").Scaling.new()
		healscaling.base = -5
		var healeffect = load("res://scenes/common/character.gd").Effect.new(0,healscaling)
		abilityeffects['healeffect'] = healeffect
		
		var attack = load("res://scenes/common/character.gd").Ability.new("regular Attack",load("res://gfx/spells/earth/maxwells_silver_hammer.png"),1)
		attack.add_effect(attackeffect)
		abilities['attack'] = attack
		
		var flame = load("res://scenes/common/character.gd").Ability.new("Flame",load("res://gfx/spells/fire/flame_tongue.png"),30)
		flame.add_effect(attackeffect)
		abilities['flame'] = flame
	
	func getAbility(abilityname):
		return abilities[abilityname]
