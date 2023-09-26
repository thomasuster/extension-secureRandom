#ifndef SECURERANDOM_H
#define SECURERANDOM_H

namespace secureRandom {

	int _getSecureRandom32();
	const char* _makeUUID();
	bool _setKeychain(const char *key, const char *value);
	const char* _getKeychain(const char *key);
	bool _removeKeychain(const char *key);
}

#endif