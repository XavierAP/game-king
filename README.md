# game-king
Embryo of game, written in D using SDL.

I have vague ideas for a game design, but I doubt whether I won't drop this project before producing anything.
At the moment it's mostly a fun exercise of learning SDL and practicing D.

## Current features
Move your "Hero.png" image with the numpad keys (or arrows or WASD).

## Requirements and dependencies
- Image file "Hero.png"
located in a subfolder "img" from where the game is run from.
File's not included atm, provide your own -- modding yay. :)
If the file's not found, an error will be output to the debug/error standard output,
and the image will be missing and not drawn, so it'll look like the game does nothing.

Library dependencies:
- [SDL](https://www.libsdl.org/download-2.0.php)
- [SDL_image](https://www.libsdl.org/projects/SDL_image/)
