Card Art by Sylly.
https://opengameart.org/content/cards-set 

Github: https://github.com/KenshinChao/CMPM121/tree/main/Assignment%201%20Solitaire 

Some base structures by Professor Zac. Vector by Zac.

I utilized State machines for the card/piles states so that I can choose when to interact with them and the grabber. Also helped with debugging.

What I did well was starting early, it just that it was really hard to follow the code done in class and section, which stunted my progress because I felt like I shouldn't change the logic that we were given. And because of that, I'm really stuck on how to implement the placement check without being in main. If I want to check if its an invalid placement, it would require information of allowed spaces, and this is only done in main. This really took a lot of my time and made me unable to go forward so I just did whatever other logic I could do and graphics. I'm also made the card class really easy to understand, and pretty good for its drawings. I utilize the naming schematic of the card images, so I can just give it a suit and number and it would easily pick from the folder the right image. Something I've tried to do good is keeping classes modular, like having the functions all in their respective classes, and using main as a way to connect them while also making changes so that they are able to see each other. 

Something I could've done better was utilize Type Object, because I know that the deck and pile have a really similar structure. If I were to do this again I would use Type Object for the deck and card piles, as well as change more of the code that we did in class because it was demotivating and time consuming to try to find a roundabout way that worked with the way the grabber was set up or the structure of releasing and grabbing. Finding a way to put the held card into a pile while the grabber was setting held object to nil was really redundant. Because as soon as left click was let go, it'd be nil and I can't have the card be added to any table unless I reference it somehow. 



The game should work for general play. Only thing is that you cannot pick up multiple cards and you will have to drag the card you want to place over the first card in that pile/tableau.

Used https://codebeautify.org/lua-beautifier to format spacing.