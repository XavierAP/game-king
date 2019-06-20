/**
Game entry point and main processing loop.
*/
module main;

import config;
import derelict.sdl2.image;
import geo;
import sdl_help;
import std.string: toStringz;

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
	SDL_Window* winMain = SDL_CreateWindow(appTitle,
		SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
		800, 600,
		0);
	scope(exit) SDL_DestroyWindow(winMain);
	SDL_Renderer* render = SDL_CreateRenderer(winMain, -1, 0);
	scope(exit) SDL_DestroyRenderer(render);
	trySDL(winMain != null && render != null, "creating main window", true);
	// Background color:
	SDL_SetRenderDrawColor(render, 0x80, 0xA0, 0x60, 0xFF);

	// Create the player icon starting at the center of the window:
	auto texPlayer = Texture(dirImages ~ "Hero.png", render);
	SDL_Rect rect = { w: mapTileSize, h: mapTileSize };
	SDL_GetWindowSize(winMain, &rect.x, &rect.y);
	rect.x = (rect.x - rect.w) / 2;
	rect.y = (rect.y - rect.h) / 2;

	// Main loop:
	do
	{
		SDL_RenderClear(render);
		SDL_RenderCopy(render, texPlayer, null, &rect);

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
					XY udelta = input.key.toMoveMap,
						delta = udelta.toGfx;
					rect.shift(delta);
					break;

				default: break;
			}
		}
		SDL_Delay(1000u/fpsMax); // don't hog the CPU
	}
	while(true);
}
