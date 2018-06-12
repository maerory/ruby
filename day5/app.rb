require 'sinatra'
require 'sinatra/reloader'
require 'csv'

get '/' do
    erb :index
end

# Boards #

get '/new_board' do
    erb :new_board
end

post '/board_create' do
    #사용자가 입력한 정보를 받아서
    #csv 파일 가장 마지막에 등록
    # => 이 글의 글번호도 같이 저장해야함
    # => 기존의 글 개수를 파악해서 
    # => 글 개수 + 1 해서 저장
    
    title = params[:title]
    contents = params[:contents]
    idx = CSV.read('./boards.csv').count.to_i + 1
    puts "입력: "+ idx.to_s + title.to_s + contents.to_s
    CSV.open('./boards.csv','a+') do |row|
        row << [idx, title, contents]
    end
    redirect '/board/#{id}'
end

get '/boards' do
    #file을 읽기모드로 열기
    #각 줄마다 순회
    #@ 변수에 값을 넣어줌
    @boards = []
    
    CSV.open('./boards.csv', 'r+').each do |row|
        @boards << row
    end
    
    erb :boards
end

get '/board/:id' do
    #csv파일에서 params[:id]로 넘어온 친구와
    #같은 글번호를 가진 row를 선택
    #csv파일을 전체 순회한다.
    #csv파일을 순회하다가 첫번째 col이 id와 같은 순간
    #순회를 정지하고 값을 변수에 저장한다.
    @board = []
    CSV.read('./boards.csv').each do |row|
        if params[:id]==row[0]
            @board = row
            break 
        end
    end
    puts @board
    erb :board
end

# USERS #
get '/users' do
    @users = []
    CSV.open('./users.csv', 'r+').each do |row|
        @users << row
    end
    erb :users
end

get '/user/new' do
    erb :new_user
end

post "/user/create" do
    if params[:password].eql? params[:password_conf]
        users = []
        file = CSV.read('./users.csv', 'r+')
        file.each do |row|
            users << row[1]
        end
        unless users.include? params[:id]
            index = file.size + 1
            id = params[:id]
            pw = params[:password]
            CSV.open('./users.csv','a+') do |row|
                row << [index, id, pw]
            end
            redirect "/user/#{id}"
        else
            erb :error
        end
    else
        erb :error
    end
end

get '/user/:id' do
    @user = []
    CSV.read('./users.csv').each do |row|
        if params[:id]==row[1]
            @user = row
            break
        end
    end
    puts @user
    erb :user
end

