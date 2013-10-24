'use strict'

angular.module('cardgame').controller 'MainCtrl', ($scope, $location, Auth, Util, md5) ->
  $scope.authorized = Auth.isAuthorized()
  $scope.user = Auth.authorizedEmail() if $scope.authorized
  $scope.photoUrl = 
    if $scope.authorized then "http://www.gravatar.com/avatar/#{md5.createHash $scope.user.trim().toLowerCase()}?s=200" else "images/anonymous-user.png"

  $scope.newGame = () ->
    $location.path "/game"

  $scope.login = () ->
    console.log "email = #{$scope.email}"
    Auth.authorize($scope.email).then () ->
        $location.path "/game"
      , (error) ->
        alert error

