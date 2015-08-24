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
    articles = conn.exec_params("SELECT title, url, description FROM articles")
    erb :articles, locals: {article: articles}
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
    conn.exec_params("INSERT INTO articles (title, url, description) VALUES ($1,$2, $3)", [params['title'],params['url'],params['description']])
  end
  redirect "/articles"
end


set :views, File.join(File.dirname(__FILE__), "views")
set :public_folder, File.join(File.dirname(__FILE__), "public")
