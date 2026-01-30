class_name A11yBlocks extends TileMapLayer

static var instance : A11yBlocks
static var AccessibilityBlocks: bool = false

func _ready() -> void:
	instance = self
	SwitchBlockState()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	SwitchBlockState()
	pass

func SwitchBlockState():
	if(AccessibilityBlocks == false):
		enabled = false
		#visible = false
	else:
		enabled = true
		
