#!/bin/bash

### 실행될 스크립트 위치에 맞춰 변경할 것. ###
SCRIPT_PATH=~/programming/face-tool/face-tool-be


# 스크립트를 실행할 위치로 변경
cd $SCRIPT_PATH

# Conda 환경을 초기화
# source ~/miniconda3/etc/profile.d/conda.sh

# run.sh 프로세스 종료
# 예를 들어, pkill, kill, systemctl stop 등의 명령어 사용
pkill -f 'waitress-serve'

# 잠시 대기 (필요한 경우)
sleep 5

# run.sh 스크립트 다시 시작
{ 
  echo "$(date '+%Y-%m-%d %H:%M:%S') run.sh 시작"; 
  bash ./run.sh; 
  echo "$(date '+%Y-%m-%d %H:%M:%S') run.sh 끝"; 
} >> ~/logs/restart_$(date '+%Y-%m-%d').log 2>&1 &