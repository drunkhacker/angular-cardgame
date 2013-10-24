'use strict'

angular.module('cardgame').controller 'GameCtrl', ($scope, $timeout, $location, game, Game) ->
  unless game?
    alert "game load error"
    return $location.path "/"

  $scope.cards = []
  suites = ["hearts", "spades", "diamonds", "clubs"]

  cards = []
  indx = 1
  console.log "game card = #{game.cards.join " "}"
  for num in game.cards
    #get random suite
    suite = suites[Math.floor((Math.random() * 4))]

    name = switch num #special case handling
      when "1" then "ace"
      when "11" then "jack"
      when "12" then "queen"
      when "13" then "king"
      else num

    #get path
    cards.push path:"images/cards/#{name}_of_#{suite}.png", num:parseInt(num), index: indx
    indx++
  $scope.cards = cards

  gameEnd = false

  $scope.lastNum = 0
  $scope.doneCards = []
  $scope.cardClick = (card, e) ->
    console.dir card
    if $scope.doneCards.indexOf(card.index) >= 0
      #do nothing
    else if $scope.lastNum + 1 == card.num
      # ok, mark as done and add overlay
      $(e.target).parent().append('<div class="card-overlay done"></div>')
      console.log("card index = #{card.index}")
      $scope.lastNum++
      $scope.doneCards.push card.index

      console.log "done cards = #{$scope.doneCards.length}"

      #check if this card is the last one
      if $scope.doneCards.length == $scope.cards.length
        #stop timer
        $timeout.cancel timerRef
        gameEnd = true

        #send record to server and go to rank page
        console.dir $scope.doneCards
        Game.submit($scope.doneCards).then (response) ->
          console.dir response
          alert "record : #{response.total_time} sec."
          $location.path "/rank"
        , (error) ->
          console.dir error

    else
      # not ok (alert)
      #flash for a while
      $(e.target).parent().append('<div class="card-overlay not-ok"></div>')
      $timeout () ->
        $(".not-ok", $(e.target).parent()).remove()
      , 150

  $scope.min = 0
  $scope.sec = 0
  $scope.subsec = 0
  timerRef = null

  $scope.start = () ->
    baraja = $("#cards").baraja()
    baraja.fan 
      speed: 500
      easing: "ease-out"
      range: 100
      direction: 'right'
      origin: x: 50, y: 200
      center: true
    $timeout updateTime, 100
    gameEnd = false

  updateTime = () ->
    $scope.subsec++
    if $scope.subsec == 10
      $scope.subsec = 0
      $scope.sec++
    if $scope.sec == 60
      $scope.sec = 0
      $scope.min++
    timerRef = $timeout updateTime, 100 unless gameEnd
