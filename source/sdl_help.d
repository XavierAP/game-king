/**
Helper functions and types for the SDL library.
*/
module sdl_help;
pure
{
public import derelict.sdl2.sdl;

import derelict.sdl2.image;
import std.exception: enforce;
import std.string: toStringz;

alias XY = SDL_Point; /// Pair or vector representing XY coordinates; or width x length.
static assert(XY.init == XY(0,0));

/// RAII self-destructing SDL texture.
struct Texture
{
	/**
	Creates a Texture by loading an image file.
	Params:
	throw_log = Whether to throw (true) or just log (false)
		when the file cannot be loaded into a SDL_Texture.
		See trySDL.
	*/
	this(string filename, SDL_Renderer* render, bool throw_log = false)
	{
		SDL_Surface* surf = IMG_Load(filename.toStringz);
		trySDL(surf != null, "loading image file " ~ filename, throw_log);
		ptr = SDL_CreateTextureFromSurface(render, surf);
		SDL_FreeSurface(surf);
		trySDL(ptr != null || surf == null, "creating texture from file " ~ filename, throw_log); // don't repeat a 2nd error message if a 1st one was already logged.
	}

	@disable this();

	~this() { SDL_DestroyTexture(ptr); }
	
	/// Internal SDL C API pointer.
	SDL_Texture* sdl() { return ptr; }
	alias sdl this; // so I can pass it directly to the SDL API

	private SDL_Texture* ptr; /// Internal SDL C API pointer.
}

/// Texture that contains several images i.e. a sprite sheet.
struct TextureClipbook
{
	/// SDL C API pointer.
	SDL_Texture* sdl() { return _tex.sdl; }
	alias sdl this;

	private Texture _tex;
	@disable this();

	/**
	Creates a Texture by loading an image file
	and clips it into sprites.
	Params:
	ncols = How many columns of sprites.
	nrows = How many rows of sprites.
	Params:
	throw_log = See Texture.
	*/
	this(string filename, SDL_Renderer* render, int ncols, int nrows,
		bool throw_log = false)
	{
		enforce(nrows > 0 && ncols > 0, "Number of sprites must be positive to clip from a sheet.");
		_tex = Texture(filename, render, throw_log);

		SDL_QueryTexture(_tex, null, null, &_clip.w, &_clip.h);
		_clip.w /= ncols;
		_clip.w /= nrows;
		assert(_clip.w >= 0 && _clip.h >= 0);
	}

	/// Returns the SDL_Rect clipping the sprite at (col, row).
	const(SDL_Rect)* clip(int col, int row)
	{
		_clip.x = col * _clip.w;
		_clip.y = row * _clip.h;
		return &_clip;
	}
	
	private SDL_Rect _clip; /// Currently clipped sprite.
}

/// Translation in 2D; mutates the caller
/// and also returns it (for method chaining).
ref T shift(T)(return ref T moving, const ref XY delta)
	if(is(T : SDL_Point) || is(T : SDL_Rect))
{
	moving.x += delta.x;
	moving.y += delta.y;
	return moving;
}

} // impure:

/**
Helper function that checks a boolean
(typically from an SDL call)
-- if false, an error is notified.
Params:
ans = Run-time boolean value.
doing = Description of the activity whose output is being checked.
throw_log = If true and the check was not OK,
	the error is thrown as an Exception.
	If false, the error is only logged.
*/
void trySDL(bool ans, string doing, bool throw_log = false,
	string func = __FUNCTION__, size_t line = __LINE__)
{
	if(!ans)
	{
		import std.format;
		string msg = format!
			"ERROR %s\nin function %s, file line %s.\nSDL info: %s"
			(doing, func, line, SDL_GetError());

		SDL_ClearError();

		if(throw_log)
			throw new Exception(msg);
		else
			SDL_Log(msg.toStringz);
	}
}
/**
Helper function that checks if the first argument
(typically returned by an SDL call)
equals the second one
-- if false, an error is notified.
Params:
ans = Run-time value.
ok  = Expected value.
doing = Description of the activity whose output is being checked.
throw_log = If true and the check was not OK,
	the error is thrown as an Exception.
	If false, the error is only logged.
*/
void trySDL(T)(T ans, T ok, string doing, bool throw_log = false,
	string func = __FUNCTION__, size_t line = __LINE__)
{
	trySDL(ans == ok, doing, throw_log, func, line);
}
