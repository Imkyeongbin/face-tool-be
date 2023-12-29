# Python 베이스 이미지 사용
FROM python:3.9-slim

# 작업 디렉토리 설정
WORKDIR /app

# Node.js 설치
RUN apt-get update && apt-get install -y nodejs npm tk

# 백엔드 파일 복사 및 Python 의존성 설치
COPY . .
RUN  pip install --upgrade pip && pip install -r requirements.txt

# 프론트엔드 파일 복사
COPY face-tool-fe/ ./face-tool-fe/

# 프론트엔드 의존성 설치 및 빌드, 이동
RUN cd face-tool-fe && npm install && npm run build && \
    rm -rf dist \
    mv -f dist ../templates && \
    rm -rf /app/face-tool-fe

# 포트 설정
EXPOSE 5000

# 애플리케이션 실행
CMD ["waitress-serve", "--listen=*:5000", "app:app"]
