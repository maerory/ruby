day 5

오늘 할 내용

- CRUD중 CR을 학습
- 자료가 저장되는 곳은 DB가 아니라 CSV 파일로 한다.
- 그리고 사용자의 입력을 받아서 간이 게시판을 만든다


과제 01

- 사용자의 입력을 받는 form 태그로 이루어진 /new 액션과 erb 파일
  - form의 action 속성은 /create로 가도록 한다.(가기만 하고 만들지는 않는다)
  - method는 post를 이용한다.
  - 게시판 글의 제목(= title)과 본문(= contents) 두 가지 속성을 저장할 것이다.
- 전체 목록을 보여주는 table 태그로 이루어진 /boards 액션과 erb 파일
  - 일단 파일만 만든다



app.rb

    get '/new' do
        erb :new
    end
    
    get '/boards' do
        erb :boards
    end


new.erb

    <h1>new</h1>
    <form action="/create" method="POST">
        
    </form>


boards.erb

    <h1>boards</h1>
    <table>
        
    </table>

과제 02

- /create 액션을 만들고 작성 후에는 /boards 액션으로 들어가게 구성
  - /create액션이 동작한 이후에는 본인이 작성한 글로 이동하게 수정
- 글 목록을 볼 수 있는 페이지는 /board/글번호의 형태로 작성

##Create와 Read

1. get /boards/new
2. post /boards/create
3. get /boards
4. get /board/:id
- board라고 하는 게시판이 하나만 존재하고 있다
- user라고 하는 CRUD 기능을 해야하는 DB Table을 만든다고 가정하면?
- 새로운 유저를 등록한다면?
 
##과제 03
- User를 등록할 수 있는 CSV파일
- id, password, password_confirmation
- 조건1
    - password와 password_confirmation을 받는데 회원을 등록할 때, 두 문자열이 다르면 회원 등록 안됨
- Route(라우팅)
    - `get` /user/new
    - `post` /user/create
    - `get` /users
    - `get` /user/:id
    



