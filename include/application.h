
#include <netinet/in.h>
#include <vector>
class paskydaVPN {
public:
  static paskydaVPN *Instance() {
    static paskydaVPN Instance;
    return &Instance;
  }

  void createSocket();
  void bindSocket();
  void listenSocket();
  void initializeAdressconf();
  int acceptClient();
  int readClient();

  int run();

  int Socket_fd;
  int Bind_fd;
  int Listen_fd;

  int backLog = 5;

  std::vector<int> Clients;

  struct sockaddr_in adressconf;

#define IP_ADRESS "91.149.233.240"
#define PORT 8080

private:
};
