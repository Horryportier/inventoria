@icon("res://addons/inventoria/assets/inventory_item.svg")
class_name IItemVisual
extends Control

@onready var texture_rect: TextureRect = $TextureRect

@export var item: IItem

func _ready() -> void:
	texture_rect.texture = item.icon
