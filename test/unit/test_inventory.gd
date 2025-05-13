extends GutTest

var inventory: IInventory = null 
@onready var i_visual_scene: PackedScene = preload("res://test/test_i_item_visual.tscn")
@onready var i_socket_scene: PackedScene = preload("res://test/test_i_socket.tscn")
@onready var sword: IItem = preload("uid://cxakjb2q8apcw")
@onready var potion: IItem = preload("uid://d2tmn08bqn72d")
@onready var armor: IItem = preload("uid://btsup46hp2qlo")

func before_each():
	gut.p("setting up inventory")
	inventory  = IInventory.new()
	get_parent().add_child(inventory)
	inventory.items_socket_scene = i_socket_scene 
	inventory.items_visual_scene = i_visual_scene
	inventory.resize_inventory(10)

func after_each():
	inventory.queue_free()

func test_add_item():
	inventory.add_item(sword)
	assert_eq(inventory.get_item(0).id , sword.id, "item add not working")

func test_remove_item():
	test_add_item()
	assert_eq(inventory.remove_item(0).id, sword.id, "remove item returned null")

func test_move_item_to_empty():
	inventory.add_item(sword)
	inventory.add_item(potion)
	assert_true(assert_ids(inventory.get_item(0), sword), "pre move item at 0 is not sword")
	assert_true(assert_ids(inventory.get_item(1), potion), "pre move item at 1 is not potion")
	inventory.move_item(0, 2, 0, 0, true)
	assert_eq(inventory.items.size(), 10, "inventory size is mismatched")
	assert_eq(inventory.get_item(0), null, "item at 0 is not null")
	assert_true(assert_ids(inventory.get_item(1), potion), "item at 1 is not potion")
	assert_true(assert_ids(inventory.get_item(2), sword), "item at 2 is not sword")
	gut.p(inventory.items)

func test_move_item_and_swap():
	inventory.add_item(sword)
	inventory.add_item(potion)
	assert_true(assert_ids(inventory.get_item(0), sword), "pre move item at 0 is not sword")
	assert_true(assert_ids(inventory.get_item(1), potion), "pre move item at 1 is not potion")
	inventory.move_item(0, 1, 0, 0, true)
	assert_true(assert_ids(inventory.get_item(0), potion), "item at 0 is not potion")
	assert_true(assert_ids(inventory.get_item(1), sword), "item at 1 is not sword")

func assert_ids(a, b: IItem) -> bool:
	if a == null or b == null:
		return false
	return a.id == b.id
