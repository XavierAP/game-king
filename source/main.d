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

	XY winSize = { 800, 600 };
	auto mainWindow = createWindow(appTitle, SDL_WINDOW_RESIZABLE, winSize);
	SDL_SetRenderDrawColor(mainWindow.render, 0x80, 0xA0, 0x60, 0xFF);

	auto textures = loadTexture(dirImages~"People.png", mainWindow.render);

	auto playerClip = clipTexture(textures, 2, 1);

	SDL_Rect rect = { w: mapTileSize, h: mapTileSize };
	SDL_GetWindowSize(mainWindow.window, &rect.x, &rect.y);
	rect.x = (rect.x - rect.w) / 2;
	rect.y = (rect.y - rect.h) / 2;

	// Main loop:
	bool isRefreshNeeded = true;
	do
	{
		if(isRefreshNeeded)
		{
			SDL_RenderClear(mainWindow.render);
			SDL_RenderCopy(mainWindow.render, textures, &playerClip, &rect);
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
					rect.shift(delta);
					break;

				case SDL_WINDOWEVENT:
					isRefreshNeeded = true;
					// Re-center the image:
					int w, h;
					SDL_GetWindowSize(mainWindow.window, &w, &h);
					rect.x += (w - winSize.x) / 2;
					rect.y += (h - winSize.y) / 2;
					winSize = XY(w, h);
					break;
				
				default: break;
			}
		}
		SDL_Delay(1000u/fpsMax); // don't hog the CPU
	}
	while(true);
}
