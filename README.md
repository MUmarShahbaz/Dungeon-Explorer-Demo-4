For starters, I would like to write a message to my fellow HackClubbers who are voting on my game for flavortown:

The game is extremely complex!! I don't understand why people are giving 5/9 for technicality. So much complex structure and design was needed to create a scalable system which is frame-synced and can easily be dropped into future games for being used again and again. Please skip to the **ECS** section to understand truly how complex the code is.

AND PLEASE CHECK THE CONTROLS!!! The Tutorial Dialogue outside the castle clearly says you can open doors by **Interact**!!!

# Dungeon Explorer - Demo 4

Dungeon Explorer is my work-in-progress multiplayer dungeon exploration game. Think of Dungeons & Dragons as an Online RPG that you can play with your friends.

Since I'm slightly new to game development, it took me some time. These demos are my experiments where I learn something new that I will be able to use in the final game.

**Note: The final game will be multiplayer, not this demo**


Here's what I leared with the previous demos

- **Demo 1** : My first game ever, taught me the very basics
- **Demo 2** : Taught me advanced animations using an AnimationTree
- **Demo 3** : Helped me define a proper behaviour for my mobs.

Finally, **Demo 4** (this one) is another one of my experiments to help me reach closer to my goal.

I'm trying to build a proper and good single player game with a storyline. The focus of this demo is on game architecture, UI and the ECS (Entity Component System). without a doubt the most important part of the code which I will definitely reuse in the final version as well as other RPGs.

This project was very important in teaching me not only game development, but also how to effectively work with OOPs as the code is heavily dependant on Inheritance and Polymorphism to ensure reusable code and hence making redundance negligible.

## ECS - Entity Component System

<img width="2597" height="902" alt="Debugging Error Handling-2026-04-22-235858" src="https://github.com/user-attachments/assets/61393124-65e8-4bc3-bfb8-72c954093716" />

The ECS is an extremely fragile piece of work as it greatly depends on "Standardization", since it uses Inheritance and Polymorphism.

This means that creating such a system is only possible after a carefully thought out plan and segregation of the necessary and the arbitrary. Such a fragile system requires maintainence. This is also why you will see that I have redone the ECS from scratch multiple times as keeping it neat and organized is a challenge in itself.

You can see the hierarchy of the ECS in the image above so here's the description of each of their purposes:

- Entity: Handles Entity Stats, gravity & movement, animation functions, HP & Death
    - Enemy: Converts the entity into an enemy fighter and adds ability to Patrol and Charge
        - Boss: Reduces the enemies chances of getting interrupted by attacks
    - Civillian: Converts the entity into a civillian and adds ability to Patrol and Escape
    - Ally: Converts the entity into an ally fighter and adds ability to Patrol, Charge, Stand, Follow and Moving in Formation
        - Player: Converts the ally into a controllable character

Additionally, there is the less known ACS (**Ability Component System**), which is responsible for classifying certain unique behaviours which may or may not be used by a certain entity. Right now there is only 3 such abilities:

1. Sheild : Creates an invisible Wall
2. Melee Controller : Used to automate frame-synced damage
3. Projectile Launcher: Used to automate frame-synced projectile creation and launching. Damage is handled by the projectile itself.

Finally, each character can inherit any of the variants of an Entity and you will get all of the code. You can then overwrite to add your own unique code that's specific to this entity and use the Ability Components.

**Thank you for reading**
