/******************************************************************************
* This Source Code Form is subject to the terms of the Mozilla Public License,
* v. 2.0. If a copy of the MPL was not distributed with this file, You can
* obtain one at http://mozilla.org/MPL/2.0/.
*******************************************************************************
* (doc tags)
******************************************************************************/

#include "Project113/Engine.hxx"
using namespace Project113;

int main(int argc, char* argv[]) {
	SDL_LogInfo(SDL_LOG_CATEGORY_APPLICATION, "[Beginning Engine (Basic) test]");
	Engine engine;

	SDL_LogInfo(SDL_LOG_CATEGORY_APPLICATION, "Initializing engine...");
	if (engine.init()) {
		SDL_LogInfo(SDL_LOG_CATEGORY_APPLICATION, "++ Engine initialized");
	} else {
		SDL_LogInfo(SDL_LOG_CATEGORY_APPLICATION, "!! Engine failed to initialize! Exiting...");
		return 1;
	}

	SDL_LogInfo(SDL_LOG_CATEGORY_APPLICATION, "Destroying engine...");
	engine.destroy();
	SDL_LogInfo(SDL_LOG_CATEGORY_APPLICATION, "++ Engine destroyed");
	SDL_LogInfo(SDL_LOG_CATEGORY_APPLICATION, "[Finished Engine (Basic) test]");
	return 0;
}
