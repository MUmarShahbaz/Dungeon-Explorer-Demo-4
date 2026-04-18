extends Damager
## An animation triggered Auto-Launcher for shooting [Projectile]
class_name ProjectileLauncher

func attack(projectile_attack : AttackInfo):
	var new_projectile : Projectile = projectile_attack.Projectile_Scene.instantiate()
	new_projectile.global_position = parent.global_position + Vector2(projectile_attack.Spawn_Offset.x * parent.facing, projectile_attack.Spawn_Offset.y)
	new_projectile.direction = parent.facing
	new_projectile.launched_by = parent
	@warning_ignore("narrowing_conversion")
	new_projectile.damage *= multiplier
	get_tree().get_current_scene().add_child(new_projectile)
	await parent.await_frame(projectile_attack.Animation_Name, projectile_attack.Launch_Frame)
	if new_projectile:
		var sfx_player : AudioStreamPlayer2D = get_node_or_null(projectile_attack.SFX)
		if sfx_player: sfx_player.play()
		new_projectile.launch(projectile_attack.Force)

func get_avg_damage():
	var sum_damages : float = 0
	for this_attack : ProjectileAttack in Move_List:
		var temp_projectile : Projectile = this_attack.Projectile_Scene.instantiate()
		sum_damages += temp_projectile.damage
		temp_projectile.queue_free()
	return int(sum_damages / Move_List.size())
