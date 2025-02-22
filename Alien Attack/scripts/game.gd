extends Node2D

var lives = 3
var score = 0

var game_over_screen = preload("res://scenes/game_over_screen.tscn")
@onready var player = $player
@onready var hud = $UI/HUD
@onready var ui = $UI
@onready var enemy_hit_sound = $EnemyHitSound
@onready var player_damage_sound = $PlayerDamageSound

func _ready():
	hud.set_score_label(0)
	hud.set_lives(lives)
	
func _on_deathzone_area_entered(area):
	area.queue_free()

func _on_player_took_damage():
	lives -= 1
	player_damage_sound.play()
	hud.set_lives(lives)
	if lives == 0:
		player.die()
		
		await get_tree().create_timer(1.5).timeout
		
		var over_instance = game_over_screen.instantiate()
		over_instance.set_score(score)
		ui.add_child(over_instance)
		


func _on_enemy_spawner_enemy_spawned(enemy_instance):
	enemy_instance.connect("died", _on_enemy_died)
	add_child(enemy_instance)

func _on_enemy_died():
	score += 100
	hud.set_score_label(score)
	enemy_hit_sound.play()


func _on_enemy_spawner_path_enemy_spawned(path_enemy_instance):
	add_child(path_enemy_instance)
	path_enemy_instance.enemy.connect("died", _on_enemy_died)
	
