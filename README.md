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

**Singleton**\
There is only one instance of the board class which is referenced and updated by the other classes freely. This allows for one central access point to read or write to the current state of the game.

### Feedback
**Tapesh Sankaran**\
Felt that my project was generally well modularized and in somewhat scalable. Suggested that my code could use more comments, especially in less intuitive areas. Also suggested removing remaining developer code. Noticed many seemingly arbitrary values being used for various objects such as window size or color values, and suggested turning these into constants for more robust use and better readability. Given this feedback, I added more comments and defined many of the reused game values as constants.

### Postmortem
I think I did well keeping all the functionalities of the game accessible, however I did not decouple behaviors enough. I often wasn't sure whether a function should go in one class or the other, showing that the responsibilities of classes were shaky at best. Classes were ultimately too accessible for my liking and took on more responsibilities than they should have. By making classes such as card collections that were more generic, I allowed for better abstracted interfacing at the cost of making functionality harder to individualize for different use cases. In the last solitaire project, I opted to use subclassing and overridable interface methods to apply individual functionality while keeping a more generic interface. This time I challenged myself to try reducing the game to its generic functionalities of holding cards in collections, moving cards between them, and adjusting card states and values. Ultimately this made performing simple operations more difficult since I had to spell them out more often using the generic functions, however it also made functionality much more transparent. Having generic collections allowed me to make generic card displayers and consolidate most of the actual game logic in the game manager and board classes (however I could have still better consolidated). Generally I believe I handled grabbing and moving cards significantly better in this project through the use of a card displayer class which handles the interactivity logic. Another key thing I could add is an observer pattern to broadcast game state changes to the rest of the game. This way there is less dependency of classes on the game manager. Overall, I felt I tried a different approach in this project relative to the last and have learned from the consequences.
