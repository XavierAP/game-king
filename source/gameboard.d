module gameboard;

public import pixel_xy;
public import sdl_help;
public import windows;

struct GameBoard
{
	SDL_Window* window;
	Rectangle player;
	private XYChangeTracker windowSize;

	@disable this();

	this(SDL_Window* window, int mapTileSize)
	{
		this.window = window;
		auto size = window.getSize();
		this.windowSize = XYChangeTracker(size);
		this.player = calcRectangleAtCenter(size, mapTileSize, mapTileSize);
	}

	void onWindowSizeChanged()
	{
		auto shift = windowSize.getChange(window.getSize())
			.divideBy(2);
		
		player.shift(shift);
	}
}