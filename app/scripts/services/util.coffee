'use strict'

angular.module('services').factory 'Util', ($q, $http, API_HOST, API_PORT) ->
  # 공통적으로 쓰이는 http request 만들어주는 함수
  makeReq: (method, path, param) ->
    deferred = $q.defer()
    # see : http://stackoverflow.com/questions/16661032/http-get-is-not-allowed-by-access-control-allow-origin-but-ajax-is
    # is fixed in 1.1.1
    delete $http.defaults.headers.common['X-Requested-With']

    # 요청 method가 get일때는 parameter를 url에 붙여 보내야하고 아닌 경우에는 body에 심어서 보냄
    # see : http://docs.angularjs.org/api/ng.$http
    $http[method]("#{API_HOST}:#{API_PORT}/#{path}", if method == "get" then params:param else param)
      .success (data) ->
        deferred.resolve data
      .error (error, status) ->
        deferred.reject error
    deferred.promise
