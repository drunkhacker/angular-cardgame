'use strict'

angular.module('cardgame', ['services', 'angular-md5']).config ($routeProvider, $locationProvider, $httpProvider) ->
  console.log "hi"
  delete $httpProvider.defaults.headers.common['X-Requested-With']

  #routing goes here
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
      resolve:  # `resolve` gets required injection variables by calling function
        game: (Game) ->
          # Game.newGame just returns promise which is not 
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


#custom filter for displaying number with leading zeros
#see : http://stackoverflow.com/questions/17648014/how-can-i-use-an-angularjs-filter-to-format-a-number-to-have-leading-zeros
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
