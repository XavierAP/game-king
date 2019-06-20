/**
Conventional constants.
*/
module config;

import sdl_help;

enum string appTitle = "MMR"; /// Title of the application.

enum string dirImages = "img/"; /// Application directory where image files are located.
enum Uint32 fpsMax = 50; /// Maximum frames per second, when busy time -> 0.
enum coord mapTileSize = 64; /// Scale factor between screen and map coordinates.
