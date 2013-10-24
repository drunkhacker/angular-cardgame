'use strict'

angular.module('services').factory 'Game', (Util, Auth, $q) ->
  # 현재 게임을 들고 있는 변수
  currentGame = {cards: [], id: 0}
  
  # 새 게임을 가져오는 함수
  newGame: () ->
    deferred = $q.defer()
    Util.makeReq('post', '/games/enter', user: email: Auth.authorizedEmail())
      .then (response) ->
        if response.status
          # keep current game
          currentGame.cards = response.cards
          currentGame.id = response.id

          deferred.resolve currentGame
        else
          deferred.reject response.msg
      , (error) ->
        deferred.reject "new_game_error"
    deferred.promise

  # submit current game
  # cardIndexes는 재배열된 카드들의 인덱스들
  submit: (cardIndexes) ->
    deferred = $q.defer()
    Util.makeReq("put", "/games/#{currentGame.id}", game: card_indexes: cardIndexes)
      .then (response) ->
        console.dir response
        if response.status 
          deferred.resolve response
        else
          deferred.reject response.msg
      , (error) ->
        deferred.reject "game_submit_error"
    deferred.promise


