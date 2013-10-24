'use strict'

# 이 컨트롤러는 navigation 부분만을 담당. 실제 게임로직과는 관계없음
angular.module('cardgame').controller 'NavCtrl', ($scope, $location) ->
  # 주어진 path가 실제로 현재 path와 일치하는지?
  $scope.isCurrentPath = (path) ->
    $location.path() == path
