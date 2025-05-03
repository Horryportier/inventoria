@icon("res://addons/inventoria/assets/inventory_icon.svg")
class_name IInventory
extends GridContainer

@export var allowed_types: ItemType

func add_item() -> bool:
	return false

func remove_item(idx: int) -> IItem:
	return null


func move_item(from, to, int) -> void:
	pass


func resize_inventory(size: int) -> void: 
	pass
