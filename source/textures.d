module textures;

public import sdl_help;
public import bindbc.sdl.image;

import properties;

import std.exception: enforce;
import std.string: toStringz;

pure:

/// RAII self-destructing SDL texture.
struct Texture
{
	private SDL_Texture* _sdl; mixin propertyGet!_sdl;
	alias sdl this; // so I can pass it directly to the SDL API

	@disable this();
	/**
	Creates a Texture by loading an image file.
	Params:
	throw_log = Whether to throw (true) or just log (false)
		when the file cannot be loaded into a SDL_Texture.
		See sdl_help.expect.
	*/
	this(string filename, SDL_Renderer* render, bool throw_log = false)
	{
		SDL_Surface* surf = IMG_Load(filename.toStringz);
		expect(surf != null, "loading image file " ~ filename, throw_log);
		_sdl = SDL_CreateTextureFromSurface(render, surf);
		SDL_FreeSurface(surf);
		expect(_sdl != null || surf == null, // don't repeat a 2nd error message if a 1st one was already logged.
			"creating texture from file " ~ filename, throw_log);
	}

	~this() { SDL_DestroyTexture(_sdl); }
}

/// Texture that contains several images i.e. a sprite sheet.
struct TextureClipbook
{
	private Texture _tex;
	SDL_Texture* sdl() { return _tex.sdl; }
	alias sdl this;

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
