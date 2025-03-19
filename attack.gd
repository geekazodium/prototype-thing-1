extends Node2D
class_name ChargeableAttack

@export var combo_time: float = 0;
@export var cooldown_time: float = 0;
@export var charge_time: float = 0;
@export var charged_combo_extension: float = 0;

@export var animation_player: AnimationPlayer = null;

@export var animation_name: String = "";
@export var charged_animation_name: String = "";

func play_primary_anim():
	print("attack! "+ self.name);
	self.animation_player.play(self.animation_name);

func play_charged_anim():
	print("charged attack! "+ self.name);
	self.animation_player.play(self.charged_animation_name);
