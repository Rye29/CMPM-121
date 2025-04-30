-Brian Hudick
-CMPM 121 UCSC Spring 2025
-Prof. Zach Emerzian
-Project 1: Solitaire

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

Postmortem:
-there was a lot of features that I couldn't make work in time:
 storing the selected card in the grabber instead of locally in draw 
 (this would crash the game anytime I tried to implement it), there's a lot
 more singletons than I'm comfortable with and maybe it would've been better
 to flyweight them as a pseudo-class. Implementing a proper draw order would definitely
 improve quality of life. Finally the deck and draw pile manipulation
 felt a bit messy, maybe I could've cleaned it up with more flyweighting because
 I primarily used flyweighting for organizing the drawings.

-However, I really like that I was able to modularize the objects (stacks, cards, and deck piles)
 as well as being able to put things together this well and have a (mostly) solid game in which
 I was able to anti-bug most of my code with more than enough contingency checks to keep the game running
 properly.