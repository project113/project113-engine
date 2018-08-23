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
using namespace std;

bool Engine::_initialized = false;

Engine::Engine() { }


Engine::~Engine() {
	destroy();
}


bool Engine::init() {
	if (!_initialized) {
		SDL_Init(0);
		SDL_InitSubSystem(SDL_INIT_TIMER);
		_initialized = true;
	}

	return _initialized;
}


bool Engine::update() {
	if (!_initialized)
		return false;

	bool status = true;
	for (vector<IUpdatableSystem*>::iterator it  = _updatableSystems.begin(); it != _updatableSystems.end(); ++it)
		status &= (*it)->update();

	return status;
}

void Engine::destroy() {
	if (_initialized) {
		for (vector<ISystem*>::iterator it  = _systems.begin(); it != _systems.end(); ++it)
			delete (*it);
		for (vector<IUpdatableSystem*>::iterator it  = _updatableSystems.begin(); it != _updatableSystems.end(); ++it)
			delete (*it);

		SDL_QuitSubSystem(SDL_INIT_TIMER);
		SDL_Quit();
		_initialized = false;
	}
}


bool Engine::addSystem(ISystem* sys) {
	if (!_initialized || (sys == NULL))
		return false;

	if (sys->init())
		_systems.push_back(sys);
	else
		return false;

	return true;
}


bool Engine::addSystem(IUpdatableSystem* sys) {
	if (!_initialized || (sys == NULL))
		return false;

	if (sys->init())
		_updatableSystems.push_back(sys);
	else
		return false;

	return true;
}
