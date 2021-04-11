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
	init_items()
	add_item_buttons()
	
func init_items():
	var items_specs = [
		["Clicker", "res://assets/img/clicker.png", 1, 0.1], 
		["Chicken", "res://assets/img/poule.png", 100, 1], 
		["Nest", "res://assets/img/nid.png", 1000, 1.0],
		["Chicken coop", "res://assets/img/chicken-coop.png", 10000, 10.0],
		["Farmyard", "res://assets/img/farmyard.png", 100000, 100.0],
	]
	for spec in items_specs:
		var item = Item.new(spec[0], spec[1], spec[2], spec[3])
		game.items.append(item)


func get_game() -> Game:
	return game


func _on_Egg_pressed() -> void:
	game.click_egg()
	refresh_egg_counter()
	update_item_button_container()


func refresh_egg_counter(): 
	egg_counter_label.text = "%s eggs" % int(game.get_egg_count())


func _on_TickTimer_timeout() -> void:
	var count = game.get_egg_count()
	for item in game.items:
		 count += item.get_eggs_per_second() * item.get_count() #* egg_per_second_coeff
	game.set_egg_count(count)
	refresh_egg_counter()
	update_item_button_container()


func add_item_buttons() -> void:
	for item in game.items:
		var item_button = Item_button_scene.instance()
		item_button.init(item)
		item_button._ready()
		item_button_container.add_child(item_button)
		item_button.connect("pressed", self, "_on_item_button_click", [item])
	update_item_button_container()


func update_item_button_container():
	for item_button_scene in item_button_container.get_children():
		item_button_scene.disabled = game.get_egg_count() < item_button_scene.get_item().get_price()
		item_button_scene.refresh_labels()


func _on_item_button_click(item):
	if game.can_buy(item, 1):
		game.buy(item, 1)
		refresh_egg_counter()
		update_item_button_container()


func _on_SaveButton_pressed() -> void:
	print(JSON.print(game.save(), "\t"))
