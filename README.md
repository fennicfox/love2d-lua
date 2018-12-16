# LÖVE 2D / LUA Workshop

I use this respository for future reference of useful code I have created. The idea of this is to generally learn and mess around in the LÖVE 2D 11.0 engine as well. 

## Practice Game

I'm practicing developing mock games like this one here. In this game, I have a level editor where I can create a level and save it to a file. The levels can then be played in the actual game itself. I plan to make the level editor quite complex and put in as much utility as possible as I'm learning quite a lot from it. I am learning how to create simple and fluid interaction with the application so it's easy to use. I'm learning also learning a lot about 2D vectors and the typical problems you will face with them. For example, you have to consider scaling the UI to different window sizes / resolution. It's quite satisfying to get level editor view interaction working. I've learnt how to zoom, pan and even scroll. I also implemented discord rich presence. Discord is a VoIP application designed for the gaming community. Every 2 seconds, my game alerts discord how many deaths I have and displays it to my friends. A lot can be done with this API, for example, friends quickly joining, spectating or viewing the state that a player is in. This can be a really useful tool for people to use, it looks professional and can even advertise your game.

### Level Editor

![Alt Text](https://media.giphy.com/media/5nvUszACUc4SVw4dMT/giphy.gif)

### Picking Level

![Alt Text](https://media.giphy.com/media/55kujmAtxV1H08io1y/giphy.gif)

### Playing State

![Alt Text](https://media.giphy.com/media/euCvFMpcEvAq3Bys7x/giphy.gif)

### Discord RPC

![Alt Text](https://i.gyazo.com/23270601dfd5bde618faa1f3314fa338.png)


## Agario rip off

This little mock creation was based on the game [agar.io](http://agar.io/). Unlike Agar.io, it has a procedurally generated world with endless food. This doesn't have online,  or other players, I'm just interested in learning how to create this type of game for experience.

![Alt Text](https://media.giphy.com/media/QLRHAHDiy9634sCYiH/giphy.gif)

## Fading text

A cool fading text effect which transitions to different colours. This could be useful for different games. Again, I'm just learning the language, so I'm just sticking to small ideas.

![Alt Text](https://media.giphy.com/media/1xOyI9xMWaNr7g2z5J/giphy.gif)

## Shaders

Shaders are strange and I'm struggling how to use them. LÖVE 2D shadres are written in GLSL which is the (OpenGL Shading Language).

### Lighting

I created this simple lighting engine with [phong's shading algorithm](https://mrl.nyu.edu/~perlin/courses/fall2005ugrad/phong.html). The rays of light casted past the object was made with gradients.

![Alt Text](https://i.gyazo.com/721a1d6f27c8ceab619f5b3ea13af06b.gif)

In the top left, this is a light but it doesn't stick to the player. When I navigate the player around the object, you can see where the light rays should be.

### Squares shaders

These are purple drawn squares, however, every single square (apart from the top left) has a shader applied to it. 

![Alt Text](https://i.gyazo.com/a4ec582719272d3ea388eb04a63fbbf6.png)

The bottom-middle shaders has a film grain shader applied to it but you can't tell the difference because the picture shown above is a .png, not a .gif.

## Typing

I created my own typing system from scratch. It's a lot more tedious than I thought, but is still interesting to understand the mechanics behind selection and cursors. Now I know how it works behind the scenes, (or at least how I've made it work,) I won't be reinventing the wheel again.

![Alt Text](https://i.gyazo.com/2ddb42736ab8efc2aba52dff3366329d.gif)