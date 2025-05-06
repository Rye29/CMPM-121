-Brian Hudick
-CMPM 121 UCSC Spring 2025
-Prof. Zach Emerzian
-Project 2: Better Solitaire

Credits:
-Card.lua, Vector.lua, Graber.lua
  -originally created by Prof Zach Emerzian, modified by Brian Hudick for project use
-used a stack overflow page to help construct the deck shuffle function: https://stackoverflow.com/questions/35572435/how-do-you-do-the-fisher-yates-shuffle-in-lua
-assets folder
  -diamond suit jpeg: https://www.vecteezy.com/png/12227441-playing-card-suit-symbol-diamonds
  -spade suit jpeg: https://www.vecteezy.com/png/12227439-playing-card-suit-symbol-spades
  -club suit jpeg: https://creazilla.com/media/icon/3208104/cards-club
  -heart suit jpeg: https://www.bing.com/images/search?view=detailV2&ccid=XB5%2FeIL6&id=B276CB2DBEE20DEFF208905BCFCD029483F07CDB&thid=OIP.XB5_eIL6_yUG3GQtW81srAHaHs&mediaurl=https%3A%2F%2Fwww.seekpng.com%2Fpng%2Ffull%2F0-5179_play-png.png&cdnurl=https%3A%2F%2Fth.bing.com%2Fth%2Fid%2FR.5c1e7f7882faff2506dc642d5bcd6cac%3Frik%3D23zwg5QCzc9bkA%26pid%3DImgRaw%26r%3D0&exph=706&expw=680&q=heart+png+transparent+playing+card&simid=608035815328849686&form=IRPRST&ck=AED5E29CF77894EAD58CA5BC7A2F3F76&selectedindex=1&itb=1&cw=1375&ch=664&ajaxhist=0&ajaxserp=0&vt=2&sim=11
(sorry, bing wasn't being cooperative)

-all other assets and code were created by me

Programming patterns:
-I'm currently using the update pattern because card movement needs to be polled overtime, 
-the singleton pattern is in effect for the card_list, deck, and various other structures that stores 
 all instances of the cards as well as table deck which stores the deck pile
-state pattern is being used to track which card is being grabbed and whether or not the card can be grabbed
-I'm using the flyweight class to store the draw data for each card inside 
 each card and stack instance (and also the object pattern to actually make everything possible to track)

Updated patterns:
-Observer pattern: I implemented a simple observer pattern as detailed by the class textbook in order to detect when the player has won
-flyweight data: fixed old flyweight pattern as it turned out it wasn't actually sharing the suite image assets like I thought it was
-Subclass (but not really): I created a subclass for already existing suite piles (functionally speaking) to ensure that the tableau
functions properly and adheres to the rules. It was originally intended to be a true subclass, but on paper it functions as more of a state

Postmortem:
-When compared to the last project, a decent amount has been added and improved:
    -the grabber now stores the grabbed object locally in a table and pops the cards in
     and out based on input
    -cards can now be stacked on top of each other so long as they adhere to standard rules
    -cards have a parent/child system in which children use to copy parent locations
    -child parent system allows for snapping cards to each other
    -render order for the cards has been implemented, and goes in the order of:
     face down cards -> face up cards -> ranks high to low -> grabbed card
    -the reset button can reset the card game into the starting game state

-However there's some things I didn't like that still made its way in:
    -almost everything that has to do with validation checks is crammed into the release function
     and isn't very easy to extend
    -still too many singletons, even though I was able to reduce them, it probably would've been better to
     combine them into one tracker table with different sub-tables but that likely wouldn't be fixing the
     underlying issue of the singletons eating up memory
    -more of a personal note but I kept using the word "flyweight" in the previous readme when in reality,
     that likely would've only caused even more issues since flyweight classes need to have something in common
     to be efficient such as meshes and textures

-Code review summaries:
  -Isaac Kim: -liked that I was able to separate the functionality to other files and keep main.lua relatively clean
              -suggested that I redo the suite system via enumeration as opposed to a string, and that release() 
               be broken into more helper functions
              -however, he acknowledged that it might be too late to do a complete overhaul of the release function,
               so I added in more comments to make it more readable

