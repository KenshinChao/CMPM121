Programming Patterns Used
Component Pattern: Cards have attributes and effects as components, it helped me make them easily customizable. 

State Pattern: Managed game phases like "player," "AI," and "reveal" to separate logic and improve readability.

Command Pattern: Actions like playerSubmit() and aiSubmit() are encapsulated, making the flow modular and extendable.

Observer Pattern: Game and players interact through events, such as the player drawing cards or triggering effects. Making it easier to flag what should happen at certain phases.

Singleton Pattern: The Game object is a singleton, ensuring one instance of the game logic.

Factory Pattern: Cards are created using Card:new() for flexibility in adding new types without modifying code.

Strategy Pattern: Cards have different behaviors (effects) that are dynamically applied during gameplay.

Feedback & Adjustments (from last code review)
Person 1 (Marcus Ochoa): Suggested better state management.
Adjustment: Implemented more explicit state machine transitions.

Person 2 (Dilbert Iraheta): Recommended object-oriented practices for cleaner code.
Adjustment: Used the factory pattern and encapsulated card behaviors. (made a base and added from another file the effects etc.) 

Person 3: Suggested decentralizing the main functions.
Adjustment: Categorized more functions to their respective files that are related to the class. 

I think I did well in separating the logic like a graph. The players turn, round starts, ai places, reveal, end. I think that it made the code more managable, readable, and easier to code as I went on. If there was something wrong in one of those phases, I can look at the specific phase function and figure it out. I also tried making more smaller functions so that It can be more readable and condensed, like player:drawCard instead of making a table.insert call. If I could do it all over again I'd probably make more smaller functions and add pictures.


