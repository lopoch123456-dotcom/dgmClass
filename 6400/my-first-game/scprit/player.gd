extends CharacterBody2D

@export var moveSpeed : float = 50
# Called when the node enters the scene tree for the first time.
@export var animator : AnimatedSprite2D

@export var is_game_over : bool = false

@export var bullet_scene : PackedScene

@export var fire_rate : float = 0.3

var fire_timer : float = 0.0

#item i add can be more

var has_rapid_fire : bool = false   # 速射
var has_triple_shot : bool = false  # 三连发

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if velocity == Vector2.ZERO or is_game_over:
		$RunningAuido.stop()
	elif not $RunningAuido.playing:
		$RunningAuido.play()
	fire_timer -= delta
	if fire_timer <= 0.0:
		fire_timer = fire_rate
		_on_fire()

func _get_fire_rate() -> float:
	if has_rapid_fire:
		return fire_rate * 0.4  # 速射：射速提升到2.5倍
	return fire_rate

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
	if is_game_over or velocity != Vector2.ZERO:
		return
	$FireAuido.play()
	
	if has_triple_shot:
		_spawn_bullet(Vector2(10, 0))    # 中间
		_spawn_bullet(Vector2(10, -15)) # 上方
		_spawn_bullet(Vector2(10, 15))  # 下方
	else:
		_spawn_bullet(Vector2(10, 2))

func _spawn_bullet(offset: Vector2) -> void:
	var bullet_node = bullet_scene.instantiate()
	bullet_node.position = position + offset
	get_owner().add_child(bullet_node)

# 拾取道具时调用这个函数
func pick_up(item_type: String) -> void:
	match item_type:
		"rapid_fire":
			has_rapid_fire = true
		"triple_shot":
			has_triple_shot = true
