'use strict'

angular.module('services').factory 'Auth', ($q, Util) ->
  # javascript immediate function apply pattern
  # 여기서는 currentEmail을 스코프 안에서 값을 유지하면서 사용하기 위해서 썼습니다.
  # coffeescript로 했으면 클래스를 쓸수도 있음.
  (() ->
    # 인증된 현재 사용자 email
    currentEmail = null
    authorizedEmail: () -> currentEmail
    # currentEmail이 존재하면 그냥 인증된 상태라 가정
    isAuthorized: () -> currentEmail?
    authorize: (email) ->
      deferred = $q.defer()
      Util.makeReq("post", "/users", {user: email: email})
        .then (response) ->
          if response.status #success
            # keep authorized email for future usage
            currentEmail = response.email
            deferred.resolve response.email
          else
            deferred.reject response.msg
        ,(error) ->
          deferred.reject "authorize_error"
      deferred.promise
  )()

