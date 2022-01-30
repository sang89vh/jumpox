extends Area2D

func destroy():
	$Sprite/Tween.interpolate_property($Sprite ,"position", $Sprite.position, Vector2($Sprite.position.x + 200, $Sprite.position.y), 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Sprite/Tween.start()

func _on_VisibilityNotifier2D_screen_exited():
	$Sprite/AnimationPlayer.play("destroy")
