'use strict'

angular.module('services').factory 'Game', (Util, Auth, $q) ->
  currentGame = {cards: [], id: 0}
  newGame: () ->
    deferred = $q.defer()
    Util.makeReq('post', '/games/enter', user: email: Auth.authorizedEmail())
      .then (response) ->
        if response.status # got new game
          currentGame.cards = response.cards
          currentGame.id = response.id
          deferred.resolve currentGame
        else
          deferred.reject response.msg
      , (error) ->
        deferred.reject "new_game_error"
    deferred.promise
  submit: (cardIndexes) -> #submit current game
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


