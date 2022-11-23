module sdl_load;

import scope_cleanup;
import sdl_help;

import derelict.sdl2.image;

/// Loads the SDL library and returns a RAII object that cleans up the library when destructed.
ScopeCleanup loadLibSDL()
{
	DerelictSDL2.load();
	SDL_Init(SDL_INIT_VIDEO)
		.expectFromSDLEqual(0, "initializing SDL", true);
	return ScopeCleanup(wrapAsFunction!SDL_Quit);
}

/// Loads the SDL_image library and returns a RAII object that cleans up the library when destructed.
ScopeCleanup loadLibSDLImage(int IMG_INIT_enum)
{
	DerelictSDL2Image.load();

	alias requestedFlags = IMG_INIT_enum;
	auto supportedFlags = IMG_Init(IMG_INIT_enum);
	expectFromSDLEqual(supportedFlags & requestedFlags, requestedFlags,
		"initializing image file load engine", true);
	
	return ScopeCleanup(wrapAsFunction!IMG_Quit);
}
