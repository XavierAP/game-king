module windows;

import sdl_help;
import properties;
import xy;

struct Window
{
	private SDL_Window* _window; mixin propertyGet!_window;
	private SDL_Renderer* _renderer; mixin propertyGet!_renderer;

	@disable this();
	this(string title, SDL_WindowFlags flags, XY size,
		XY position = XY(SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED))
	{
		_window = SDL_CreateWindow(title.ptr, position.x, position.y, size.x, size.y, flags);
		_renderer = SDL_CreateRenderer(_window, -1, 0);
		expect(_window != null && _renderer != null, "creating window "~title, true);
	}

	~this()
	{
		SDL_DestroyWindow(_window);
		SDL_DestroyRenderer(_renderer);
	}
}