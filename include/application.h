#include <atomic>
#include <map>
#include <memory>
#include <netinet/in.h>
#include <vector>

#include "slavemanager.h"

class paskydaVPN {
public:
  paskydaVPN() {}
  ~paskydaVPN() {}

  static paskydaVPN *Instance() {
    static paskydaVPN Instance;
    return &Instance;
  }

  void createSocket();
  void bindSocket();
  void listenSocket();
  void initializeAdressconf();

  void addSlave();

  int handleClient(SlaveManager::SlaveData Slave);
  int acceptClient();
  int readClient();

  int run();

  int Socket_fd;
  int Bind_fd;
  int Listen_fd;

  int backLog = 5;

  struct sockaddr_in adressconf;

#define IP_ADRESS "91.149.233.240"
#define PORT 8080
#define BUFFER_SIZE 1024
#define MAXIMUM_THREADS 5

private:
};
