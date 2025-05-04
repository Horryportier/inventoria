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

static var inventories_node_paths: Dictionary[int, NodePath]


func _ready() -> void:
	_set_id()
	_set_node_path()
	if !Engine.is_editor_hint():
		_update_sockets()
		for i in items.size():
			if items[i] != null:
				add_visuals(i, items[i])

func _set_id() -> void:
	id = next_id
	next_id += 1

func _set_node_path() -> void:
	inventories_node_paths.set(id, get_path())

func get_invetory_by_id(i: int) -> IInventory:
	return get_node(inventories_node_paths.get(i, 0))


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
	item_visual._current_ivnventory = id
	item_visual._current_index = idx

func remove_visuals(idx: int) -> void:
	var c = sockets[idx].get_child(0)
	if is_instance_valid(c):
		c.queue_free()

func remove_item(idx: int) -> IItem:
	if  items[idx] == null: 
		return null
	var i = items[idx].duplicate()
	items[idx] = null
	remove_visuals(idx)
	return i

func move_item(from, to, from_inv, to_inv: int) -> void:
	if !_validate_move_index(from, to, from_inv, to_inv):
		printerr("wrong move item values from: %s to: %s with inventory from_inv:  %s to_inv: %s" % [from, to, from_inv, to_inv])
	var from_inventory: = get_invetory_by_id(from_inv)
	if from_inventory.items[from] == null:
		printerr("from item is null: ", from_inventory.items)
		return
	var to_inventory: = get_invetory_by_id(to_inv)
	to_inventory.items[to] = from_inventory.items[from].duplicate()
	to_inventory.add_visuals(to, to_inventory.items[to])
	from_inventory.items[from] = null
	from_inventory.remove_visuals(from)


func _validate_move_index(from, to, from_inv, to_inv: int) -> bool:
	var from_items = get_invetory_by_id(from_inv).items
	var to_items = get_invetory_by_id(to_inv).items
	return from > 0 or from < from_items.size() and to > 0 or to < to_items.size()

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
