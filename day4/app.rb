require 'sinatra'
require 'rest-client'
require 'nokogiri'
require 'json'
require 'sinatra/reloader'
require 'csv'

get '/' do
    erb :index
end

get '/webtoon' do
    # 내가 받아온 웹툰 데이터 저장할 배열생성
    toons = []
    # 웬툰 데이터를 받아올 url 파악 및 요청보내기
    url = "http://webtoon.daum.net/data/pc/webtoon/list_serialized/mon"
    result = RestClient.get(url)
    # 응답으로 온 내용을 해쉬 형태로 바꾸기
    webtoons = JSON.parse(result)
    # 해쉬에서 웹툰 리스트에 해당하는 부분 순환하기
    webtoons["data"].each do |toon|
        #웹툰 제목
        title = toon["title"]
        #웹툰 이미지 주소
        image = toon["thumbnailImage2"]["url"]
        #웹툰 볼 수 있는 주소
        link = "http://webtoon.daum.net/webtoon/view/#{toon['nickname']}"
        # 필요한 부분을 분리해서 처음만든 배열에 push
        toons << {"title" => title, "image" => image, "link" => link}
    end
    
    @daum_webtoon = toons.sample(5)
    
    navertoons = []
    url = URI.encode("http://comic.naver.com/webtoon/weekday.nhn")
    url = RestClient.get(url)
    response = Nokogiri::HTML.parse(url)
    webtoons_naver = response.css("img[height='90']")
    webtoons_naver.each do |toon|
        title = toon["title"]
        image = toon["src"]
        link = "http://comic.naver.com/webtoon/list.nhn?titleId=" + image[37..42]
        navertoons << {"title" => title, "image" => image, "link" => link}
    end
    
    @naver_webtoon = navertoons.sample(5)
    erb :webtoon
end

get '/check_file' do
    unless File.file?('./test.csv')
        puts "파일이 없습니다."
        #CSV파일을 새로 생성하는 코드
        toons = []
        url = "http://webtoon.daum.net/data/pc/webtoon/list_serialized/mon"
        result = RestClient.get(url)
        webtoons = JSON.parse(result)
        webtoons["data"].each do |toon|
            title = toon["title"]
            image = toon["thumbnailImage2"]["url"]
            link = "http://webtoon.daum.net/webtoon/view/#{toon['nickname']}"
            toons << {"title" => title, "image" => image, "link" => link}
        end
        daum_webtoon = toons.sample(5)
        CSV.open('./test.csv','w+') do |row|
            #크롤링 한 웹툰 데이터를 CSV에 삽입
            daum_webtoon.each_with_index do |toon, index|
                row << [index,toon["title"],toon["image"],toon["link"]]
            end
        end
        erb :check_file
    else
        #존재하는 CSV 파일을 불러오는 코드
        @webtoons = []
        CSV.open('./test.csv','r+').each do |row|
            @webtoons << row
        end
        erb :webtoons
    end
end

get '/board/:id' do
    # id를 리턴해준다!
    puts params[:id]
end
