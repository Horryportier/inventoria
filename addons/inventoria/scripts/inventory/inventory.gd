@tool
@icon("res://addons/inventoria/assets/inventory_icon.svg")
class_name IInventory
extends GridContainer

signal sockets_updated

@export var allowed_types: ItemType
@export var items:  Array[IItem]
@export var sockets:  Array[ISocket]
@export var items_visual_scene: PackedScene
@export var items_socket_scene: PackedScene
@export var sockets_count: int: 
	set(val):
		sockets_count = val
		_update_sockets()
		items.resize(sockets_count)
		sockets_updated.emit()

var id: int
static var next_id: int


func _ready() -> void:
	if !Engine.is_editor_hint():
		_set_id()
		_update_sockets()
		for i in items.size():
			if items[i] != null:
				add_visuals(i, items[i])

func _set_id() -> void:
	id = next_id
	next_id += 1

func add_item(item: IItem) -> bool:
	for idx in items.size():
		if items[idx] == null:
			items[idx] = item
			add_visuals(idx, item)
			return true
	return false


func add_visuals(idx: int,item: IItem) -> void:
	var item_visual: IItemVisual = items_visual_scene.instantiate()
	item_visual.item = item
	sockets[idx].add_child(item_visual)

func remove_item(idx: int) -> IItem:
	return null

func move_item(from, to, int) -> void:
	pass

func resize_inventory(size: int) -> void: 
	sockets_count = size

func _update_sockets() -> void:
	for child in get_children():
		if child is ISocket:
			child.queue_free()
	sockets.clear()
	for i in sockets_count:
		var socket = items_socket_scene.instantiate()
		add_child(socket)
		sockets.append(socket)
