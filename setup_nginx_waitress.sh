#!/bin/bash

# 설정할 사용자 및 경로
USER="lucas"
GROUP="lucas"
WORK_DIR="/home/lucas/programming/face-tool/face-tool-be"
VENV_PYTHON="$WORK_DIR/.venv/bin/python"
DOMAIN="innoreed26.crabdance.com"
PORT="15000"

echo "==== [1/5] Nginx 설치 및 방화벽 설정 ===="
# Nginx 설치 (이미 설치되어 있으면 건너뜀)
sudo apt update
sudo apt install -y nginx

# 80, 443 포트 허용 (UFW 사용 시)
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload

echo "==== [2/5] Nginx 설정 변경 ===="
# Nginx 설정 파일 수정
NGINX_CONFIG="/etc/nginx/sites-available/default"
sudo tee $NGINX_CONFIG > /dev/null <<EOL
server {
    listen 80;
    server_name $DOMAIN;

    client_max_body_size 20M;

    location / {
        proxy_pass http://127.0.0.1:$PORT;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOL

# Nginx 설정 적용
sudo nginx -t
sudo systemctl restart nginx

echo "==== [3/5] Let's Encrypt SSL 인증서 발급 ===="
# Certbot 설치 및 SSL 적용
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m admin@$DOMAIN

# 인증서 자동 갱신 설정 (crontab 추가)
echo "0 3 * * * certbot renew --quiet && systemctl restart nginx" | sudo tee -a /etc/crontab > /dev/null

echo "==== [4/5] systemd에서 Waitress 서버 설정 ===="
# systemd 서비스 파일 생성
SERVICE_FILE="/etc/systemd/system/waitress.service"
sudo tee $SERVICE_FILE > /dev/null <<EOL
[Unit]
Description=Python Waitress Server
After=network.target

[Service]
User=$USER
Group=$GROUP
WorkingDirectory=$WORK_DIR
ExecStart=$VENV_PYTHON -m waitress --host=0.0.0.0 --port=$PORT app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# systemd 설정 적용 및 서비스 시작
sudo systemctl daemon-reload
sudo systemctl enable waitress
sudo systemctl restart waitress

echo "==== [5/5] 서비스 상태 확인 ===="
# Nginx & Waitress 서비스 상태 확인
sudo systemctl status nginx --no-pager
sudo systemctl status waitress --no-pager

# 실행된 포트 확인
sudo netstat -tulnp | grep nginx
sudo netstat -tulnp | grep python

echo "✅ 모든 설정이 완료되었습니다! Nginx와 Waitress가 정상적으로 실행 중인지 확인하세요."
