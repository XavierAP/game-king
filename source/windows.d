module windows;

import scope_cleanup;
import sdl_help;
import pixel_xy;

struct WindowResources
{
	SDL_Renderer* render;
	SDL_Window* window;
	private XY previousWindowSize;
	private ScopeCleanup cleanup;

	@disable this();
	this(SDL_Window* window, SDL_Renderer* render)
	{
		this.window = window;
		this.render = render;
		cleanup = ScopeCleanup(delegate void()
		{
			SDL_DestroyWindow(window);
			SDL_DestroyRenderer(render);
		});
	}

	XY getWindowSize()
	{
		XY size;
		SDL_GetWindowSize(window, &size.x, &size.y);
		return size;
	}

	/// since last time
	XY getWindowSizeChange()
	{
		auto newSize = getWindowSize();
		auto ans = diff(newSize, previousWindowSize);
		previousWindowSize = newSize;
		return ans;
	}
}

WindowResources createWindow(string title, SDL_WindowFlags flags, XY size,
	XY position = XY(SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED))
{
	auto window = SDL_CreateWindow(title.toStringz, position.x, position.y, size.x, size.y, flags);
	auto render = SDL_CreateRenderer(window, -1, 0);
	expect(window != null && render != null, "creating window "~title, true);
	return WindowResources(window, render);
}
