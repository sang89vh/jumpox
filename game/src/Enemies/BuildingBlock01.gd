extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func new():
	$Area2D/Tween.interpolate_property($Area2D/Sprite ,"position", $Area2D/Sprite.position, Vector2($Area2D/Sprite.position.x, $Area2D/Sprite.position.y - 400), 0.3, Tween.TRANS_QUART, Tween.EASE_IN)
	$Area2D/Tween.start()
	
	$Area2D/Tween.interpolate_property($Area2D/Sprite2 ,"position", $Area2D/Sprite2.position, Vector2($Area2D/Sprite2.position.x, $Area2D/Sprite2.position.y - 400), 0.3, Tween.TRANS_QUART, Tween.EASE_IN)
	$Area2D/Tween.start()
	
	$Area2D/Tween.interpolate_property($Area2D/Sprite3 ,"position", $Area2D/Sprite3.position, Vector2($Area2D/Sprite3.position.x, $Area2D/Sprite3.position.y - 400), 0.3, Tween.TRANS_QUART, Tween.EASE_IN)
	$Area2D/Tween.start()
	
func destroy():
	$Area2D/Tween2.interpolate_property($Area2D/Sprite ,"position", $Area2D/Sprite.position, Vector2($Area2D/Sprite.position.x + 300, $Area2D/Sprite.position.y), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Area2D/Tween2.start()
	
	$Area2D/Tween2.interpolate_property($Area2D/Sprite2 ,"position", $Area2D/Sprite2.position, Vector2($Area2D/Sprite2.position.x + 300, $Area2D/Sprite2.position.y), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Area2D/Tween2.start()
	
	$Area2D/Tween2.interpolate_property($Area2D/Sprite3 ,"position", $Area2D/Sprite3.position, Vector2($Area2D/Sprite3.position.x + 300, $Area2D/Sprite3.position.y), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Area2D/Tween2.start()

func _on_VisibilityNotifier2D_screen_entered():
	$Area2D/AnimationPlayer.play("new")


func _on_VisibilityNotifier2D2_screen_exited():
	$Area2D/AnimationPlayer.play("destroy")
