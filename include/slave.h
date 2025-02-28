#ifndef SLAVE_H
#define SLAVE_H

#include <arpa/inet.h>
#include <chrono>
#include <cstdint>
#include <cstring>
#include <netinet/in.h>
class SlaveData {
public:
  SlaveData();
  ~SlaveData();

  enum class SlaveStatus { Connected, Disconnected };

  char *IP[INET_ADDRSTRLEN];
  uint16_t *SLAVE_PORT;
  uint32_t *SLAVE_ID;

  uint32_t receivedPackages = 0;
  uint32_t sentPackages = 0;

  struct sockaddr_in SlaveAddr;

  std::chrono::steady_clock::time_point lastActivity;

private:
};

#endif
