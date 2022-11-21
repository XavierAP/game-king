module textures;

public import sdl_help;
public import derelict.sdl2.image;

import std.exception: enforce;
import std.string: toStringz;

pure:

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
