require 'sinatra'
require 'pg'
require 'csv'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: "news_aggregator_development")
    yield(connection)
  ensure
    connection.close
  end
end


get "/articles" do
  db_connection do |conn|
    article = conn.exec_params("SELECT title, url, description FROM articles")
    #articles is a PG object.Returns an array of hashes.
    erb :articles, locals: {article: article}
  end
end

get "/articles/new" do
  db_connection do |conn|
    list = conn.exec_params("SELECT title, url, description FROM articles")
    erb :new
  end
end

get "/articles/error" do
  erb :error
end

post "/articles" do
  db_connection do |conn|
    url = params["url"]
    unique_url_test = conn.exec_params("select * from articles where url like '#{url}'")
    #its would also work: unique_url_test.to_a and check if the length is greater than 0
    if unique_url_test.any? #returns true if unique_url_test already exists
      redirect "/articles/error"
    else
      conn.exec_params("INSERT INTO articles (title, url, description) VALUES ($1,$2, $3)", [params['title'],params['url'],params['description']])
    end
  end
  redirect "/articles"
end


set :views, File.join(File.dirname(__FILE__), "views")
set :public_folder, File.join(File.dirname(__FILE__), "public")
