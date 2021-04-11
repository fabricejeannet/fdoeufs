extends Node

class_name Game

var _egg_count = 0.0
var _egg_per_click = 1.0
var items = []
var _inflation_rate = 1.0
var _production_rate = 1.0

func get_egg_count() -> float:
	return _egg_count


func set_egg_count(value:float) -> void:
	_egg_count = value


func set_egg_per_click(value:float) -> void:
	_egg_per_click = value

	
func click_egg() -> void:
	_egg_count += _egg_per_click * _production_rate


func init_items(items_specifictions) -> void:
	for spec in items_specifictions:
		var item = Item.new(spec[0], spec[1], spec[2], spec[3])
		items.append(item)


func get_items():
	return items


func set_inflation_rate(value:float) -> void:
	_inflation_rate = value


func get_inflation_rate() -> float:
	return _inflation_rate


func can_buy(item, quantity) -> bool:
	return _egg_count >= item.get_price() * quantity


func buy(item:Item, quantity:int) -> void:
	_egg_count -= item.get_price() * float(quantity)
	increase_item_price(item, quantity)
	item.add_to_count(quantity)


func increase_item_price (item, quantity) -> void :
	var new_price = ceil(float(item.get_price()) * pow(1.0 + _inflation_rate, quantity))
	item.set_price(new_price)


func set_production_rate(value:float) -> void:
	_production_rate += value


func count_eggs_produced_by_items() -> float:
	var count = 0.0
	for item in items:
		count += item.get_eggs_per_second() * item.get_count() * _production_rate
	return count

func save():
	var items_infos = []
	for item in items :
		var item_infos = {
			"title" : item.get_title(),
			"icon_path" : item.get_icon_path(),
			"price": item.get_price(),
			"eggs_per_second" : item.get_eggs_per_second(),
			"count" : item.get_count(),
		}
		items_infos.append(item_infos)
	
	var  game_infos = {
		"egg_count" : _egg_count,
		"egg_per_click" : _egg_per_click,
		"inflation_rate" : _inflation_rate,
		"production_rate" : _production_rate,
		"items" : items_infos,
	}
	return game_infos

	
	 
