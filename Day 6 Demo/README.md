The global work is being done in main. Such as when the mouse is pressed and when its released. However any logic for grabbing is in the grabber file. The main only is like a bridge for each module so they can communicate together like how the grabber has a held item attribute but to achieve that, it has to be given from main. 

The different parts of card encapsulate most of the logic of each class, such as the card having all of the logic in of cards. Grabber having the logic of grabbing, and the main just enables the connection so they can interact. The main handles all of the logic done on the entire screen. 

Not really, at first I was confused because the pressed and release logic was locked behind the grabber, but once I bridge the card from main into grabber, I was able to achieve it.

I can improve them by not handling all of grabbing logic in grabber, but have main support the connection of different code. 

I used the encapsulating of different code so it basically exhibits its behavior. Like grabber grabs, card is for cards. 