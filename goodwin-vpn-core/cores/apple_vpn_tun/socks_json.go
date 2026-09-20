package main

import "encoding/json"

func socksAuthFromJSON(kind, cfg string) (user, pass string) {
	var root map[string]any
	if json.Unmarshal([]byte(cfg), &root) != nil {
		return "", ""
	}
	if kind == "hysteria2" || kind == "hysteria" {
		s5, _ := root["socks5"].(map[string]any)
		if s5 == nil {
			return "", ""
		}
		user, _ = s5["username"].(string)
		pass, _ = s5["password"].(string)
		return user, pass
	}
	inbounds, _ := root["inbounds"].([]any)
	if len(inbounds) == 0 {
		return "", ""
	}
	in, _ := inbounds[0].(map[string]any)
	settings, _ := in["settings"].(map[string]any)
	if settings == nil {
		return "", ""
	}
	accounts, _ := settings["accounts"].([]any)
	if len(accounts) == 0 {
		return "", ""
	}
	acc, _ := accounts[0].(map[string]any)
	user, _ = acc["user"].(string)
	pass, _ = acc["pass"].(string)
	return user, pass
}
