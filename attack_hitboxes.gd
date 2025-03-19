extends Area2D

@export var dircetion_knockback = -30;
@export var up_knockback = 100;

var ignore_hits: bool = false;

func _physics_process(delta: float) -> void:
	if self.ignore_hits:
		return;
	for b in self.get_overlapping_bodies():
		if is_instance_of(b, RigidBody2D):
			print("hit!");
			self.ignore_hits = true;
			(b as RigidBody2D).linear_velocity += (b.global_position - self.global_position).normalized() * dircetion_knockback + Vector2.UP * up_knockback;

func reset_hits():
	self.ignore_hits = false;
