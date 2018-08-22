/******************************************************************************
* This Source Code Form is subject to the terms of the Mozilla Public License,
* v. 2.0. If a copy of the MPL was not distributed with this file, You can
* obtain one at http://mozilla.org/MPL/2.0/.
*******************************************************************************
* (doc tags)
******************************************************************************/

#define P113_BUILDING_LIB
#include <Project113/Engine.hxx>
using namespace Project113;

Engine::Engine() {
	_initialized = false;
}

bool Engine::init() {
	SDL_Init(0);
	SDL_InitSubSystem(SDL_INIT_TIMER);
	_initialized = true;

	return _initialized;
}

void Engine::destroy() {
	if (_initialized) {
		SDL_QuitSubSystem(SDL_INIT_TIMER);
		SDL_Quit();
		_initialized = false;
	}
}

Engine::~Engine() {
	destroy();
}
