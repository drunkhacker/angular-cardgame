'use strict'

angular.module('cardgame').controller 'GameCtrl', ($scope, $timeout, $location, game, Game) ->

  # game이 null이라는것은 불러오는데에 실패했다는 의미므로
  # 더 이상 진행하지 않고 바로 main 페이지로 튐
  unless game?
    alert "game load error"
    return $location.path "/"

  $scope.cards = []
  suites = ["hearts", "spades", "diamonds", "clubs"]

  cards = []
  indx = 1
  for num in game.cards
    # get random suite
    suite = suites[Math.floor((Math.random() * 4))]

    # special case handling
    name = switch num
      when "1" then "ace"
      when "11" then "jack"
      when "12" then "queen"
      when "13" then "king"
      else num

    # get card image path
    cards.push path:"images/cards/#{name}_of_#{suite}.png", num:parseInt(num), index: indx
    indx++

  # cards are updated here
  $scope.cards = cards

  # 나중에 타이머를 멈출때 쓰임
  gameEnd = false

  # 마지막으로 선택한 카드의 숫자
  $scope.lastNum = 0
  # 지금까지 차례대로 눌러온 카드들의 index
  $scope.doneCards = []

  $scope.cardClick = (card, e) ->
    # 이미 눌렀던 카드면 아무짓도 안함
    if $scope.doneCards.indexOf(card.index) >= 0

    # 선택한 카드가 마지막에 선택한 카드보다 1 커야 제대로 된 다음 카드를 선택한것임.
    else if $scope.lastNum + 1 == card.num
      # ok, mark as done and add overlay
      $(e.target).parent().append('<div class="card-overlay done"></div>')
      $scope.lastNum++

      # 현재 카드의 index 추가
      $scope.doneCards.push card.index

      #check if this card is the last one
      if $scope.doneCards.length == $scope.cards.length
        #stop timer
        $timeout.cancel timerRef
        gameEnd = true

        #send record to server and go to rank page
        Game.submit($scope.doneCards).then (response) ->
          console.dir response
          alert "record : #{response.total_time} sec."
          $location.path "/rank"
        , (error) ->
          console.dir error

    else
      # not ok
      # flash for a while
      $(e.target).parent().append('<div class="card-overlay not-ok"></div>')

      # remove overlay after 150ms
      $timeout () ->
        $(".not-ok", $(e.target).parent()).remove()
      , 150

  # 시계 보여줄 때 필요한 변수들
  $scope.min = 0
  $scope.sec = 0
  $scope.subsec = 0
  timerRef = null

  $scope.start = () ->
    # baraja를 사용하여 카드를 이쁘게 펼쳐줌.
    # 참고 : http://tympanus.net/codrops/2012/11/13/baraja-a-plugin-for-spreading-items-in-a-card-like-fashion/
    baraja = $("#cards").baraja()
    baraja.fan 
      speed: 500
      easing: "ease-out"
      range: 100
      direction: 'right'
      origin: x: 50, y: 200
      center: true

    # 타이머 업데이트 시작
    $timeout updateTime, 100
    gameEnd = false

  # 시계 업데이트 로직
  updateTime = () ->
    $scope.subsec++
    if $scope.subsec == 10
      $scope.subsec = 0
      $scope.sec++
    if $scope.sec == 60
      $scope.sec = 0
      $scope.min++
    # game이 끝나지 않았다면 100ms 뒤에 시계판을 업데이트하는 로직을 recurse하게 부름
    timerRef = $timeout updateTime, 100 unless gameEnd
