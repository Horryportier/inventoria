@icon("res://addons/inventoria/assets/inventory_socket.svg")
class_name ISocket
extends Control

@onready var inventory: IInventory = get_parent()


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return _validate_data(data) and inventory.allowed_types.is_same_type(data.item.type)

func _validate_data(data: Variant) -> bool:
	return data is IItemVisual and data.item != null 

func _drop_data(at_position: Vector2, data: Variant) -> void:
	inventory.move_item(data._current_index, get_index(), data._current_ivnventory, inventory.id)
	
