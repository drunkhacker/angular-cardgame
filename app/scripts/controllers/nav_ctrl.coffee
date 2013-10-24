'use strict'

angular.module('cardgame').controller 'NavCtrl', ($scope, $location) ->
  $scope.isCurrentPath = (path) ->
    $location.path() == path
