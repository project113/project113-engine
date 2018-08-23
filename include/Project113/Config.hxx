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
	#define LOG_DEBUG(x, ...) SDL_LogMessage(SDL_LOG_CATEGORY_TEST, SDL_LOG_PRIORITY_DEBUG, x, __VA_ARGS__)
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


// Make sure all needed macros are defined
#ifndef P113_API
	#define P113_API
#endif //P113_API

#ifndef LOG_DEBUG
	// Why even waste the space if we're not debugging?
	#define LOG_DEBUG(x, ...)
#endif //LOG_DEBUG(X)

#ifndef LOG_INFO
	#define LOG_INFO(x, ...) SDL_Log(x, __VA_ARGS__)
#endif //LOG_INFO(X)

#ifndef LOG_ERROR
	#define LOG_ERROR(x, ...) SDL_LogMessage(SDL_LOG_CATEGORY_ERROR, SDL_LOG_PRIORITY_ERROR, x, __VA_ARGS__)
#endif //LOG_ERROR(X)
#endif //_PROJECT113_CONFIG_HXX_
