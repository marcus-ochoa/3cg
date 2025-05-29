# I'm Gonna Snap (A Marvel Snap-pish 3CG game)
**CMPM121 Project**\
Marcus Ochoa

## Information
### Programming Patterns
**Update Method**\
The update method pattern is being used by the LOVE2D engine to update game logic every frame. In particular I opted to use the engine's mouse pressed, mouse released, and mouse moved events which are called using an update to dictate player input. 

**Game Loop**\
The game loop pattern is used by the LOVE2D engine to both update and draw the game each frame. This allows the game to be functional and display or render game state to the player. Within this loop a double buffer pattern is also used to accurately render the game state.

**Prototype**\
All of the "classes" used are implementations of the prototype pattern using lua tables rather than proper classes.

**Component**\
The UI classes (buttons, textboxes, card displayers) are used as components in the UI manager.

**States**\
The state pattern is used to specify card state (idle/mouse over/grabbed) and game state (menu/player turn/reveal). This enables the cards and game manager to easily be drawn differently or function differently according to state. For example, a grabbed card is drawn with a shadow while an idle card is drawn without one. And an inactive button is not drawn or able to be interacted with.

### Postmortem
I think I did well keeping all the different behaviors of the game accessible, however I did not decouple behaviors enough. I often wasn't sure whether a function should go in one class or the other, which shows that responsibility of classes was shaky at best.
