/******************************************************************************
* This Source Code Form is subject to the terms of the Mozilla Public License,
* v. 2.0. If a copy of the MPL was not distributed with this file, You can
* obtain one at http://mozilla.org/MPL/2.0/.
*******************************************************************************
* (doc tags)
******************************************************************************/
#ifndef _PROJECT113_ENGINE_HXX_
#define _PROJECT113_ENGINE_HXX_

#include "Project113/Config.hxx"
#include SDL_HEADER(SDL.h)

namespace Project113 {
	class P113_API Engine {
		public:
			Engine();
			~Engine();
			bool init();
			void destroy();

		protected:
			bool _initialized;
	};
}
#endif //_PROJECT113_ENGINE_HXX_
