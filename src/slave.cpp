#include "../include/slave.h"
#include <cstring>

SlaveData::SlaveData() : SLAVE_PORT(0), SLAVE_ID(0) {
  memset(&SlaveAddr, 0, sizeof(SlaveAddr));
}

SlaveData::~SlaveData() {}
