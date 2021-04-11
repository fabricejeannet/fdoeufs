extends Node

var Game = load("res://scripts/Game.gd")
var game = null
var egg 
var egg_counter_label
var item_button_container
var Item_button_scene = preload("res://scenes/item_button_scene.tscn")

func _init() -> void:
	game = Game.new()


func _ready() -> void:
	egg = $HBoxContainer/MarginContainer/VBoxContainer/Egg
	egg_counter_label = $HBoxContainer/MarginContainer/VBoxContainer/EggCounterLabel
	item_button_container = $HBoxContainer/MarginContainer2/ItemContainer

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


func add_item_buttons() -> void:
	for item in game.items:
		var item_button = Item_button_scene.instance()
		item_button.init(item)
		item_button_container.add_child(item_button)
		item_button.connect("pressed", self, "_on_item_button_click", [item])
#	refresh_item_list()

func update_item_button_container():
	for item_button_scene in item_button_container.get_children():
		item_button_scene.disabled = game.get_egg_count() < item_button_scene.get_item().get_price()
		item_button_scene.refresh_labels()
	
