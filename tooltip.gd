extends IInventoryTooltip

@onready var label: RichTextLabel = $RichTextLabel

var _item: IItem
var _for_text: String

func setup(for_text: String, item: IItem) -> void:
	_for_text = for_text
	_item = item

func _ready() -> void:
	label.text = "%s\n%s\n[img]%s[/img]" % [_item.name, _item.description, _item.icon.resource_path]
