extends WAT.Test

var GameScene = preload("res://scenes/game_scene.tscn")
var game_scene = null


func pre():	
	game_scene = GameScene.instance()
	game_scene.test_mode = true
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

func test_clicking_on_the_egg_updates_the_clicks_count() -> void:
	for i in 5:
		game_scene._on_Egg_pressed()
	asserts.is_equal(game_scene.game.get_clicks_count(), 5)

func test_TickTimer_timeout_updates_egg_counter() -> void:
	var game = game_scene.game
	game.set_egg_count(game.items[0].get_price())
	game.buy(game.items[0], 1)
	game_scene._on_TickTimer_timeout()
	asserts.is_greater_than(game.get_egg_count(), 0.0)


func test_item_button_container_is_correctly_filled() -> void:
	asserts.is_equal(game_scene.item_button_container.get_child_count(), game_scene.items_specifications.size())


func test_can_update_item_button_container() -> void:
	var game = game_scene.game
	game.buy(game.items[0], 1)
	game.buy(game.items[1], 1)
	game.set_egg_count(game.items[0].get_price())
	game_scene.update_item_button_container()
	
	asserts.is_false(game_scene.item_button_container.get_child(0).disabled)
	asserts.is_true(game_scene.item_button_container.get_child(1).disabled)
	asserts.is_true(game_scene.item_button_container.get_child(2).disabled)
	asserts.is_true(game_scene.item_button_container.get_child(3).disabled)
	asserts.is_true(game_scene.item_button_container.get_child(4).disabled)
	
	asserts.is_equal(game_scene.item_button_container.get_child(0).item_count.text, "x 1")
	asserts.is_equal(game_scene.item_button_container.get_child(1).item_count.text, "x 1")
	asserts.is_equal(game_scene.item_button_container.get_child(2).item_count.text, "x 0")
	asserts.is_equal(game_scene.item_button_container.get_child(3).item_count.text, "x 0")
	asserts.is_equal(game_scene.item_button_container.get_child(4).item_count.text, "x 0")


func test_can_buy_an_item_by_clicking_an_item_button() -> void:
	var game = game_scene.game
	game.set_egg_count(game.items[0].get_price())
	game_scene.update_item_button_container()
	game_scene._on_item_button_click(game.items[0])
	
	asserts.is_equal(game.items[0].get_count(), 1)


func test_reset_function_whipes_all_the_game_datas() -> void:
	var witness_game = game_scene.game.duplicate()
	game_scene.game.set_egg_count(12.0)
	game_scene.game.set_eggs_per_click(34.0)
	game_scene.game.set_inflation_rate(56.0)
	game_scene.game.set_production_rate(78.0)
	game_scene.reset_game()
	
	asserts.is_equal(game_scene.game.get_egg_count(), witness_game.get_egg_count())
	asserts.is_equal(game_scene.game.get_eggs_per_click(), witness_game.get_eggs_per_click())
	asserts.is_equal(game_scene.game.get_inflation_rate(), witness_game.get_inflation_rate())
	asserts.is_equal(game_scene.game.get_production_rate(), witness_game.get_production_rate())


func test_can_save_then_load_game() -> void:
	game_scene.game.set_egg_count(12.0)
	game_scene.game.set_eggs_per_click(34.0)
	game_scene.game.set_inflation_rate(56.0)
	game_scene.game.set_production_rate(78.0)
	game_scene.save_game()
	game_scene.reset_game()
	game_scene.load_game()
	asserts.is_equal(game_scene.game.get_egg_count(), 12.0)
	asserts.is_equal(game_scene.game.get_eggs_per_click(), 34.0)
	asserts.is_equal(game_scene.game.get_inflation_rate(), 56.0)
	asserts.is_equal(game_scene.game.get_production_rate(), 78.0)

func test_egg_per_second_label_is_updated_after_buying_an_item() -> void:
	var game = game_scene.game
	game.set_egg_count(game.items[0].get_price())
	game_scene.update_item_button_container()
	game_scene._on_item_button_click(game.items[0])
	asserts.is_equal(game_scene.eggs_per_second_label.text, str(game.items[0].get_eggs_per_second()))
	

