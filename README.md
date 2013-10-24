AngularJS Simple Card Game
===========================

의존성
------
* [NodeJS](http://nodejs.org/)
* [Grunt](http://gruntjs.com)
* [Bower](http://bower.io)

실행방법
--------
```shell
cardgame $ bower install   # install bower dependencies
cardgame $ grunt server    # compile files and run connect server on port 9000
```

웹브라우저에서 `http://localhost:9000` 확인

소스트리 구성
-------------

```
.
├── Gruntfile.coffee       # Gruntfile 
├── README.md
├── app/
│   ├── images/
│   │   └── anonymous-user.png
│   │   └── cards/         # card 이미지들
│   ├── index.jade         # index.html의 jade 소스 (브라우저가 처음 로드하는 부분)
│   ├── scripts/
│   │   ├── app.coffee     # angular app module을 정의한 파일 
│   │   ├── controllers/   # controller들. app.coffee 를 참조하여 어떤 route에 어떤 컨트롤러를 부르는가 확인
│   │   │   ├── game_ctrl.coffee
│   │   │   ├── main_ctrl.coffee
│   │   │   ├── nav_ctrl.coffee
│   │   │   └── rank_ctrl.coffee
│   │   ├── jquery.baraja.js   # 카드 펼칠때 사용하는 library
│   │   ├── modernizr.custom.97293.js  # baraja가 요구하는 library
│   │   └── services/      # services
│   │       ├── auth.coffee    # 인증관련
│   │       ├── games.coffee   # 게임 로드, 제출 관련
│   │       ├── md5.js         # md5 해싱 라이브러리. gravatar 불러올때 씀
│   │       ├── ranks.coffee   # 랭킹 불러오는 것 관련
│   │       ├── services.js    # services 묶어주는 스캐폴드 파일
│   │       └── util.coffee    # http 요청 날려주는 헬퍼 함수
├── bower.json             # bower dependencies 정의
└── package.json           # grunt dev dependencies 정의
```

`index.jade`를 살펴보고, 그 다음에 `app.coffee`에서 라우팅에 따라 어떤
template과 controller가 대응되는지 보고 그 파일들을 같이 살펴보면
좋습니다.

