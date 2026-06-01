#!/bin/bash
# api.linclean.kr Let's Encrypt 인증서 최초 발급 부트스트랩.
# 닭-달걀(니nginx는 인증서가 있어야 443 기동 / 인증서는 nginx 80이 있어야 발급) 해결:
#   1) 더미 자가서명 인증서 생성 → nginx가 443으로 뜰 수 있게
#   2) nginx 기동 (80에서 ACME 챌린지 응답)
#   3) 더미 삭제 후 certbot으로 실제 인증서 발급
#   4) nginx reload
#
# 사용법(App EC2의 /opt/linclean/service 에서): sudo bash init-letsencrypt.sh
set -e

DOMAIN="api.linclean.kr"
EMAIL="sunmin8410@mju.ac.kr"   # Let's Encrypt 만료 알림 수신용
STAGING=0                       # 1로 두면 LE 스테이징(테스트, 신뢰 안되는 인증서). 본 발급 전 rate limit 테스트용.
RSA_KEY_SIZE=4096
COMPOSE="docker compose"
LIVE="/etc/letsencrypt/live/$DOMAIN"

echo "### 1. 더미 인증서 생성 ($DOMAIN) ###"
$COMPOSE run --rm --entrypoint "\
  sh -c 'mkdir -p $LIVE && \
  openssl req -x509 -nodes -newkey rsa:2048 -days 1 \
    -keyout $LIVE/privkey.pem -out $LIVE/fullchain.pem -subj /CN=localhost'" certbot

echo "### 2. nginx 기동 ###"
$COMPOSE up -d nginx

echo "### 3. 더미 삭제 ###"
$COMPOSE run --rm --entrypoint "\
  sh -c 'rm -rf /etc/letsencrypt/live/$DOMAIN /etc/letsencrypt/archive/$DOMAIN /etc/letsencrypt/renewal/$DOMAIN.conf'" certbot

echo "### 4. 실제 인증서 발급 ###"
STAGING_ARG=""
[ "$STAGING" != "0" ] && STAGING_ARG="--staging"
$COMPOSE run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot $STAGING_ARG \
    --email $EMAIL --agree-tos --no-eff-email \
    -d $DOMAIN --rsa-key-size $RSA_KEY_SIZE --force-renewal" certbot

echo "### 5. nginx reload ###"
$COMPOSE exec nginx nginx -s reload

echo "완료: https://$DOMAIN"
