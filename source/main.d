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

	auto mainWindow = createWindow(appTitle, SDL_WINDOW_RESIZABLE, XY(800, 600));
	SDL_SetRenderDrawColor(mainWindow.render, 0x80, 0xA0, 0x60, 0xFF);

	auto textures = loadTexture(dirImages~"People.png", mainWindow.render);
	auto playerClip = clipTexture(textures, 2, 1);
	auto windowSize  = getWindowSize(mainWindow);
	auto playerRectangle = calcRectangleAtCenter(windowSize, mapTileSize, mapTileSize);

	// Main loop:
	bool isRefreshNeeded = true;
	do
	{
		if(isRefreshNeeded)
		{
			SDL_RenderClear(mainWindow.render);
			SDL_RenderCopy(mainWindow.render, textures, &playerClip, &playerRectangle);
			isRefreshNeeded = false;
		}

		// Scene!
		SDL_RenderPresent(mainWindow.render);

		// Process input:
		SDL_Event input;
		while(SDL_PollEvent(&input))
		{
			switch(input.type)
			{
				case SDL_QUIT: return;
				
				case SDL_KEYDOWN:
					isRefreshNeeded = true;
					const XY
						udelta = input.key.toMoveMap,
						delta = udelta.toGfx;
					playerRectangle.shift(delta);
					break;

				case SDL_WINDOWEVENT:
					isRefreshNeeded = true;
					// Re-center the image:
					auto newSize = getWindowSize(mainWindow);
					playerRectangle.x += (newSize.x - windowSize.x) / 2;
					playerRectangle.y += (newSize.y - windowSize.y) / 2;
					windowSize = newSize;
					break;
				
				default: break;
			}
		}
		SDL_Delay(1000u/fpsMax); // don't hog the CPU
	}
	while(true);
}
