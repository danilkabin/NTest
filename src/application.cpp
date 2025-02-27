#include <cstring>
#include <iostream>
#include <string>

#include "arpa/inet.h"
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>

#include "../include/application.h"

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
    return 1;
  }

  if (inet_pton(adressconf.sin_family, IP_ADRESS,
                &(adressconf.sin_addr.s_addr)) <= 0) {
    std::cout << "adress not supported" << std::endl;
    return 1;
  }

  listenSocket();

  if (Listen_fd < 0) {
    std::cout << "listen failed" << std::endl;
    return 1;
  }

  std::cout << "hello" << std::endl;
  return 0;
}
