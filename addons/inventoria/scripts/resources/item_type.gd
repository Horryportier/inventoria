@icon("res://addons/inventoria/assets/inventory_type.svg")
class_name ItemType
extends Resource

## @overwrite
func is_same_type(other: ItemType) -> bool:
	return false
