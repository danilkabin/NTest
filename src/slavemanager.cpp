#include "../include/slavemanager.h"

SlaveManager::SlaveManager() : activeThreads(0) {}
SlaveManager::~SlaveManager() {}

void SlaveManager::incrementThread() { activeThreads.fetch_add(1); }
void SlaveManager::decrementThread() { activeThreads.fetch_sub(1); }
