package main

import (
	"net"

	"github.com/txthinking/socks5"
)

func negotiateSOCKS(conn net.Conn, user, pass string) (bool, error) {
	req, err := socks5.NewNegotiationRequestFrom(conn)
	if err != nil {
		return false, err
	}
	ok := false
	for _, m := range req.Methods {
		if m == socks5.MethodUsernamePassword {
			ok = true
			break
		}
	}
	if !ok {
		_, _ = socks5.NewNegotiationReply(socks5.MethodUnsupportAll).WriteTo(conn)
		return false, nil
	}
	if _, err := socks5.NewNegotiationReply(socks5.MethodUsernamePassword).WriteTo(conn); err != nil {
		return false, err
	}
	up, err := socks5.NewUserPassNegotiationRequestFrom(conn)
	if err != nil {
		return false, err
	}
	if string(up.Uname) != user || string(up.Passwd) != pass {
		_, _ = socks5.NewUserPassNegotiationReply(socks5.UserPassStatusFailure).WriteTo(conn)
		return false, nil
	}
	_, err = socks5.NewUserPassNegotiationReply(socks5.UserPassStatusSuccess).WriteTo(conn)
	return err == nil, err
}
