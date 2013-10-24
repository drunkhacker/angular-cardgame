'use strict'

# livereload uses websocket for establish the communication between webserver and client page
livereload_port = 35729
lrSnippet = require('connect-livereload') port: livereload_port

# accessAllow function actually does nothing. Ignore it
accessAllow = (req, res, next) ->
  res.setHeader 'Access-Control-Allow-Origin', '*'
  res.setHeader 'Access-Control-Allow-Methods', '*'
  next()

# mountFolder set given static directory as the root of webserver. Multiple directories can be mounted as root
mountFolder = (connect, dir) ->
  connect.static(require('path').resolve(dir))

module.exports = (grunt) ->
  # show elapsed time at the end
  require('time-grunt') grunt
  # load all grunt tasks
  require('load-grunt-tasks') grunt

  # Grunt configuration starts here
  grunt.initConfig
    # Grunt 설정은 plugin의 이름을 명시하고 그 밑에 관련 속성들을 명시하면서 설정할 수 있습니다. 
    # 예를들어 아래의 watch object는 'grunt-contrib-watch' 플러그인이 참조하는 부분입니다.
    # 이 프로젝트에서 쓰이는 grunt plugin들과 관련 이름, 역할은 아래와 같습니다.
    # 
    # 플러그인                 | key        | 역할 
    # -------------------------+------------+------------------------------------------------------------
    # grunt-contrib-plugin     | watch      | 파일이 변하면 자동으로 클라이언트 웹페이지 리로드. 
    #                          |            | (+ 다른 태스크 수행 가능)
    # -------------------------+------------+------------------------------------------------------------
    # grunt-contrib-connect    | connect    | 간단한 서버를 제공합니다. 
    #                          |            | 만들어진 페이지를 HTTP 서버를 통해 serve하기 위해 사용
    # -------------------------+------------+------------------------------------------------------------
    # grunt-contrib-concat     | concat     | 파일을 이어 붙입니다.
    #                          |            | coffeescript를 컴파일 해서 나온 javascript들을
    #                          |            | 한 파일로 이어붙이기 위해 사용
    # -------------------------+------------+------------------------------------------------------------
    # grunt-contrib-coffee     | coffee     | coffeescript를 컴파일합니다.
    #                          |            | http://coffeescript.org 참조
    # -------------------------+------------+------------------------------------------------------------
    # grunt-contrib-clean      | clean      | 지정한 파일을 삭제합니다.
    # -------------------------+------------+------------------------------------------------------------
    # grunt-contrib-less       | less       | less로 쓰여진 파일을 css로 컴파일합니다.
    #                          |            | http://lesscss.org/ 참조
    # -------------------------+------------+------------------------------------------------------------
    # grunt-contrib-jade       | jade       | jade로 쓰여진 파일을 html로 컴파일합니다.
    #                          |            | http://jade-lang.com/ 참조
    # -------------------------+------------+------------------------------------------------------------
    # grunt-contrib-concurrent | concurrent | 복수개의 작업을 동시에 실행하여 처리 속도를 높입니다.
    #                          |            | dependency가 없는 작업들을 이렇게 실행하면 좋습니다.
    # -------------------------+------------+------------------------------------------------------------
    # grunt-contrib-copy       | copy       | 파일을 복사합니다. 여기서는 나중에 distro 버젼을 만들때
    #                          |            | dist 디렉토리로 컴파일 된 파일들을 집어넣을 때 씁니다.
    # -------------------------+------------+------------------------------------------------------------


    # watch task에 기본적으로 livereload를 true로 세팅하면, watch하라고 세팅한 파일들이 바뀔때마다
    # websocket으로 듣고 있는 브라우저에 새로고침 명령을 내립니다.
    watch:
      options:
        livereload: true
      coffee: # <- 이 부분의 이름은 맘대로 바꿀 수 있는듯..
        files: ['app/scripts/{,*/}*.coffee'] # 무슨 파일을 지켜보고 있을것인가.
        tasks: ['coffee'] # 그리고 그 파일이 바뀌었을때 무슨 작업을 수행할건가. 'coffee'라고 명시했으니
                          # 이 파일에서 coffee 부분을 찾아서 세팅에 맞추어 관련작업을 수행합니다.
        options:
          livereload: false # livereload 옵션을 덮어쓸 수 있는데, coffee같은 경우는 컴파일만 하고
                            # 웹페이지를 새로고침 하진 않습니다.
      less:
        files: ['app/styles/{,*/}*.less']
        tasks: 'less'
        options:
          livereload: false
      scripts:
        files: '{.tmp, app}/scripts/{,*/}*.js' # 여기서는 livereload 옵션을 덮어쓰지 않았는데, 이렇게 되면 livereload를 하게 되고,
                                               # 웹페이지가 새로고침됩니다. javascript나 css, html 같은 경우는 웹페이지의 동작이
                                               # 바뀌는 결과를 만들어내니까 새로고침 하는게 맞습니다. coffeescript, less, jade 같은
                                               # 경우는 컴파일 결과 각각 js, css, html이 나오기 때문에 알아서 livereload에 걸리게
                                               # 되어있기 때문에 위의 세팅에서 livereload를 꺼놓은 겁니다.
      imgs:
        files: 'app/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
      styles:
        files: ['{.tmp, app}/styles/{,*/}*.css']
      views:
        files: ['{app, .tmp}/index.html']
        options:
          livereload: true
      jade:
        files:
          ['app/views/{,*/}*.jade', 'app/index.jade']
        tasks: 'jade'
        options:
          livereload: false

    # connect에 관련한 옵션들
    connect:
      options:
        port: 9000
        hostname: '*' # *로 하면 호스트 네임 관계 없이 서버가 요청을 받아들입니다.
      livereload:
        options: # livereload 관련 옵션 세팅. connect-livereload 플러그인 필요
          middleware: (connect) -> # middleware는 connect 서버가 요청을 처리할때 
                                   # 중간에서 요청을 받아 조작하여 다음 레이어로 넘길수있는 구조입니다.
                                   # 여기서는 .tmp 및 app을 파일을 serve하는 root directory로 세팅하는것과,
                                   # livereload를 위한 스크립트를 응답에 inject하는 미들웨어를 사용합니다.
            [ lrSnippet, mountFolder(connect, '.tmp'), mountFolder(connect, 'app')]

    # 파일 이어붙이기
    # .tmp/scripts/services.js를 만들기 위해 service 모듈을 따로 정의해놓은 파일과 다른 service 모듈들을 가져다 붙입니다.
    # 왜 굳이 파일을 두종류로 나눠서 붙이는지는 app/scripts/services/services.js를 참고.
    concat:
      server:
        files: ".tmp/scripts/services.js": ['app/scripts/services/services.js', '.tmp/scripts/services/*.js']

    # coffeescript 컴파일
    coffee:
      server: # 이런식으로 태스크 밑에 바로 레이블을 붙이면, 다른 태스크에서 'coffee:server' 와 같은 방법으로 
              # 태스크를 참조할수있습니다. 이 파일 맨 아래 부분의 registerTask 에서 사용례가 나와있음.

        # 아래의 file object를 구성하는 방법은
        # https://github.com/gruntjs/grunt/wiki/Configuring-tasks#building-the-files-object-dynamically 를 참조
        files: [
            '.tmp/scripts/app.js' : 'app/scripts/app.coffee'
            '.tmp/scripts/controllers.js' : 'app/scripts/controllers/*.coffee'
          ,
            expand: true
            cwd: 'app/scripts/services'
            src: '{,*/}*.coffee'
            dest: '.tmp/scripts/services'
            ext: '.js'
        ]

    # clean
    # `clean:server` 라고 하면 단순히 .tmp를 날리고
    # `clean:dist` 라고 하면 dist 디렉토리를 지웁니다.
    clean:
      server: '.tmp'
      dist: 'dist'

    # less 컴파일
    less:
      server:
        files: [
          expand: true
          cwd: 'app/styles'
          src: '{,*/}*.less'
          dest: '.tmp/styles'
          ext: '.css'
        ]

    # jade 컴파일
    jade:
      compile:
        files: [
            expand: true
            cwd: 'app/views/'
            src: '{,*/}*.jade'
            dest: '.tmp/views/'
            ext: '.html'
          ,
            '.tmp/index.html' : 'app/index.jade'
        ]

    # 동시 수행 작업 정의
    # coffee나 less, jade 같은 것은 서로 영향을 미치지 않기 때문에
    # 동시 수행해도 됩니다.
    concurrent:
      server: ['coffee', 'less', 'jade']
      dist: ['coffee', 'less', 'jade']

    copy:
      dist:
        # copy .tmp files to dest directory because 
        # coffee, less, jade tasks generate compiled 
        # files to .tmp 
        files: [
            expand: true
            cwd: '.tmp'
            src: '**'
            dest: 'dist'
          ,
            #dump serve-ready (.css, .html, .js) to dist
            expand: true
            cwd: 'app'
            src: '{,**/}*.{html,css,js}'
            dest: 'dist'
          ,
            #dump images to dist as it is
            expand: true
            cwd: 'app'
            src: 'images/**'
            dest: 'dist'
          ,
            #dump bower components as it is
            expand: true
            cwd: 'app'
            src: 'bower_components/**'
            dest : 'dist'
        ]

  # `registerTask` 함수는 커맨드 라인에서 grunt xxx 와 같이 쳤을때 수행될 작업들을 명시할 수 있게 해줍니다.
  # 여기서는 server와 dist를 정의 하고 그 각각의 커맨드에서 수행할 일련의 태스크를 적어줍니다.
  grunt.registerTask 'server', [ 'clean:server', 'concurrent:server', 'concat', 'connect:livereload', 'watch' ]
  grunt.registerTask 'dist', [ 'clean:dist', 'concurrent:dist', 'concat', 'copy:dist' ]
