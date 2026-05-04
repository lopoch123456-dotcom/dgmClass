extends Area2D

@export var slimeSpeed : float = -100
# Called every frame. 'delta' is the elapsed time since the previous frame.
var is_dead : bool = false

func _process(delta: float) -> void:
	if not is_dead:
		position += Vector2(slimeSpeed , 0) * delta
		
	if position.x < -267:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not is_dead:
		body.gameOver()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		$AnimatedSprite2D.play("death")
		is_dead = true
		area.queue_free()
		get_tree().current_scene.score += 1
		$DeadAudio.play()
		await get_tree().create_timer(0.6).timeout
		queue_free()
