## 실행방법
1. extern_lib에서 `git clone https://github.com/Imkyeongbin/AI_16_CP2.git`

2. python 3.9버전을 추천하며, 다음 둘(기본 파이썬 혹은 아나콘다) 중의 하나를 활용하여 가상환경을 만들고 실행한다.
    1) python -m venv .venv
        리눅스 => source .venv/Scripts/activate
        윈도우 => .venv\Scripts\Activate.ps1"
        
    2) conda create ai16cp2 (환경명은 임의로 작성해도 됩니다.)
    conda activate ai16cp2

3. pip install -U pip

4. pip install -r requirements.txt
   
5. 프론트엔드를 dist 폴더 통째로 templates에 복붙하면 동작함.

6. 프로젝트 루트에서 `waitress-serve --listen=*:5000 app:app`

### Docker를 구성하고 싶을 경우, 루트에서 프론트엔드를 클론하고 npm build이후 실행하시면 됩니다.

###
setup_nginx_waitress.sh 파일을 통해 리눅스 환경에서 서버부팅시 자동 waitress 재시작 및 nginx 설치 및 세팅까지 진행할 수 있음
다만, 스케줄화 하려면
`sudo crontab -e`
에서 아래와 같은 내용을 추가할 것

`0 3 * * * certbot renew --nginx --quiet && systemctl restart nginx && systemctl restart waitress`

`0 4 * * * find /var/log/nginx/*.log -type f -mtime +90 -exec rm {} \;`

#### 이슈
`flask run`
는 바로 내려가고

`python -m flask run`
안 내려감. 어차피 waitress 써야되니까 상관없지만.

리눅스 우분투 22.04에 설치시에 디펜던시 에러가 발생할 수 있음
`aptitude`를 `apt-get`대신 사용해서 해결할 수 있음. 단, 처음에 제시하는 방법은 디펜던시를 그냥 설치하지 않는 채로 두는 제안일 수 있으니 확인 후 n 하고, 그다음 대안 확인하고 y 입력할 것

## 📷 이미지 업로드를 위한 Nginx 설정

Nginx는 기본적으로 요청 본문 크기를 **1MB로 제한**합니다.  
이 때문에 **스마트폰 카메라로 촬영한 고용량 이미지**는 업로드에 실패할 수 있습니다.  
(특히 Flask 서버에 직접 파일 업로드 요청이 들어갈 경우)

### 🔥 해결 방법

Nginx 설정 파일에 아래 내용을 반드시 추가해야 합니다:

```nginx
server {
    client_max_body_size 20M;
}
```