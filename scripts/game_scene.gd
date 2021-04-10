extends Node

var Game = load("res://scripts/Game.gd")
var game = null
var egg 
var egg_counter_label

func _init() -> void:
	print("init")
	game = Game.new()


func _ready() -> void:
	print("ready")
	egg = $HBoxContainer/MarginContainer/VBoxContainer/Egg
	egg_counter_label = $HBoxContainer/MarginContainer/VBoxContainer/EggCounterLabel


func get_game() -> Game:
	return game


func _on_Egg_pressed() -> void:
	game.click_egg()
	refresh_egg_counter()
#	refresh_item_list()


func refresh_egg_counter(): 
	egg_counter_label.text = "%s eggs" % int(game.get_egg_count())


func _on_TickTimer_timeout() -> void:
	var count = game.get_egg_count()
	for item in game.items:
		 count += item.get_eggs_per_second() * item.get_count() #* egg_per_second_coeff
	game.set_egg_count(count)
	refresh_egg_counter()
#	refresh_item_list()
