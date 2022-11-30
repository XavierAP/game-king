module textures;

public import sdl_help;
public import bindbc.sdl.image;

import scope_cleanup;
import pixel_xy;

import std.exception: enforce;

TextureResources loadTexture(string filename, SDL_Renderer* render, bool throw_log = false)
{
	auto surf = IMG_Load(filename.toStringz);
	expect(surf != null, "loading image file " ~ filename, throw_log);
	
	auto texture = SDL_CreateTextureFromSurface(render, surf);
	SDL_FreeSurface(surf);
	expect(texture != null || surf == null, // don't repeat a 2nd error message if a 1st one was already logged.
		"creating texture from file "~filename, throw_log);
	
	return TextureResources(texture, ScopeCleanup(delegate void()
	{
		SDL_DestroyTexture(texture);
	}));
}
struct TextureResources
{
	SDL_Texture* texture; alias texture this;
	private ScopeCleanup _;
}

/// Calculates how to split a texture columns and rows
/// and returns the resulting rectangle at the top left.
Rectangle clipTexture(SDL_Texture* texture, ushort ncols, ushort nrows)
{
	Rectangle clip;
	SDL_QueryTexture(texture, null, null, &clip.w, &clip.h);
	clip.w /= ncols;
	clip.w /= nrows;
	return clip;
}
