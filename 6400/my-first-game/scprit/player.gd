extends CharacterBody2D

@export var moveSpeed : float = 50
# Called when the node enters the scene tree for the first time.
@export var animator : AnimatedSprite2D

@export var is_game_over : bool = false

@export var bullet_scene : PackedScene
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if velocity == Vector2.ZERO or is_game_over:
		$RunningAuido.stop()
	elif not $RunningAuido.playing:
		$RunningAuido.play()
	

func _physics_process(delta: float) -> void:
	if not is_game_over:
		velocity = Input.get_vector("left" , "right" , "up" , "down") * moveSpeed
		#if speed is zero play defunt animation
		if velocity == Vector2.ZERO:
			animator.play("idle")
		else:
			animator.play("run")#if speed is not zero play runing animation
		move_and_slide()
	
func gameOver():
	if not is_game_over:
		is_game_over = true
		animator.play("game_over")
		get_tree().current_scene.show_game_over()
		$DeadAuido.play()
		await get_tree().create_timer(3).timeout
		get_tree().reload_current_scene()


func _on_fire() -> void:
	if velocity != Vector2.ZERO or is_game_over:
		return
	$FireAuido.play()
	var bullet_node = bullet_scene.instantiate()
	bullet_node.position = position + Vector2(10,2)
	get_tree().current_scene.add_child(bullet_node)
