module pixel_xy;

public import bindbc.sdl: SDL_Point, SDL_Rect;
public alias XY = SDL_Point;
public alias Rectangle = SDL_Rect;
static assert(XY.init == XY(0,0));
static assert(Rectangle.init == Rectangle(0,0,0,0));

/// Translation in 2D; mutates the caller by reference
/// and also returns it.
ref auto shift(return ref Rectangle moving, const ref XY delta)
{
	moving.x += delta.x;
	moving.y += delta.y;
	return moving;
}

Rectangle calcRectangleAtCenter(const ref XY totalSize, int width, int height)
{
	Rectangle ans = { w: width, h: height };
	ans.x = (totalSize.x - ans.w) / 2;
	ans.y = (totalSize.y - ans.h) / 2;
	return ans;
}
