class App < Sinatra::Base

  enable :sessions

  client = Mysql2::Client.new(host: "localhost", username: "root", password: "root", database: "sinatra")

  get "/" do
    erb :index
  end

  get "/users" do
    results = client.query("SELECT * FROM users")
    erb :users, locals: {results: results}
  end

  get "/register" do
    erb :register
  end

  post "/register" do
    @name = client.escape(params[:name])
    @email = client.escape(params[:email])
    @password = client.escape(params[:password])
    insert = client.query("insert into users (name, email, password) values ('#{@name}', '#{@email}', '#{@password}')")
    redirect '/users'
  end

   get "/login" do
    erb :login
  end

  post "/login" do
    @email = client.escape(params[:email])
    @password = client.escape(params[:password])
    result = client.query("SELECT email FROM users WHERE email='#{@email}' AND password='#{@password}'")

    # Do the Login 
    if result.count == 1

      result.each do |row|
        session[:username] = row["email"]
      end

      redirect '/users'
    end
  end

  get "/logout" do
    session[:username] = nil
    redirect '/users'
  end

  helpers do
    
    def login?
      if session[:username].nil?
        return false
      else
        return true
      end
    end
    
    def username
      return session[:username]
    end
    
  end

end




