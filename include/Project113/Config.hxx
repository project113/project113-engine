/******************************************************************************
* This Source Code Form is subject to the terms of the Mozilla Public License,
* v. 2.0. If a copy of the MPL was not distributed with this file, You can
* obtain one at http://mozilla.org/MPL/2.0/.
*******************************************************************************
* (doc tags)
******************************************************************************/
#ifndef _PROJECT113_CONFIG_HXX_
#define _PROJECT113_CONFIG_HXX_

// Some people put their system SDL2 headers in the SDL2/ subfolder, some don't.
// Modify as needed if using your system version.
#define SDL_HEADER(X) <SDL2/X>


// Release build stuff
#ifdef P113_BUILD_RELEASE

#endif //P113_BUILD_RELEASE


// Debug build stuff
#ifdef P113_BUILD_DEBUG

#endif //P113_BUILD_DEBUG


// Windows-specific stuff
#ifdef P113_PLATFORM_WINDOWS
	#ifdef P113_BUILD_SHARED
		#ifdef P113_BUILDING_LIB
			#define P113_API __declspec(dllexport)
		#else
			#define P113_API __declspec(dllimport)
		#endif
	#endif
#endif //P113_PLATFORM_WINDOWS


// Make sure declspec is defined
#ifndef P113_API
	#define P113_API
#endif //P113_API
#endif //_PROJECT113_CONFIG_HXX_
