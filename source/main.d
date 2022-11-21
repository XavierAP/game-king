/**
Game entry point and main processing loop.
*/
module main;

import config;
import geo;
import textures;

void main()
{
	// Initialize SDL lib:
	DerelictSDL2.load();
	SDL_Init(SDL_INIT_VIDEO)
	.trySDL(0, "initializing SDL", true);
	scope(exit) SDL_Quit();

	// Initialize SDL_image lib:
	DerelictSDL2Image.load();
	scope(exit) IMG_Quit();
	{
		enum flagsLibImgNeed = IMG_INIT_PNG;
		auto flagsLibImgHave =
		IMG_Init(flagsLibImgNeed);
		trySDL(flagsLibImgHave & flagsLibImgNeed, flagsLibImgNeed,
			"initializing image file load engine", true);
	}

	// Create the main window and renderer:
	XY winSize = { 800, 600 };
	SDL_Window* winMain = SDL_CreateWindow(appTitle,
		SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
		winSize.x, winSize.y,
		SDL_WINDOW_RESIZABLE);
	scope(exit) SDL_DestroyWindow(winMain);
	SDL_Renderer* render = SDL_CreateRenderer(winMain, -1, 0);
	scope(exit) SDL_DestroyRenderer(render);
	trySDL(winMain != null && render != null, "creating main window", true);
	// Background color:
	SDL_SetRenderDrawColor(render, 0x80, 0xA0, 0x60, 0xFF);

	// Create the player icon starting at the center of the window:
	auto texPlayer = TextureClipbook(dirImages ~ "People.png", render, 2, 1);
	SDL_Rect rect = { w: mapTileSize, h: mapTileSize };
	SDL_GetWindowSize(winMain, &rect.x, &rect.y);
	rect.x = (rect.x - rect.w) / 2;
	rect.y = (rect.y - rect.h) / 2;

	// Main loop:
	bool update = true; // whether refresh needed
	do
	{
		if(update)
		{
			SDL_RenderClear(render);
			SDL_RenderCopy(render, texPlayer, texPlayer.clip(0,0), &rect);
			update = false;
		}

		// Scene!
		SDL_RenderPresent(render);

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
					SDL_GetWindowSize(winMain, &w, &h);
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
