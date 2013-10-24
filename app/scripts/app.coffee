'use strict'

###
# cardgame이라는 모듈 생성. 이 모듈은 services와 angular-md5 모듈에 의존함. 
# angular-md5는 이메일을 가지고 gravatar url 주소를 얻어오기 위해서 사용함.
# angular-md5 : https://github.com/gdi2290/angular-md5
###

angular.module('cardgame', ['services', 'angular-md5']).config ($routeProvider, $locationProvider, $httpProvider) ->
  # see : http://stackoverflow.com/questions/16661032/http-get-is-not-allowed-by-access-control-allow-origin-but-ajax-is
  # is fixed in 1.1.1
  delete $httpProvider.defaults.headers.common['X-Requested-With']

  # 라우팅 정의
  # path는 실제로는 url 뒤에 #/path 식으로 hash 형태로 나타남.
  # 실제 페이지 이동은 없고, 해쉬가 바뀌는걸 angularJS 가 잡아채서 동작
  $routeProvider
    .when '/',
      templateUrl: 'views/main.html'
      controller: 'MainCtrl'
    .when '/login',
      templateUrl: 'views/login.html'
      controller: 'LoginCtrl'
    .when '/game',
      templateUrl: 'views/game.html'
      controller: 'GameCtrl'
      # `resolve` gets required injection variables by calling function
      resolve: 
        game: (Game) ->
          ###
          # Game.newGame 은 promise를 리턴하는데 만약 promise가 reject 된 경우에는 
          # 단순히 null을 리턴하도록 함.
          # 바로 promise를 리턴한다고 해도 success의 경우에는 문제가 없으나,
          # reject의 경우에는 어떻게 될지 실험하지 않았음.
          ###
          Game.newGame().then (game) ->
            game
          , (error) ->
            null
    .when '/rank',
      templateUrl: 'views/rank.html'
      controller: 'RankCtrl'
      resolve:
        ranks: (Rank) ->
          Rank.get().then (rank) -> 
            rank
          , (error) -> 
              null

# custom filter for displaying number with leading zeros
# see : http://stackoverflow.com/questions/17648014/how-can-i-use-an-angularjs-filter-to-format-a-number-to-have-leading-zeros
angular.module('cardgame').filter 'numberFixedLen', () ->
  (n, len) ->
    num = parseInt n, 10
    len = parseInt len, 10
    if isNaN(num) or isNaN(len)
      return n
    num = '' + num
    z = len - num.length
    z = 0 if z < 0
    "#{new Array(z+1).join("0")}#{num}"
