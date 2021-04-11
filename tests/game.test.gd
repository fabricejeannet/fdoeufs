extends WAT.Test

var Game = load("res://scripts/Game.gd")
var game = null

func pre():	
	game = Game.new()
	
func post():
	game.queue_free()

func test_game_starts_with_zero_egg() -> void:
	asserts.is_equal(game.get_egg_count(), 0.0)


func test_can_set_an_egg_per_click_value() -> void:
	game.set_egg_per_click(2.0)
	game.click_egg()
	asserts.is_equal(game.get_egg_count(), 2.0)


func test_can_initialize_multiple_items() -> void:
	var items_specifications =  	[
		["title_0", "path_0", 0, 0.0],
		["title_1", "path_1", 1, 1.1],
	]
	game.init_items(items_specifications)
	asserts.is_equal(game.get_items().size(), 2)


func test_can_set_an_inflation_rate() -> void:
	game.set_inflation_rate(2.0)
	asserts.is_equal(game.get_inflation_rate(), 2.0)


func test_buying_an_item_increases_its_price_and_its_quantity() -> void:
	var item = Item.new("My Title", "path", 15, 1.0)
	game.set_inflation_rate(0.15)
	game.set_egg_count(200)
	game.buy(item, 8)
	asserts.is_equal(item.get_price(), 46)
	asserts.is_equal(item.get_count(), 8)


func test_cant_buy_items_if_you_dont_have_enough_eggs() -> void:
	var item = Item.new("My Title", "path", 15, 1.0)
	asserts.is_false(game.can_buy(item, 1))


func test_can_apply_both_positive_and_negative_effects_on_eggs_per_click_rate() -> void:
	game.set_production_rate(0.2)
	game.set_production_rate(-0.1)	
	game.set_egg_per_click(100.0)
	game.click_egg()
	asserts.is_equal(ceil(game.get_egg_count()), 110)


func test_can_count_eggs_produced_in_1_second_by_all_items() -> void :
	var items_specifications =  	[
		["title_0", "path_0", 0, 1.0],
		["title_1", "path_1", 1, 2.0],
	]
	game.init_items(items_specifications)
	game.buy(game.items[0], 1)
	game.buy(game.items[1], 1)
	var count = game.count_eggs_produced_by_items()
	asserts.is_equal(count, 3.0)


func test_can_apply_both_positive_and_negative_effects_on_eggs_per_second_rate() -> void:
	var items_specifications =  	[
		["title_0", "path_0", 0, 4.0],
		["title_1", "path_1", 1, 6.0],
	]
	game.init_items(items_specifications)
	game.buy(game.items[0], 1)
	game.buy(game.items[1], 1)
	game.set_production_rate(0.2)
	game.set_production_rate(-0.1)	
	var count = game.count_eggs_produced_by_items()
	asserts.is_equal(ceil(count), 11)


func test_can_convert_game_as_dictionary() -> void :
	var items_specifications = [
		["Item #0", "res://icon.png", 1.0, 0.0],
		["Item #1", "res://icon.png", 10.0, 2.0],
	]
	game.init_items(items_specifications)
	game.buy(game.items[0], 1)
	game.buy(game.items[1], 1)
	game.set_egg_count(2.0)
	var game_infos = game.get_game_datas()
	
	asserts.is_equal(game_infos["egg_count"], game.get_egg_count())
	asserts.is_equal(game_infos["egg_per_click"], game.get_egg_per_click())
	asserts.is_equal(game_infos["inflation_rate"], game.get_inflation_rate())
	asserts.is_equal(game_infos["production_rate"], game.get_production_rate())

	asserts.is_equal(game_infos["items"][0]["count"],game.items[0].get_count())
	asserts.is_equal(game_infos["items"][0]["price"],game.items[0].get_price())
	asserts.is_equal(game_infos["items"][0]["title"],game.items[0].get_title())
	asserts.is_equal(game_infos["items"][0]["icon_path"],game.items[0].get_icon_path())
	asserts.is_equal(game_infos["items"][0]["eggs_per_second"],game.items[0].get_eggs_per_second())

	asserts.is_equal(game_infos["items"][1]["count"],game.items[1].get_count())
	asserts.is_equal(game_infos["items"][1]["price"],game.items[1].get_price())
	asserts.is_equal(game_infos["items"][1]["title"],game.items[1].get_title())
	asserts.is_equal(game_infos["items"][1]["icon_path"],game.items[1].get_icon_path())
	asserts.is_equal(game_infos["items"][1]["eggs_per_second"],game.items[1].get_eggs_per_second())

	
