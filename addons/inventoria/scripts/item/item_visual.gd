@icon("res://addons/inventoria/assets/inventory_item.svg")
class_name IItemVisual
extends Control

@onready var texture_rect: TextureRect = $TextureRect

@export var item: IItem
@export_group("drag")
@export var use_custom_drag_scene: bool
@export var drag_scene: PackedScene 
@export_group("tooltip")
## custom_tooltip_scene has to be control type and have [color=red]setup(for_text: String, item: IItem)[/color] function
@export var custom_tooltip_scene: PackedScene

@export_group("indexing")
## Do not touch it its set internally 
@export var _current_index: int
## Do not touch it its set internally 
@export var _current_ivnventory: int

func _ready() -> void:
	texture_rect.texture = item.icon

func _get_drag_data(at_position: Vector2) -> Variant:
	if use_custom_drag_scene:
		var custom: Control = 	 drag_scene.instantiate()
		custom.item = item
		set_drag_preview(custom)
		return custom
	var v: = self.duplicate()
	v.item = item
	v._current_index = _current_index
	set_drag_preview(v)
	return v

	
func _make_custom_tooltip(for_text: String) -> Object:
	var t: Control = custom_tooltip_scene.instantiate()
	t.setup(for_text, item)
	return t


