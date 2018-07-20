# LÖVE 2D / LUA Workshop

I use this respository for some concepts I mess around with in the LÖVE 2D 11.0

## Practice Game
I'm practicing developing mock games like this one I have created here. In this game, I have a level editor, where I can create a level and play it. The levels also save to a file so whenever I close the game, it isn't lost. I plan to create the level editor quite complex as I'm learning quite a lot from it. I am learning how to create simple, fluid interaction with the application and trying to implement a lot of utility. On top of this, I'm learning a lot about 2D vectors and learning how to scale UI to different window sizes. It's quite satisfying to get simple level editor view navigation working like zooming, panning, grid locks and the actual visualised grids itself.
### Level Editor:
![Alt Text](https://media.giphy.com/media/5nvUszACUc4SVw4dMT/giphy.gif)

### Picking Level:
![Alt Text](https://media.giphy.com/media/55kujmAtxV1H08io1y/giphy.gif)

### Playing State:
![Alt Text](https://media.giphy.com/media/euCvFMpcEvAq3Bys7x/giphy.gif)

## Agario rip off
This little mock creation was based on the game [agar.io](http://agar.io/). Procedurally generated word with endless food. Not online, no other players, I'm just interested in learning this language.

![Alt Text](https://media.giphy.com/media/QLRHAHDiy9634sCYiH/giphy.gif)

## Fading text
Cool fading text effect which transitions to different colours. This could be useful for different games. Again, I'm just learning the language.

![Alt Text](https://media.giphy.com/media/3kxa2lBohzEZ1WTgYi/giphy.gif)

## Shaders
Shaders are strange and I'm struggling how to use them. LÖVE 2D are written in GLSL which is the (OpenGL Shading Language).

### Lighting
I'm struggling creating lighting in LÖVE 2D but I produced this work relatively quickly. I need to research this more.

![Alt Text](https://media.giphy.com/media/8YvGIi2JlpiWXISg70/giphy.gif)

In the top left, this is a light but it doesn't stick to the player. When I navigate the player around the object, you can see where the light rays should be.

### Squares shaders
These are purple drawn squares, however, every single square (apart from the top left) has a shader applied to it. 

![Alt Text](https://i.gyazo.com/a4ec582719272d3ea388eb04a63fbbf6.png)

The middle bottom shaders has a film grain shader applied to it but you can't tell the difference because it's a .png not a .gif