@tool
@icon("res://addons/inventoria/assets/inventory_icon.svg")
class_name IInventory
extends GridContainer

signal on_selected(idx: int)
signal sockets_updated
signal item_moved(from, to: int, same_inventory: bool)
signal items_changed

@export_group("type")
@export var allowed_types: ItemType
@export_group("nodes")
@export var items:  Array[IItem]
@export var sockets:  Array[ISocket]
@export_group("packed scenes")
@export var items_visual_scene: PackedScene
@export var items_socket_scene: PackedScene
@export_group("select")
@export var can_select: bool 
## setting  to -1 will unselect all
@export var selected: int = -1:
	set(val):
		if !can_select:
			return
		deselect(selected)
		if selected == val:
			selected = -1
			on_selected.emit(-1)
		else:
			selected = val
			select(val)
			on_selected.emit(selected)
	

@export_group("sockets")
@export var sockets_count: int
@export_tool_button("Spawn Sockets", "Callable") var spawn_sockets: Callable = _update_sockets

var locked: bool

var id: int
static var next_id: int

static var inventories_node_paths: Dictionary[int, NodePath]

func _ready() -> void:
	_set_id()
	_set_node_path()
	items_changed.connect(_on_items_changed)
	if !Engine.is_editor_hint():
		_update_sockets()
		for i in items.size():
			if items[i] != null:
				items[i] = items[i].duplicate()
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
			items[idx] = item.duplicate()
			items_changed.emit()
			add_visuals(idx, item)
			return true
	return false

func overwrite_items(new_items: Array[IItem]) -> void:
	for idx in items.size():
		remove_visuals(idx)
	sockets_count = new_items.size()
	items.resize(new_items.size())
	for idx in  new_items.size():
		if idx > sockets.size():
			break
		items[idx] = new_items[idx] as IItem
		items_changed.emit()
		if items[idx] != null:
			add_visuals(idx, items[idx])
		
		

func get_item(idx: int) -> IItem:
	if idx < 0 or idx > items.size():
		printerr("idx is outside the range: ", idx)
		return null
	return items[idx]

func add_visuals(idx: int,item: IItem) -> void:
	var item_visual: IItemVisual = items_visual_scene.instantiate()
	item_visual.item = item
	sockets[idx].add_child(item_visual)
	item_visual._current_inventory = id
	item_visual._current_index = idx
	item_visual.selected.connect(_on_item_visual_selected)

func _on_item_visual_selected(idx: int) -> void:
	selected = idx


func remove_visuals(idx: int) -> void:
	if sockets[idx].get_child_count() == 0:
		return
	var c = sockets[idx].get_child(0)
	deselect(idx)
	if is_instance_valid(c):
		c.queue_free()

func remove_item(idx: int) -> IItem:
	if  items[idx] == null: 
		return null
	var i = items[idx].duplicate()
	items[idx] = null
	items_changed.emit()
	remove_visuals(idx)
	return i

func move_item(from, to, from_inv, to_inv: int, same_invnetory_move: bool = false) -> void:
	# set up inventory ids
	locked = true
	var _from_inv: int
	var _to_inv: int
	if same_invnetory_move:
		_from_inv = id
		_to_inv = id
	else: 
		_from_inv = from_inv
		_to_inv = to_inv

	if !_validate_move_index(from, to, _from_inv, _to_inv):
		printerr("wrong move item values from: %s to: %s with inventory from_inv:  %s to_inv: %s" % [from, to, from_inv, to_inv])
		locked = false
		return

	var from_inventory: = get_invetory_by_id(_from_inv)
	if from_inventory.items[from] == null:
		printerr("from item is null: ", from_inventory.items)
		locked = false
		return
	var to_inventory: = get_invetory_by_id(_to_inv)

	# setting `to` inventory slot
	var to_item: IItem 
	if to_inventory.items[to] != null:
		to_item = to_inventory.items[to].duplicate()
	to_inventory.items[to] = from_inventory.items[from].duplicate()
	to_inventory.remove_visuals(to)
	to_inventory.add_visuals(to, to_inventory.items[to])

	# setting `from` item slot
	from_inventory.items[from] = null
	from_inventory.remove_visuals(from)
	if to_item != null:
		from_inventory.items[from] = to_item
		from_inventory.add_visuals(from, from_inventory.items[from])
	# signals
	item_moved.emit(from, to, same_invnetory_move)
	from_inventory.items_changed.emit()
	to_inventory.items_changed.emit()
	
	locked = false


func _validate_move_index(from, to, from_inv, to_inv: int) -> bool:
	var from_items = get_invetory_by_id(from_inv).items
	var to_items = get_invetory_by_id(to_inv).items
	return from > 0 or from < from_items.size() and to > 0 or to < to_items.size()

func resize_inventory(size: int) -> void: 
	sockets_count = size
	_update_sockets()

func _update_sockets() -> void:
	for child in get_children():
		if child is ISocket:
			child.queue_free()
	sockets.clear()
	for i in sockets_count:
		var socket = items_socket_scene.instantiate()
		add_child(socket)
		sockets.append(socket)
	items.resize(sockets_count)
	sockets_updated.emit()

func select(idx: int) -> void:
	sockets[idx]._selected()

func deselect(idx: int) -> void:
	sockets[idx]._deselected()

func is_selected(idx: int) -> bool:
	return sockets[idx].selected

func _on_items_changed() -> void: 
	for idx in items.size():
		_update_item_visual(idx)
	
func _update_item_visual(idx: int) -> void:
	if items[idx] == null and sockets[idx].get_child_count() > 0: 
		sockets[idx].get_children().map(func (x: Node) -> Variant: x.queue_free(); return null)
