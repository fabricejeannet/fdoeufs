extends WAT.Test

var ItemButton = preload("res://scenes/item_button_scene.tscn")

func test_can_initialize_button_with_item() -> void:
	var _title = "toto"
	var _icon_path = "res://icon.png"
	var _price = 10
	var _eggs_per_second = 2.0
	var item = Item.new(_title, _icon_path, _price, _eggs_per_second)
	
	var item_button = ItemButton.instance()
	item_button.init(item)
	item_button._ready()
	asserts.is_equal(item_button.item_title.text, _title)
	asserts.is_equal(item_button.item_price.text, str(_price))	
	asserts.is_equal(item_button.item_count.text, "x 0")	
