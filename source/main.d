/**
Game entry point and main processing loop.
*/
module main;

import config;
import gameboard;
import sdl_help;
import textures;

void main()
{
	auto libSDL = loadLibSDL();
	auto libSDLImage = loadLibSDLImage();

	auto window = createWindow(appTitle, SDL_WINDOW_RESIZABLE, XY(800, 600));
	SDL_SetRenderDrawColor(window.render, 0x80, 0xA0, 0x60, 0xFF);

	auto board = GameBoard(window);

	auto textures = loadTexture(dirImages~"People.png", window.render);
	auto playerClip = clipTexture(textures, 2, 1);

	bool isRefreshNeeded = true;
	do
	{
		if(isRefreshNeeded)
		{
			SDL_RenderClear(window.render);
			SDL_RenderCopy(window.render, textures, &playerClip, &board.player);
			isRefreshNeeded = false;
		}
		SDL_RenderPresent(window.render); // paint scene

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
				board.onKeyPressed(input.key);
				ans = Command.refresh;
				break;

			case SDL_WINDOWEVENT:
				board.onWindowSizeChanged();
				ans = Command.refresh;
				break;
			
			default: break;
		}
	}
	return ans;
}
