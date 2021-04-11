extends Button
class_name ItemButtonScene

var item:Item

onready var item_button = find_node("ItemButton")
onready var item_icon = find_node("ItemIcon")
onready var item_title = find_node("ItemTitle")
onready var item_count = find_node("ItemCount")
onready var item_price = find_node("ItemPrice")

func init(_item:Item):
	item = _item
	
func _ready() -> void:
	disabled = true
	item_icon.texture = load(item.get_icon_path())
	refresh_labels()

func get_item() -> Item:
	return item

func refresh_labels() -> void:
	item_title.text = item.get_title()
	item_count.text = "x %s" % item.get_count()
	item_price.text = "%s" % item.get_price()
