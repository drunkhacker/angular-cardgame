'use strict'

angular.module('services').factory 'Rank', ($q, Util) ->
  # 서버에서 랭킹 리스트를 가져온다.
  get: () ->
    deferred = $q.defer()
    Util.makeReq('get', '/ranks')
      .then (response) ->
        # status가 true일때만 제대로 된 응답
        if response.status
          deferred.resolve response.ranks
        else
          deferred.reject response.msg
      , (error) ->
        deferred.reject "rank_error"

    deferred.promise


