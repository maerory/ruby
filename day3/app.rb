require 'sinatra'
require 'sinatra/reloader'
require 'uri'
require 'httparty'
require 'nokogiri'
require 'rest-client'


get '/' do
    erb :app
end

get '/calculator' do
    num1 = params[:n1].to_f
    num2 = params[:n2].to_f
    @sum = num1 + num2
    @min = num1 - num2
    @mul = num1 * num2
    @div = num1 / num2
    erb :calculator
end

get '/numbers' do
    erb :numbers
end


get '/form' do
    erb :form
end

id = "multi"
pw = "campus"

post '/login' do
    if id.eql?(params[:id]) 
        # 비밀번호를 체크하는 로직
        if pw.eql?(params[:pw])
            redirect '/complete'
        else
            @msg = "비밀번호 틀림"
            #@msg는 인스턴스이기 때문에 
            redirect '/error?err_co=1'
        end
    else
        # ID가 존재하지 않습니다.
        @msg = "ID 없음"
        redirect '/error?err_co=2'
    end
end

#계정이 존재하지 않거나, 비밀번호가 틀린 경우
get '/error' do
    # 다른 방식으로 에러메시지를 보여줘야 할 경우
    if params[:err_co].to_i == 2
    # id가 없는 경우
        @msg = "ID가 없습니다"
    elsif params[:err_co].to_i == 1
    # pw가 틀린 경우
        @msg = "비밀번호가 틀렸습니다."
    end
    erb :error
end

#로그인 완료된 곳
get '/complete' do
    erb :complete
end

get '/search' do
    erb :search
end

post '/search' do
    puts params[:engine]
    case params[:engine]
        when "naver"
            url = URI.encode("https://search.naver.com/search.naver?query=#{params[:query]}")
            redirect url
        when "google"
            url = URI.encode("https://www.google.com/search?q=#{params[:q]}")
            redirect url
    end
end

get '/op.gg' do
    if params[:ID]
        url = URI.encode("http://www.op.gg/summoner/userName=#{params[:ID]}")
        case params[:search_method]
            ## OP.GG에서 검색결과를 보여준다
            when "OP.GG"
                redirect url
            ## 승패만 가져와서 보여줌
            when "winrate"
                # RestClient를 통해 op.gg에서 검색결과 페이지를 크롤링
                url = RestClient.get(url)
                response = Nokogiri::HTML.parse(url)
                # 검색결과를 페이지 중 win과 lose 부분을 찾음
                win = response.css("span.win").first
                lose = response.css("span.lose").first
                # 검색 결과를 페이지에서 보여주기 위한 변수 선언
                @win = win.text
                @lose = lose.text
                # @winrate = win.to_s + "승" + " " + loss.to_s + "패"
        end
    end
    erb :"op.gg"
end
        
    