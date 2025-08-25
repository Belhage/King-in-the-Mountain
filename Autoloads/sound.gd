extends Node

@onready var sfx: AudioStreamPlayer = $SFX

var game_muted : bool = false

func play_drill() :
	if not game_muted :
		if not sfx.playing :
			sfx.playing = true
		#sfx.play()

func stop_drill() :
	sfx.stop()
