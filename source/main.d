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
	loadSDL().expectEqual(sdlSupport, "initializing SDL", true);
	loadSDLImage().expectEqual(sdlImageSupport, "initializing SDL_image library", true);

	XY winSize = { 800, 600 };

	auto mainWindow = createWindow(appTitle, SDL_WINDOW_RESIZABLE, winSize);
	
	// Background color:
	SDL_SetRenderDrawColor(mainWindow.renderer, 0x80, 0xA0, 0x60, 0xFF);

	// Create the player icon starting at the center of the window:
	auto texPlayer = TextureClipbook(dirImages ~ "People.png", mainWindow.renderer, 2, 1);
	SDL_Rect rect = { w: mapTileSize, h: mapTileSize };
	SDL_GetWindowSize(mainWindow.window, &rect.x, &rect.y);
	rect.x = (rect.x - rect.w) / 2;
	rect.y = (rect.y - rect.h) / 2;

	// Main loop:
	bool update = true; // whether refresh needed
	do
	{
		if(update)
		{
			SDL_RenderClear(mainWindow.renderer);
			SDL_RenderCopy(mainWindow.renderer, texPlayer, texPlayer.clip(0,0), &rect);
			update = false;
		}

		// Scene!
		SDL_RenderPresent(mainWindow.renderer);

		// Process input:
		SDL_Event input;
		while(SDL_PollEvent(&input))
		{
			switch(input.type)
			{
				case SDL_QUIT: return;
				
				case SDL_KEYDOWN:
					update = true;
					const XY
						udelta = input.key.toMoveMap,
						delta = udelta.toGfx;
					rect.shift(delta);
					break;

				case SDL_WINDOWEVENT:
					update = true;
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
