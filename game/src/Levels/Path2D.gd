extends Path2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_entered():
	print_debug("PathFollowingPlatform1 _on_VisibilityNotifier2D_screen_entered")
	$PathFollow2D/AnimationPlayer.play("Move")
	#$MovingPlatform2/Sprite/AnimationPlayer.play("rotate")
