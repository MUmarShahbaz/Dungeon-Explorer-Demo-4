---
title: Entity Component System
description: A scalable system designed to ease the creation and usage of Entities in the game
---
# Overview

```mermaid
flowchart TB
    Entity["Entity"] --> Ally["Ally"] & Civillian["Civillian"] & Enemy["Enemy"]
    Enemy --> Boss["Boss"]
    Ally --> Player["Player"]
     Entity:::Class_1
    classDef Class_1 stroke-width:4px, stroke-dasharray:5
```

The ECS is a complex system dependent on **Object Oriented Programming**, **Inheritance** and **Polymorphism** to ensure that core aspects of each type of Entity is properly distributed. The minimizes redundancy whilst saving a lot of time that would otherwise have been used to create code for each entity individually.

The following diagram illustrates the design of the ECS:

```mermaid
flowchart TB
    Core["Core<br>(Entity)"] --> Chain["Chain of <br> Inherited Classes"] --> Unique["Unique<br>&<br>Classless"]
     Core:::Class_1
     Unique:::Class_1
    classDef Class_1 stroke-width:2px, stroke-dasharray:3
```


- The Core / Base class [[Entity]] is responsible "giving life" to an entity.
- The chain of inherited classes represent how the entire chain from [[Entity]] to the one just above the unique code for this entity. It is responsible for giving the entity an identity and determining it's behavior (such as chasing the enemy).
	- eg: if the current entity is a [[Boss]] then the chain will be:<br>-->[[Enemy]]-->[[Boss]]-->
- The lowest stage is the classless and unique code which will apply only to the current specific entity. It is responsible for determining how the behavior (such as swinging a sword) will be carried out.

# List
- [[Entity]]
	- [[Ally]]
		- [[Player]]
	- [[Civilian]]
	- [[Enemy]]
		- [[Boss]]