/******************************************************************************
* This Source Code Form is subject to the terms of the Mozilla Public License,
* v. 2.0. If a copy of the MPL was not distributed with this file, You can
* obtain one at http://mozilla.org/MPL/2.0/.
*******************************************************************************
* (doc tags)
******************************************************************************/
#ifndef _PROJECT113_ISYSTEM_HXX_
#define _PROJECT113_ISYSTEM_HXX_

#include "Project113/Config.hxx"

namespace Project113 {
	class ISystem {
		public:
			ISystem();
			virtual ~ISystem();
			virtual bool init() = 0;
			virtual bool isInitialized();
			virtual void destroy();

		protected:
			bool _initialized;
	};

	class IUpdatableSystem: public ISystem {
		public:
			virtual bool update() = 0;
	};
}
#endif //_PROJECT113_ISYSTEM_HXX_
