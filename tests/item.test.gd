extends WAT.Test

var Item = load("res://scripts/Item.gd")

func test_can_initialize_item() -> void:
	var _title = "toto"
	var _icon_path = "res://icon.png"
	var _price = 10
	var _eggs_per_second = 2.0
	var item = Item.new(_title, _icon_path, _price, _eggs_per_second)
	asserts.is_equal(item.get_title(), _title)
	asserts.is_equal(item.get_icon_path(), _icon_path)
	asserts.is_equal(item.get_price(), _price)
	asserts.is_equal(item.get_eggs_per_second(), _eggs_per_second)
	asserts.is_equal(item.get_count(), 0)
