@icon("res://addons/inventoria/assets/inventory_item.svg")
class_name IItemVisual
extends Control

signal selected(idx: int)

@onready var texture_rect: TextureRect = $TextureRect

@export var item: IItem
@export_group("drag")
@export var use_custom_drag_scene: bool
@export var drag_scene: PackedScene 
@export_group("tooltip")
## custom_tooltip_scene has to be control type and have [color=red]setup(for_text: String, item: IItem)[/color] function
@export var custom_tooltip_scene: PackedScene

@export_group("select action")
@export var select_action: String
@export_group("indexing")
## Do not touch it its set internally 
@export var _current_index: int
## Do not touch it its set internally 
@export var _current_inventory: int

var mouse_hover: bool

func _ready() -> void:
	texture_rect.texture = item.icon if item != null else load("res://addons/inventoria/assets/null_item.png")
	mouse_entered.connect(func () -> void:  mouse_hover = true)
	mouse_exited.connect(func () -> void:  mouse_hover = false)


func _process(_delta: float) -> void:
	if mouse_hover and Input.is_action_just_released(select_action):
		selected.emit(get_parent().get_index())

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

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return get_parent()._can_drop_data(at_position, data)

func _drop_data(at_position: Vector2, data: Variant) -> void:
	get_parent()._drop_data(at_position, data)
	
func _make_custom_tooltip(for_text: String) -> Object:
	var t: Control = custom_tooltip_scene.instantiate()
	t.setup(for_text, item)
	return t
