extends CanvasLayer

const ITEMS_PATH: String = "res://test/items/"

@export var add_button: Button
@export var remove_button: Button


@export var inventory: IInventory

func _ready() -> void:
	add_button.pressed.connect(_on_add_button_pressed)
	remove_button.pressed.connect(_on_remove_button_pressed)

func _on_add_button_pressed() -> void:
	var items = DirAccess.get_files_at(ITEMS_PATH)
	var item = items[randi_range(0, items.size() -1)]
	if !inventory.add_item(load(ITEMS_PATH + item)):
		await create_tween().tween_property(add_button,"modulate", Color.RED, 1).finished
		create_tween().tween_property(add_button,"modulate", Color.WHITE, 1)

func _on_remove_button_pressed() -> void:
	var idx = randi_range(0,inventory.items.size() - 1) 
	if inventory.remove_item(idx) == null:
		await create_tween().tween_property(remove_button,"modulate", Color.RED, 1).finished
		create_tween().tween_property(remove_button,"modulate", Color.WHITE, 1)
		
