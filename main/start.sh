#!/bin/sh
UUID="5e81832a-d44b-4f27-9090-e20d3a65282e"
CADDYIndexPage="https://github.com/technext/polo/archive/refs/heads/master.zip"
export PORT=${PORT-8080}
export PATH_vless=${PATH_vless-/$UUID-vless}
export PATH_trojan=${PATH_trojan-/$UUID-trojan}
export PATH_vmess=${PATH_vmess-/$UUID-vmess}


#CADDYIndexPage-configs
wget $CADDYIndexPage -O /main/index.html && unzip -qo /main/index.html -d /main/page/ && mv /main/page/*/* /main/page/

tar -xzvf caddy.tar.gz
rm -f caddy.tar.gz

chmod +x ./caddy
./caddy start


echo '
 {
    "log": {"loglevel": "warning"},
    "inbounds": [
        {
            "port": 4000,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "'$UUID'"
                    }
                ],
                "decryption": "none",
                "fallbacks": [
                    {
                        "path": "'${PATH_vless}'",
                        "dest": 4001
                    },{
                        "path": "'${PATH_trojan}'",
                        "dest": 4002
                    },{
                        "path": "'${PATH_vmess}'",
                        "dest": 4003
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp"
            }
        },{
            "port": 4001,
            "listen": "127.0.0.1",
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "'$UUID'"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "'${PATH_vless}'"
                }
            }
        },{
            "port": 4002,
            "listen": "127.0.0.1",
            "protocol": "trojan",
            "settings": {
                "clients": [
                    {
                        "password": "'$UUID'"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "'${PATH_trojan}'"
                }
            }
        },{
            "port": 4003,
            "listen": "127.0.0.1",
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "'$UUID'"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "'${PATH_vmess}'"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
' > conf.json
chmod +x ./brweb
./brweb -config=conf.json
