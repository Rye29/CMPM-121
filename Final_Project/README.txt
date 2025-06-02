-Brian Hudick
-CMPM 121 UCSC Spring 2025
-Prof. Zach Emerzian
-Project 3: Casual Card Game
-Card Game Name: Challengers of Athens

Credits:
-Card.lua, Vector.lua, Graber.lua
  -originally created by Prof Zach Emerzian, modified by Brian Hudick for project use
-used a stack overflow page to help construct the deck shuffle function: https://stackoverflow.com/questions/35572435/how-do-you-do-the-fisher-yates-shuffle-in-lua
-all other assets and code were created by me


How the game works:
-2 players are created: a user and an ai, they can either stage up to 4 cards from their hand or put up to 7 cards in said hand
-drawing cards is done automatically at the beginning of each turn, or when a card ability states it is okay to do so.
 a player cannot draw with a full hand so the action is skipped if this is the case. 
-the staging phase allows players to put cards into the stage where they can be used in battle in the action phase
-a user successfully stages by putting cards that have a collective cost less than or equal to their mana stock and hitting the "play" button
-a card can only be staged if the total cost of all cards on stage is less than the player's mana stock which increases by one each cycle
-action phase evaluates the power of each card and then increases or decreases the powers of itself or other cards accoring to
 its abilities (standard units do nothing)
-whoever has the most overall power gains points that is based on the difference in power: a faceoff of 12 vs 8 power results in 4 points for the winner
-Players can put cards back into their hand after the action phase is completed, they can discard them, or put them back into the deck
 either way, the stage should be empty at the end of each cycle

controls:
-player can grab card from hand (lower slots) or stage (upper slots) with Mouse Button 1 and drag them between the two, auto snapping is enabled
-you can also place cards from hand/stage into the deck or discard piles
Major Patterns used:
-prototype: although this probably isn't how the extra credit wants me to read from another file for cards, this was still a good way IMO to implement new cards.
 at load time, card prototypes are created in a table in a seperate lua file and then passed into main using the "require" feature of lua/love2d. These basic blueprints
 are then cloned and put into each players' deck at the program's request at loadtime. 
-subclass: the player baseclass establishes some common behaviors and components that any player would need such as validating the staged cards, drawing the card to
the hand, rendering cards and boards, and so on. The AI subclass contains a bunch of integer based inputs to make easier to control while the user subclass contains a
grabber class which is used for board manipulation
-Observer: the game manager actually acts as an observer class as part of its functionality. It implants a tracker into each player in the game, that tracker has functionality
 like changing who's turn it is and can be called by each player when appropriate. For example, if a player's hand is staged and they try to play it, the function that handles
 staged hand validation can send out a notification to the game manager to switch over to the other player and disabling the first players controls
-states: the game manager uses a state in order to determine who's turn it is
-event queue: in order to execute the turns and flipping, the game appends to an event queue inside the game manager at runtime and allows
 waiting between events. The queue waits for the player turn to go from false to nil, this indicates that the player and ai have finished staging
 their cards
-singleton: all the prototypes for cards were stored as singletons "vanillaIntel" and "cardIntel" respectively where vanilla cards were stored in vanillaintel and cards with abilities were stored in cardintel

Feedback:
-Marcus Ochoa: 
	-saw that I saw using a "medium class" to create subclass inheritance 
         for the player and AI subclasses, suggested that I get rework it by creating
         a blank player base class and add on to it
         
        -what I did: I reworked the code so that it uses true inheritance as opposed to
         the pseudo inheritance I was doing via a medium pseudo class which in all honesty
         I barely knew how it worked

Post Mortem:
	-the only thing I would change is probably the grabber class if I had time, because I made
	 the same mistake I did during solitaire 2 and didn't have enough time to refactor it again
	-the game manager could be a lot cleaner, however due to time constrictions and deadlines,
	 this was the cleanest I could do
	-I could definitely clean out the main function and reimplement some of the draw logic inside gamemanager.lua
	-string comparisons, lot of those, would need to refactor that for true extendability

Final Statement:
	-I felt that there was not nearly enough time to polish this, as there were multiple issues
	 with Lua/love2D itself that definitely would have stopped me from completing this on time had I not
	 designed the game on paper prior to this. However, most everything is built dynamically and easy 
	 to append to, with the exception of modifying core game loop behavior, as it is not meant to be
	 dynamic, it is meant to be simple.