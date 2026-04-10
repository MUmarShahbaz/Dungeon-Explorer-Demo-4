# Dungeon Explorer - Demo 4

Dungeon Explorer is my work-in-progress multiplayer dungeon exploration game. Think of Dungeons & Dragons as an Online RPG that you can play with your friends.

Since I'm slightly new to game development, it took me some time. These demos are my experiments where I learn something new that I will be able to use in the final game.


Here's what I leared with the previous demos

- **Demo 1** : My first game ever, taught me the very basics
- **Demo 2** : Taught me advanced animations using an AnimationTree
- **Demo 3** : Helped me define a proper behaviour for my mobs.

Finally, **Demo 4** (this one) is another one of my experiments to help me reach closer to my goal.

I'm trying to build a proper and good single player game with a storyline. The focus of this demo is on game architecture, UI and the ECS (Entity Component System). without a doubt the most important part of the code which I will definitely reuse in the final version as well as other RPGs.

This project was very important in teaching me not only game development, but also how to effectively work with OOPs as the code is heavily dependant on Inheritance and Polymorphism to ensure reusable code and hence making redundance negligible.

## ECS - Entity Component System

<img width="2687" height="2256" alt="Debugging Error Handling-2026-04-10-012019" src="https://github.com/user-attachments/assets/332e97e1-64e3-419e-8bf5-e78c35303375" />


The ECS contains 2 types of nodes:
1. Controller : This defines behavior
2. Entity : The entity itself

The entity side is also divided into 2 further sections. Base and Classifiers. The base class contains all the important logic regarding HP and Basic actions such as moving around. The classifier classes divide entities inside the game between good and bad. It's there to "Classify/Identify" the entities.

Finally, each character can inherit any of the classifiers and you will get all of the code. Additionally, you can overwrite to add your own unique code that's specific to this entity.

**Thank you for reading**
