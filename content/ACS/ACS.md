---
title: Ability Component System
description: A system of plugins that perform a certain action
---
# Overview
The [[ECS]] needs to be extremely well thought and all entities need to follow a certain standard in terms of definition. Which is why the ability to perform actions was isolated as plugins for entities. Hence, the aspect of programming that the ACS is dependent on is **Containment**. Fundamentally, each Ability Component is self-contained and already has all the necessary code within it. You can segregate these components into two types:

- Active
- Dormant

The **Active** components are usually frame-triggered and hence remain in the background actively searching for an event (such as a specific animation frame) to trigger itself. Hence, these are autonomous.

The **Dormant** components on the other hand need to be manually triggered. This can be done in the [[Entity]]'s unique code.

(A full list of the used Ability Components will be shown here sometime later)