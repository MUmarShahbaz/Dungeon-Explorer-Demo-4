extends Damager
## Gives the entity the ability to use Melee Attacks
class_name MeleeController

func attack(melee_attack : AttackInfo):
	super.attack(melee_attack)
	(get_node_or_null(melee_attack.Damage_Zone) as DamageZone).damage_all(melee_attack.Damage*multiplier)
