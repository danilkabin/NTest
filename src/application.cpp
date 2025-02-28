#include <chrono>
#include <cstring>
#include <iostream>
#include <string>

#include "arpa/inet.h"
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <thread>
#include <unistd.h>

#include "../include/application.h"
#include "../include/slave.h"

paskydaVPN *VPN = paskydaVPN::Instance();

void paskydaVPN::createSocket() {
  Socket_fd = socket(adressconf.sin_family, SOCK_DGRAM, 0);
}

void paskydaVPN::bindSocket() {
  Bind_fd = bind(Socket_fd, (struct sockaddr *)&adressconf, sizeof(adressconf));
}

void paskydaVPN::listenSocket() { Listen_fd = listen(Socket_fd, backLog); }

void paskydaVPN::initializeAdressconf() {
  memset(&adressconf, 0, sizeof(adressconf));
  adressconf.sin_family = AF_INET;
  adressconf.sin_addr.s_addr = INADDR_ANY;
  adressconf.sin_port = htons(PORT);
}

int paskydaVPN::handleClient(SlaveData Slave) {
  char buffer[BUFFER_SIZE];

  socklen_t addr_len = sizeof(Slave.SlaveAddr);
  std::cout << "1" << std::endl;
  ssize_t receivedPackage =
      recvfrom(Socket_fd, (char *)buffer, BUFFER_SIZE, 0,
               (struct sockaddr *)&Slave.SlaveAddr, &addr_len);

  std::cout << "2" << std::endl;
  if (receivedPackage < 0) {
    std::cout << "bad package" << std::endl;
    return 1;
  }

  std::cout << Slave.SlaveAddr.sin_addr.s_addr << std::endl;
  return 0;
}

void paskydaVPN::incrementThread() { activeThreads.fetch_add(1); }
void paskydaVPN::decrementThread() { activeThreads.fetch_sub(1); }

int paskydaVPN::run() {
  VPN->initializeAdressconf();
  VPN->createSocket();

  if (VPN->Socket_fd == -1) {
    std::cout << "Error creating socket" << std::endl;
    return 1;
  }

  bindSocket();

  if (Bind_fd == -1) {
    std::cout << "Error binding socket" << std::endl;
    close(Socket_fd);
    return 1;
  }

  if (inet_pton(adressconf.sin_family, IP_ADRESS,
                &(adressconf.sin_addr.s_addr)) <= 0) {
    std::cout << "adress not supported" << std::endl;
    close(Socket_fd);
    return 1;
  }

  SlaveData Client;
  while (true) {
    handleClient(Client);
  }

  std::cout << "activeThreads: " << activeThreads << std::endl;
  return 0;
}
