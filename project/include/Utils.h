#ifndef SECURERANDOM_H
#define SECURERANDOM_H

namespace secureRandom {

	int _getSecureRandom32();
	const char* _makeUUID();
	void _setKeychain(int eventDispacherId, const char *key, const char *value);
	void _getKeychain(int eventDispacherId, const char *key);
	void _removeKeychain(int eventDispacherId, const char *key);
}

#endif