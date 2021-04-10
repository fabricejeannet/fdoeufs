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
	


