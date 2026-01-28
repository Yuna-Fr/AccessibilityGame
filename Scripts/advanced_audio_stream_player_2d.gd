class_name AdvancedStreamPlayer2D
extends AudioStreamPlayer2D

@export var Sounds : Array[AudioStream]

func play_random():
	if Sounds.size():
		stream = self.Sounds.pick_random()
		play()
