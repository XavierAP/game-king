/**
Functions and types related to the game map and locations.
*/
module geo;
pure:

import config;
import sdl_help;

/// Translates from map to screen coordinates.
XY toGfx(const ref XY tiles)
{
	return XY( tiles.x * mapTileSize , tiles.y * mapTileSize );
}

/// Translates a keyboard press into a unit map move
/// or returns 0,0 if they key is not related to moving.
XY toMoveMap(const ref SDL_KeyboardEvent key)
{
	enum zero = XY(0,0);
	if(key.repeat) return zero; // prevent unintended multiple moves when the key is pressed longer than the event loop iterates.

	switch(key.keysym.scancode)
	{
		case SDL_SCANCODE_LEFT:
		case SDL_SCANCODE_KP_4:
		case SDL_SCANCODE_A:
			return XY(-1, 0 );
		case SDL_SCANCODE_RIGHT:
		case SDL_SCANCODE_KP_6:
		case SDL_SCANCODE_D:
			return XY( 1, 0 );
		case SDL_SCANCODE_UP:
		case SDL_SCANCODE_KP_8:
		case SDL_SCANCODE_W:
			return XY( 0,-1 );
		case SDL_SCANCODE_DOWN:
		case SDL_SCANCODE_KP_2:
		case SDL_SCANCODE_S:
			return XY( 0, 1 );
		case SDL_SCANCODE_KP_3:
			return XY( 1, 1 );
		case SDL_SCANCODE_KP_9:
			return XY( 1,-1 );
		case SDL_SCANCODE_KP_1:
			return XY(-1, 1 );
		case SDL_SCANCODE_KP_7:
			return XY(-1,-1 );
		default:
			return zero;
	}
}