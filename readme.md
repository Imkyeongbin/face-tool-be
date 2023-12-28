## 실행방법

1. extern_lib에서 `git clone https://github.com/Imkyeongbin/AI_16_CP2.git`

2. 프론트엔드를 dist 폴더 통째로 templates에 복붙하면 동작함.

3. 프로젝트 루트에서 `waitress-serve --listen=*:5000 app:app`

#### 이슈
`flask run`
는 바로 내려가고

`python -m flask run`
안 내려감. 어차피 waitress 써야되니까 상관없지만.