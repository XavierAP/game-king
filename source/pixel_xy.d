module pixel_xy;

public import bindbc.sdl: SDL_Point, SDL_Rect;
public alias XY = SDL_Point;
public alias Rectangle = SDL_Rect;
static assert(XY.init == XY(0,0));
static assert(Rectangle.init == Rectangle(0,0,0,0));

XY diff(XY lhs, XY rhs) { return XY(lhs.x - rhs.x, lhs.y - rhs.y); }

XY multiplyBy(XY lhs, int factor) { return XY(lhs.x * factor, lhs.y * factor); }

XY divideBy(XY lhs, int divisor) { return XY(lhs.x / divisor, lhs.y / divisor); }

/// Translation in 2D; mutates the caller by reference
/// and also returns it.
ref auto shift(return ref Rectangle moving, XY delta)
{
	moving.x += delta.x;
	moving.y += delta.y;
	return moving;
}

Rectangle calcRectangleAtCenter(XY totalSize, int width, int height)
{
	Rectangle ans = { w: width, h: height };
	ans.x = (totalSize.x - ans.w) / 2;
	ans.y = (totalSize.y - ans.h) / 2;
	return ans;
}

struct XYChangeTracker
{
	XY last;

	XY getChange(XY newXY)
	{
		auto ans = diff(newXY, last);
		last = newXY;
		return ans;
	}
}