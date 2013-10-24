'use strict'

angular.module('services').factory 'Auth', ($q, Util) ->
  (() ->
    currentEmail = null
    authorizedEmail: () -> currentEmail
    isAuthorized: () -> currentEmail?
    authorize: (email) ->
      deferred = $q.defer()
      Util.makeReq("post", "/users", {user: email: email})
        .then (response) ->
          if response.status #success
            currentEmail = response.email # keep authorized email
            deferred.resolve response.email
          else
            deferred.reject response.msg
        ,(error) ->
          deferred.reject "authorize_error"
      deferred.promise
  )()

