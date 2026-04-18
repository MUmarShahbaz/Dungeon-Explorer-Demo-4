@abstract
extends Resource
## A resource that is used with an extension of the [Damager] class to give the character the ability to damage otherss
class_name AttackInfo

## Name of the Animation for this attack
@export var Animation_Name : StringName
## Frame of the Animation to trigger this attack
@export var Animation_Frame : int
## Damage done by this attack
@export var Damage : float
## The SFX to start playing when damage is done
@export var SFX: NodePath
