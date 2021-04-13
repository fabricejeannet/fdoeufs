extends Node

var Game = load("res://scripts/Game.gd")
var game = null
var egg 
var egg_counter_label
var eggs_per_second_label
var eggs_per_click_label
var item_button_container
var tick_timer
var Item_button_scene = preload("res://scenes/item_button_scene.tscn")
var items_specifications = [
		["Clicker", "res://assets/img/clicker.png", 10, 0.1], 
		["Chicken", "res://assets/img/poule.png", 100, 1], 
		["Nest", "res://assets/img/nid.png", 1000, 4.0],
		["Chicken coop", "res://assets/img/chicken-coop.png", 10000, 10.0],
		["Farmyard", "res://assets/img/farmyard.png", 100000, 100.0],
	]
var test_mode = false

const PROD_FILE_PATH = "user://game.fdoeufs"
const TEST_FILE_PATH = "user://test.fdoeufs"


func _ready() -> void:
	egg = $HBoxContainer/MarginContainer/VBoxContainer/Egg
	egg_counter_label = $HBoxContainer/MarginContainer/VBoxContainer/EggCounterLabel
	eggs_per_second_label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/EggsPerSecondLabel
	eggs_per_click_label = $HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/EggsPerClickLabel
	item_button_container = $HBoxContainer/MarginContainer2/ItemContainer
	tick_timer = $TickTimer
	
	if test_mode:
		reset_game()
	else:
		load_game()		
	

func init_items():
	for spec in items_specifications:
		var item = Item.new(spec[0], spec[1], spec[2], spec[3])
		game.items.append(item)


func get_game() -> Game:
	return game


func _on_Egg_pressed() -> void:
	game.click_egg()
	refresh_eggs_counters()
	update_item_button_container()


func refresh_eggs_counters(): 
	egg_counter_label.text = "%s eggs" % int(game.get_egg_count())
	eggs_per_second_label.text = str(game.get_eggs_per_second_rate())
	eggs_per_click_label.text = str(game.get_eggs_per_click())


func _on_TickTimer_timeout() -> void:
	var count = game.get_egg_count()
	for item in game.items:
		 count += item.get_eggs_per_second() * item.get_count() #* egg_per_second_coeff
	game.set_egg_count(count)
	refresh_eggs_counters()
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
#		item_button_scene.release_focus()

func _on_item_button_click(item):
	if game.can_buy(item, 1):
		game.buy(item, 1)
		refresh_eggs_counters()
		update_item_button_container()
	egg.grab_focus()

func _on_SaveButton_pressed() -> void:
	save_game()
	
	
func save_game() -> void :
	var game_datas = game.get_game_datas()
	var game_file = File.new()
	game_file.open(get_file_path(), File.WRITE)
	game_file.store_string(JSON.print(game_datas,"\t"))
	game_file.close()


func get_file_path() -> String:
	if test_mode:
		return TEST_FILE_PATH
	else:
		return PROD_FILE_PATH


func load_game() -> void:
	var file = File.new()
	
	if not file.file_exists(get_file_path()):
		reset_game()
	else :
		file.open(get_file_path(), File.READ)
		var content = JSON.parse(file.get_as_text())
		if content.error == OK:
			game = Game.new()
			game.set_egg_count(float(content.result["egg_count"]))
			game.set_eggs_per_click(float(content.result["egg_per_click"]))
			game.set_inflation_rate(float(content.result["inflation_rate"]))
			game.set_production_rate(float(content.result["production_rate"])) 
			game.set_clicks_count(int(content.result["clicks_count"]))
			for item_data in content.result["items"]:
				var item = Item.new(item_data["title"], item_data["icon_path"], float(item_data["price"]), float(item_data["eggs_per_second"]))
				item.set_count(int(item_data["count"]))
				game.items.append(item)
			file.close()
			add_item_buttons()
			tick_timer.start(0.0)
		else:
			reset_game()


func reset_game() -> void:
	tick_timer.stop()
	game = Game.new()
	init_items()
	for child in item_button_container.get_children():
		item_button_container.remove_child(child)
		child.queue_free()
	add_item_buttons()
	refresh_eggs_counters()
	tick_timer.start(0.0)


func _on_SaveTimer_timeout() -> void:
	if not test_mode:
		print("Autosave...")
		save_game()


func _on_ResetButton_pressed() -> void:
	reset_game()

