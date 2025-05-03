class_name TestItemType
extends ItemType

@export_flags("Weapon:1", "Consumable:2", "Armor:4") var type: int

func is_same_type(other : ItemType) -> bool:
	if other.get("type") == null:
		return false
	return type & other.type != 0
