/**
Helper functions and types for the SDL library.
*/
module sdl_help;

import scope_cleanup;

public import bindbc.sdl;
public import std.string: toStringz;

ScopeCleanup loadLibSDL()
{
	loadSDL().expectEqual(sdlSupport, "initializing SDL", true);
	return ScopeCleanup(wrapAsVoidDelegate!unloadSDL);
}
ScopeCleanup loadLibSDLImage()
{
	loadSDLImage().expectEqual(sdlImageSupport, "initializing SDL_image library", true);
	return ScopeCleanup(wrapAsVoidDelegate!unloadSDLImage);
}

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
void expect(bool ans, string doing, bool throw_log = false,
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
void expectEqual(T)(T ans, T ok, string doing, bool throw_log = false,
	string func = __FUNCTION__, size_t line = __LINE__)
{
	expect(ans == ok, doing, throw_log, func, line);
}
