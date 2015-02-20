extends Node

func _ready():
	pass


class Character:
	var hp
	var dmg
	func _init():
		hp  = 10
		dmg = 2

	func is_pc():
		return false


class Playercharacter:
	extends Character
	func is_pc():
		return true

class Enemy:
	extends Character

