module sdl_load;

import scope_cleanup;
import sdl_help;

import derelict.sdl2.image;

/// Loads the SDL library and returns a RAII object that cleans up the library when destructed.
ScopeCleanup loadLibSDL()
{
	DerelictSDL2.load();
	SDL_Init(SDL_INIT_VIDEO)
	.trySDL(0, "initializing SDL", true);
	return ScopeCleanup(function void() { SDL_Quit(); });
}

/// Loads the SDL_image library and returns a RAII object that cleans up the library when destructed.
ScopeCleanup loadLibSDLImage()
{
	DerelictSDL2Image.load();
	return ScopeCleanup(function void() { IMG_Quit(); });
}
