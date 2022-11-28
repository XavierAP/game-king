module windows;

import scope_cleanup;
import sdl_help;
import xy;

WindowResources createWindow(string title, SDL_WindowFlags flags, XY size,
	XY position = XY(SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED))
{
	auto window = SDL_CreateWindow(title.ptr, position.x, position.y, size.x, size.y, flags);
	auto renderer = SDL_CreateRenderer(window, -1, 0);
	expect(window != null && renderer != null, "creating window "~title, true);

	return WindowResources(window, renderer, ScopeCleanup(delegate void()
	{
		SDL_DestroyWindow(window);
		SDL_DestroyRenderer(renderer);
	}));
}

struct WindowResources
{
	SDL_Window* window;
	SDL_Renderer* renderer;
	private ScopeCleanup _;
}