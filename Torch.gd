extends Node2D

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	get_node("Animation").speed_scale = rng.randf_range(0.5,1.5)

func _on_TorchFlame_body_entered(body: Node) -> void:
	print(body)
	if body is FlamePivotType:
		body.reignite()
