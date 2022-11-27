module xy;

struct XY { int x, y; }
static assert(XY.init == XY(0,0));

/// Translation in 2D; mutates the caller by reference
/// and also returns it (for method chaining).
ref T shift(T)(return ref T moving, const ref XY delta)
{
	moving.x += delta.x;
	moving.y += delta.y;
	return moving;
}
