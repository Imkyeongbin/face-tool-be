#!/bin/bash

# run.sh 프로세스 종료
# 예를 들어, pkill, kill, systemctl stop 등의 명령어 사용
pkill -f 'waitress-serve'

# 잠시 대기 (필요한 경우)
sleep 5

#콘다 환경 실행
conda activate ai16cp2

# run.sh 스크립트 다시 시작
./run.sh &