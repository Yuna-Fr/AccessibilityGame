class_name AdvancedAudioStreamPlayer2D
extends AudioStreamPlayer2D

@export var Sounds : Array[AudioStream]
@export var loop : bool = false

func play_random():
	if Sounds.size():
		stream = self.Sounds.pick_random()
		play()

func _on_finished() -> void: # LOOP AUDIO
	if Sounds.size() > 0:
		play_random()
	elif stream != null:
		play()
