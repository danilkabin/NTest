#ifndef SLAVEMANAGER_H
#define SLAVEMANAGER_H

#include <atomic>
#include <chrono>
#include <map>
#include <memory>
#include <netinet/in.h>
#include <thread>
#include <vector>

class SlaveManager {
public:
  SlaveManager();
  ~SlaveManager();

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

  void incrementThread();
  void decrementThread();

  std::map<std::pair<std::string, int>, std::unique_ptr<SlaveData>> SlaveMap;
  std::atomic<int> activeThreads;

private:
};

#endif
