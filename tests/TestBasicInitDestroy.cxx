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
	LOG_INFO("[Beginning TestBasicInitDestroy]");
	LOG_INFO("Purpose: Verify that the engine and all available subsystems can be successfully initialized and destroyed.");
	LOG_INFO("   Creating engine object...");
	Engine engine;

	LOG_INFO("   Initializing engine...");
	if (engine.init()) {
		LOG_INFO("++ Engine initialized");
	} else {
		LOG_INFO("!! Engine failed to initialize! Exiting...");
		return 1;
	}

	LOG_INFO("   Destroying engine...");
	engine.destroy();
	LOG_INFO("++ Engine destroyed");
	LOG_INFO("[Finished TestBasicInitDestroy]");
	return 0;
}
