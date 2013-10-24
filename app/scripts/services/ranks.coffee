'use strict'

angular.module('services').factory 'Rank', ($q, Util) ->
  get: () ->
    deferred = $q.defer()
    Util.makeReq('get', '/ranks')
      .then (response) ->
        if response.status
          deferred.resolve response.ranks
        else
          deferred.reject response.msg
      , (error) ->
        deferred.reject "rank_error"

    deferred.promise


