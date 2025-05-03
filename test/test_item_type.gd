class_name TestItemType
extends ItemType

@export_flags("Weapon:1", "Consumable:2", "Armor:4") var type: int

func is_same_type(other : int) -> bool:
	return type & other != 0
