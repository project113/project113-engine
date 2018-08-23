/******************************************************************************
* This Source Code Form is subject to the terms of the Mozilla Public License,
* v. 2.0. If a copy of the MPL was not distributed with this file, You can
* obtain one at http://mozilla.org/MPL/2.0/.
*******************************************************************************
* (doc tags)
******************************************************************************/

#define P113_BUILDING_LIB
#include <Project113/ISystem.hxx>
using namespace Project113;

ISystem::ISystem() {
	_initialized = false;
}


ISystem::~ISystem() {
	if (_initialized)
		destroy();
}


bool ISystem::isInitialized() {
	return _initialized;
}


void ISystem::destroy() {
	_initialized = false;
}
