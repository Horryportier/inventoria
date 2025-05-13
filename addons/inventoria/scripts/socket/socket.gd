@icon("res://addons/inventoria/assets/inventory_socket.svg")
class_name ISocket
extends Control

@onready var inventory: IInventory = get_parent()

var selected: bool

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return !inventory.locked and _validate_data(data) and inventory.allowed_types.is_same_type(data.item.type)

func _validate_data(data: Variant) -> bool:
	return data is IItemVisual and can_item_swap(data._current_inventory)

func can_item_swap(inv_id: int) -> bool:
	var to_inventory: IInventory = inventory.get_invetory_by_id(inv_id)
	var item: IItem = inventory.get_item(get_index())
	if item == null:
		return true
	var res: = to_inventory.allowed_types.is_same_type(item.type)
	return res

func _drop_data(at_position: Vector2, data: Variant) -> void:
	inventory.move_item(data._current_index, get_index(), data._current_inventory, inventory.id)
	
func _selected() -> void: 
	selected = true
	self_modulate = Color.RED
	pass

func _deselected() -> void:
	selected = false
	self_modulate = Color.WHITE
	pass
