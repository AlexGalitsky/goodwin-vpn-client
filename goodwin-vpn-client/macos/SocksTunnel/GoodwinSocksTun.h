#ifndef GoodwinSocksTun_h
#define GoodwinSocksTun_h

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef void (*goodwin_socks_out_fn)(const uint8_t* data, int len, void* ctx);

/// PacketFlow mode: IP in via GoodwinSocksTunInput, IP out via outFn (must be GCD-safe).
int GoodwinSocksTunStart(const char* socksHost, int socksPort, goodwin_socks_out_fn outFn, void* outCtx);

/// Optional utun FD mode when NEPacketTunnelFlow exposes socket.fileDescriptor.
int GoodwinSocksTunStartFd(int tunFd, const char* socksHost, int socksPort);

void GoodwinSocksTunInput(const uint8_t* data, int length);

void GoodwinSocksTunStop(void);

#ifdef __cplusplus
}
#endif

#endif /* GoodwinSocksTun_h */
