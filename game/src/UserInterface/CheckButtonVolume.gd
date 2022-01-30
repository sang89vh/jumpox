extends CheckButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
onready var au = get_parent().get_node("AudioStreamPlayer2D")
var position = 0.0

func _on_CheckButton_pressed():
	if au.playing :
		position = au.get_playback_position()
		au.stop()
		au.playing = false
	else:
		au.play(position)
		au.playing = true
