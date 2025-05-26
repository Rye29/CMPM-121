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


Feedback:
-Marcus Ochoa: 
	-saw that I saw using a "medium class" to create subclass inheritance 
         for the player and AI subclasses, suggested that I get rework it by creating
         a blank player base class and add on to it
         
        -what I did: I reworked the code so that it uses true inheritance as opposed to
         the pseudo inheritance I was doing via a medium pseudo class which in all honesty
         I barely knew how it worked

Its a tenet of good observer discipline that two observers observing the same subject should have no _ relative to each other