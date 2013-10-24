'use strict'

angular.module('cardgame').controller 'MainCtrl', ($scope, $location, Auth, Util, md5) ->

  $scope.authorized = Auth.isAuthorized()

  # user와 photoUrl은 현재 로그인한 유저가 있을때만 의미가 있으므로 
  # authorized 여부를 체크해서 값을 넣어줌.
  $scope.user = Auth.authorizedEmail() if $scope.authorized
  $scope.photoUrl = 
    if $scope.authorized then "http://www.gravatar.com/avatar/#{md5.createHash $scope.user.trim().toLowerCase()}?s=200" else "images/anonymous-user.png"

  $scope.newGame = () ->
    # 새로운 게임은 새 페이지에서
    $location.path "/game"

  $scope.login = () ->
    console.log "email = #{$scope.email}"
    # $scope.email은 views/main.jade 에서 ng-model 로 설정해뒀음.
    Auth.authorize($scope.email).then () ->
        # 로그인이 끝나면 새 게임 페이지로 바로 이동
        $location.path "/game"
      , (error) ->
        alert error
