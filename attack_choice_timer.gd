extends Node2D

@export var attack_action: String;
@export var attack_cooldown_timer: Timer = null;
@export var attack_combo_timer: Timer = null;
@export var charge_timer: Timer = null;

var combo_index = 0;
@export var attack_combo: Array[ChargeableAttack] = [];
var current_attack: ChargeableAttack = null;

func _physics_process(delta: float) -> void:
	var character: PlatformerPlayerBody2D = self.get_parent();
	if Input.is_action_just_released(self.attack_action):
		if !self.charge_timer.is_stopped():
			self.charge_timer.stop();
			self.complete_attack();
	
	if Input.is_action_just_pressed(self.attack_action):
		if !self.attack_cooldown_timer.is_stopped():
			return;
		if combo_index >= self.attack_combo.size():
			return;
		var attack: ChargeableAttack = self.attack_combo[combo_index];
		self.current_attack = attack;
		self.charge_timer.start(attack.charge_time);
		self.attack_combo_timer.stop();
		self.attack_combo_timer.start(attack.combo_time);
		self.attack_cooldown_timer.start(attack.cooldown_time);
		
		self.combo_index += 1;
		attack.play_primary_anim();
		
		character.velocity.y -= 300;

func attack_charged():
	self.current_attack.play_charged_anim();
	self.attack_combo_timer.stop();
	self.attack_combo_timer.start(self.current_attack.charged_combo_extension);
	self.complete_attack();

func cooldown_timer_ended():
	pass

func combo_timer_ended():
	print("combo ended");
	self.combo_index = 0;

func complete_attack():
	self.current_attack = null;
	var character: PlatformerPlayerBody2D = self.get_parent();
	character.reset_gravity_multiplier();
