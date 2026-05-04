extends Node2D

@export var slime_scene : PackedScene
@export var spawn_timer : Timer
@export var score : int = 0
@export var score_label : Label
@export var game_over_label : Label
@export var item_scene : PackedScene
@export var spawn_delay : float = 7.0   # 几秒后开始掉落
@export var spawn_interval : float = 5.0 # 之后每隔几秒掉一个

var item_types : Array = ["rapid_fire", "triple_shot"]

var screen_width : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_width = get_viewport().get_visible_rect().size.x
	await get_tree().create_timer(spawn_delay).timeout
	# 之后每隔几秒掉一个
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = spawn_interval
	timer.autostart = false
	timer.one_shot = false        # ← 确保循环触发
	timer.timeout.connect(_spawn_item)
	timer.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer.wait_time -= 0.2 * delta
	spawn_timer.wait_time = clamp(spawn_timer.wait_time,1,3)
	
	score_label.text = "score:" + str(score)


func _spawn_silme() -> void:
	var slime_node = slime_scene.instantiate()
	slime_node.position = Vector2(260 , randf_range(37,111))
	get_tree().current_scene.add_child(slime_node)

func _spawn_item() -> void:
	var item = item_scene.instantiate()
	item.item_type = item_types[randi() % item_types.size()]
	# 改成你游戏实际的X范围
	item.position = Vector2(randf_range(30, 230), -7)
	add_child(item)
	
func show_game_over():
	game_over_label.visible = true
