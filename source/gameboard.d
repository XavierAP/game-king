module gameboard;

public import pixel_xy;
public import sdl_help;
public import windows;

struct GameBoard
{
	SDL_Window* window;
	XYChangeTracker windowSize;
	Rectangle player;

	@disable this();
	this(SDL_Window* window, int mapTileSize)
	{
		this.window = window;
		auto size = window.getSize();
		this.windowSize = XYChangeTracker(size);
		this.player = calcRectangleAtCenter(size, mapTileSize, mapTileSize);
	}

	void reCenter(Rectangle piece)
	{
		auto change = windowSize.getChange(window.getSize());
		piece.shift(change.divideBy(2));
	}
}