#include "../include/slavemanager.h"
#include <cstring>

SlaveManager::SlaveData::SlaveData() : SLAVE_PORT(0), SLAVE_ID(0) {
  memset(&SlaveAddr, 0, sizeof(SlaveAddr));
}

SlaveManager::SlaveData::~SlaveData() {}
