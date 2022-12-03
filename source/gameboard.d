module gameboard;

public import pixel_xy;
public import sdl_help;
public import windows;

import config;

struct GameBoard
{
	SDL_Window* window;
	Rectangle player;
	private XYChangeTracker windowSize;

	@disable this();

	this(SDL_Window* window)
	{
		this.window = window;
		auto size = window.getSize();
		this.windowSize = XYChangeTracker(size);
		this.player = calcRectangleAtCenter(size, mapTileSize, mapTileSize);
	}

	void onWindowSizeChanged()
	{
		auto shift = windowSize.getChange(window.getSize())
			.divideBy(2);
		
		player.shift(shift);
	}

	void onKeyPressed(const ref SDL_KeyboardEvent key)
	{
		if(key.repeat) return; // prevent unintended multiple moves when the key is pressed longer than the event loop iterates.

		switch(key.keysym.scancode)
		{
			case SDL_SCANCODE_LEFT:
			case SDL_SCANCODE_KP_4:
			case SDL_SCANCODE_A:
				player.shiftTiles(XY(-1, 0)); return;
			case SDL_SCANCODE_RIGHT:
			case SDL_SCANCODE_KP_6:
			case SDL_SCANCODE_D:
				player.shiftTiles(XY( 1, 0)); return;
			case SDL_SCANCODE_UP:
			case SDL_SCANCODE_KP_8:
			case SDL_SCANCODE_W:
				player.shiftTiles(XY( 0,-1)); return;
			case SDL_SCANCODE_DOWN:
			case SDL_SCANCODE_KP_2:
			case SDL_SCANCODE_S:
				player.shiftTiles(XY( 0, 1)); return;
			case SDL_SCANCODE_KP_3:
				player.shiftTiles(XY( 1, 1)); return;
			case SDL_SCANCODE_KP_9:
				player.shiftTiles(XY( 1,-1)); return;
			case SDL_SCANCODE_KP_1:
				player.shiftTiles(XY(-1, 1)); return;
			case SDL_SCANCODE_KP_7:
				player.shiftTiles(XY(-1,-1)); return;
			default:
				return;
		}
	}
}

private
void shiftTiles(ref Rectangle piece, XY tileShift)
{
	piece.shift(tileShift.multiplyBy(mapTileSize));
}