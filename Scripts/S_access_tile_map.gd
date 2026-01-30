class_name A11yBlocks extends TileMapLayer

static var AccessibilityBlocks: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SwitchBlockState()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func SwitchBlockState():
	if(AccessibilityBlocks == false):
		enabled = false
		#visible = false
		
