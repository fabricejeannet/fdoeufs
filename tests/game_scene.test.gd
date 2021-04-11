extends WAT.Test

var GameScene = preload("res://scenes/game_scene.tscn")
var game_scene = null


func pre():	
	game_scene = GameScene.instance()
	game_scene._ready()
	
func post():
	game_scene.queue_free()


func test_can_create_a_game_scene() -> void:
	asserts.is_not_null(game_scene)


func test_game_scene_has_a_game() -> void:
	asserts.is_not_null(game_scene.get_game())


func test_clicking_on_the_egg_updates_egg_counter() -> void:
	game_scene._on_Egg_pressed()
	asserts.is_equal(float(game_scene.egg_counter_label.text), game_scene.game.get_egg_count())


func test_timer_timeout_updates_egg_counter() -> void:
	var game = game_scene.game
	game.set_egg_count(2.0)
	var item = Item.new("Test item", "res://icon.png", 1.0, 10.0)
	game.items.append(item)
	game.buy(item, 1)
	game_scene._on_TickTimer_timeout()
	asserts.is_equal(game.get_egg_count(), 11.0)
	

func test_item_button_container_is_correctly_filled() -> void:
	var items_specifications = [
		["Item #0", "res://icon.png", 1.0, 10.0],
		["Item #1", "res://icon.png", 1.0, 10.0],
		["Item #2", "res://icon.png", 1.0, 10.0],
	]
	var game = game_scene.game
	game.init_items(items_specifications)
	game_scene.add_item_buttons()
	asserts.is_equal(game_scene.item_button_container.get_child_count(), 3)


func test_can_update_item_button_container() -> void:
	var items_specifications = [
		["Item #0", "res://icon.png", 1.0, 0.0],
		["Item #1", "res://icon.png", 10.0, 2.0],
	]
	var game = game_scene.game
	game.init_items(items_specifications)
	game.buy(game.items[0], 1)
	game.buy(game.items[1], 1)
	game_scene.add_item_buttons()
	for item_button in game_scene.item_button_container.get_children(): #_ready function is not called automaticaly 
		item_button._ready()
	game.set_egg_count(2.0)
	game_scene.update_item_button_container()
	asserts.is_false(game_scene.item_button_container.get_child(0).disabled)
	asserts.is_true(game_scene.item_button_container.get_child(1).disabled)
	asserts.is_equal(game_scene.item_button_container.get_child(0).item_count.text, "x 1")
	asserts.is_equal(game_scene.item_button_container.get_child(1).item_count.text, "x 1")


	
	


