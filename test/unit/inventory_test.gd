extends GutTest

var inventory: IInventory = null 

@onready var i_visual_scene: = preload("res://test/test_i_item_visual.tscn")
@onready var i_socket_scene: = preload("res://test/test_i_socket.tscn")

func before_each():
	gut.p("setting up inventory")
	inventory  = IInventory.new()
	inventory.sockets_count = 10
	inventory.items_visual_scene = i_visual_scene
	inventory.items_socket_scene = i_socket_scene

func after_each():
	inventory.queue_free()

func test_add_item():
	var item: IItem = load("uid://cxakjb2q8apcw")
	inventory.add_item(item)
	assert_eq(inventory.get_item(0), item, "item add not working")
