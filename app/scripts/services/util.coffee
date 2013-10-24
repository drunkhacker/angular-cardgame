'use strict'

angular.module('services').factory 'Util', ($q, $http, API_HOST, API_PORT, md5) ->
  makeReq: (method, path, param) ->
    deferred = $q.defer()
    delete $http.defaults.headers.common['X-Requested-With']
    $http[method]("#{API_HOST}:#{API_PORT}/#{path}", if method == "get" then params:param else param)
      .success (data) ->
        deferred.resolve data
      .error (error, status) ->
        deferred.reject error
    deferred.promise
