/**
Game entry point and main processing loop.
*/
module main;

import config;
import geo;
import sdl_help;
import textures;
import windows;

void main()
{
	auto libSDL = loadLibSDL();
	auto libSDLImage = loadLibSDLImage();

	GameBoard board = { window: createWindow(appTitle, SDL_WINDOW_RESIZABLE, XY(800, 600)) };

	SDL_SetRenderDrawColor(board.window.render, 0x80, 0xA0, 0x60, 0xFF);

	auto textures = loadTexture(dirImages~"People.png", board.window.render);
	auto playerClip = clipTexture(textures, 2, 1);
	board.player = calcRectangleAtCenter(board.window.getWindowSize(), mapTileSize, mapTileSize);

	// Main loop:
	bool isRefreshNeeded = true;
	do
	{
		if(isRefreshNeeded)
		{
			SDL_RenderClear(board.window.render);
			SDL_RenderCopy(board.window.render, textures, &playerClip, &board.player);
			isRefreshNeeded = false;
		}
		SDL_RenderPresent(board.window.render); // paint scene

		switch(processEvents(board))
		{
			case Command.quit: return;
			case Command.refresh: isRefreshNeeded = true; break;
			default: break;
		}
		SDL_Delay(1000u/fpsMax); // don't hog the CPU
	}
	while(true);
}

private
struct GameBoard
{
	WindowResources window;
	Rectangle player;
}

private
enum Command
{
	nothing,
	refresh,
	quit,
}

private
Command processEvents(ref GameBoard board)
{
	auto ans = Command.nothing;
	SDL_Event input;
	while(SDL_PollEvent(&input))
	{
		switch(input.type)
		{
			case SDL_QUIT: return Command.quit;
			
			case SDL_KEYDOWN:
				const XY
					udelta = input.key.toMoveMap(),
					delta = udelta.toGfx();
				board.player.shift(delta);
				ans = Command.refresh;
				break;

			case SDL_WINDOWEVENT:
				board.player.shift(board.window.getWindowSizeChange().divideBy(2));
				ans = Command.refresh;
				break;
			
			default: break;
		}
	}
	return ans;
}
