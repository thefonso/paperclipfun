#Rails 4.0.4, Mongo, Paperclip

- is app will live on Heroku
- utilize AWS

specifications:

	a user can login to it
	
	a user can upload pictures to it.
	
	the front end will use masonry.


[development of this app will follow these instructions](https://github.com/thefonso/Tutorials/blob/master/mongoid_paperclip_tutorial.md)

###How to get this code running

- fork this code
- clone it down to your local machine
- bundle install

Let's take a peek at the gemfile and note the presence of the gems..

gem mongod

gem mongoid-rspec

gem rspec-rails

gem pry-rails

gem 'bcrypt', '~> 3.1.7'


	NOTE: lookup these gem names on [ruby-toolbox.com](https://www.ruby-toolbox.com/)

	to get a better understanding of them and how to use them.
	
# Step 0
Basic Authentication

Let's get mongo going:

	rails g mongoid:config
	
Now we'll create a user for this app. Note password digest is needed for has_secured_password that we will use later in our model

	rails g resource user email password_digest
	
Now let's get the database going
	
	Rake db:migrate
	
You should see something like this...

```
aleph ~/Projects/paperclipfun on finished[?]
$ rails g resource user email password_digest
      invoke  mongoid
      create    app/models/user.rb
      invoke    rspec
      create      spec/models/user_spec.rb
      invoke  controller
      create    app/controllers/users_controller.rb
      invoke    erb
      create      app/views/users
      invoke    rspec
      create      spec/controllers/users_controller_spec.rb
      invoke    helper
      create      app/helpers/users_helper.rb
      invoke      rspec
      create        spec/helpers/users_helper_spec.rb
      invoke    assets
      invoke      coffee
      create        app/assets/javascripts/users.js.coffee
      invoke      scss
      create        app/assets/stylesheets/users.css.scss
      invoke  resource_route
       route    resources :users
aleph ~/Projects/paperclipfun on finished[?]
$
```
model - Open your model/user.rb page, make sure it looks like this....

```
class User
  include Mongoid::Document
  field :email, type: String
  field :password_digest, type: String

  has_secure_password

  validates_uniqueness_of :email
end

```

controller - user_controller.rb

```
class UsersController < ApplicationController
	def index
		
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			redirect_to root_url, notice: "Thank you for signing up!"
		else
			render "new"
		end
	end

	private
	def user_params
		params.require(:user).permit(:email, :password, :password_confirmation)
	end
end


```

view - new.html.erb


	<h1>Sign Up</h1>
	
	<%= form_for @user do |f| %>
	  <% if @user.errors.any? %>
	    <div class="error_messages">
	      <h2>Form is invalid</h2>
	      <ul>
	        <% @user.errors.full_messages.each do |message| %>
	          <li><%= message %></li>
	        <% end %>
	      </ul>
	    </div>
	  <% end %>
	
	  <div class="field">
	    <%= f.label :email %><br />
	    <%= f.text_field :email %>
	  </div>
	  <div class="field">
	    <%= f.label :password %><br />
	    <%= f.password_field :password %>
	  </div>
	  <div class="field">
	    <%= f.label :password_confirmation %><br />
	    <%= f.password_field :password_confirmation %>
	  </div>
	  <div class="actions"><%= f.submit "Sign Up" %></div>
	<% end %>

And no let's get our sign_up link going on the app. We'll place a sign_up link in out application.html.erb...

	<!DOCTYPE html>
	<html>
	<head>
	  <title>Paperclipfun</title>
	  <%= stylesheet_link_tag    "application", media: "all", "data-turbolinks-track" => true %>
	  <%= javascript_include_tag "application", "data-turbolinks-track" => true %>
	  <%= csrf_meta_tags %>
	</head>
	<body>
		<div id="container">
			<div id="user_header">
				<%= link_to "Sign_up", new_user_path %>
			</div>
			<% flash.each do |name,msg| %>
				<%= content_tag :div, msg, id: "flash_#{name}" %>
			<% end %>
	
			<%= yield %>
		</div>
	</body>
	</html>

Oh and don't forget 

	rake db:migrate
	
now let's test things out, run...

	rails s
	
	and 
	
	mongod
	
then goto localhost:3000

ah we're in a Rails4 app...so let's create a standard page we can assign our root path to.

so create a users/index.html.erb 

	<p>I'm a place holder page. I'm located in <%= users_path %> /index.html.erb </p>

'rake routes' should look like this now...

```
aleph ~/Projects/paperclipfun on finished[?]
$ rake routes
   Prefix Verb   URI Pattern               Controller#Action
    users GET    /users(.:format)          users#index
          POST   /users(.:format)          users#create
 new_user GET    /users/new(.:format)      users#new
edit_user GET    /users/:id/edit(.:format) users#edit
     user GET    /users/:id(.:format)      users#show
          PATCH  /users/:id(.:format)      users#update
          PUT    /users/:id(.:format)      users#update
          DELETE /users/:id(.:format)      users#destroy
aleph ~/Projects/paperclipfun on finished[?]
$
```

almost done...inside your routes.rb...

	root 'users#index
	
'rake routes' should be this now...

```
$ rake routes
   Prefix Verb   URI Pattern               Controller#Action
    users GET    /users(.:format)          users#index
          POST   /users(.:format)          users#create
 new_user GET    /users/new(.:format)      users#new
edit_user GET    /users/:id/edit(.:format) users#edit
     user GET    /users/:id(.:format)      users#show
          PATCH  /users/:id(.:format)      users#update
          PUT    /users/:id(.:format)      users#update
          DELETE /users/:id(.:format)      users#destroy
     root GET    /                         users#index
aleph ~/Projects/paperclipfun on finished[?]
$
```

**notice** the new **root GET**

Now refresh your localhost:3000

click sign_up

OOPS big error for has_secure_password

fix it like this...

```
class User
  include Mongoid::Document
  include ActiveModel::SecurePassword
  field :email, type: String
  field :password_digest, type: String
  
  has_secure_password

  attr_accessible :email, :password, :password_confirmation

  validates_uniqueness_of :email
end

```
**note:   include ActiveModel::SecurePassword**

now let's get 'sign in' going

	rails g controller sessions new
	
turn your routes.rb file from this...

	Paperclipfun::Application.routes.draw do
	  get "sessions/new"
	  resources :users
	
	  root 'users#index'
	end

to this...

	Paperclipfun::Application.routes.draw do
	  resources :resources
	  resources :users
	
	  root 'users#index'
	end

inside sessions/new.html.erb...

	<h1>Log In</h1>
	
	<%= form_tag sessions_path do %>
	  <div class="field">
	    <%= label_tag :email %><br />
	    <%= text_field_tag :email, params[:email] %>
	  </div>
	  <div class="field">
	    <%= label_tag :password %><br />
	    <%= password_field_tag :password %>
	  </div>
	  <div class="actions"><%= submit_tag "Log In" %></div>
	<% end %>

inside your sessions_controller.rb

	class SessionsController < ApplicationController
	
		def new
		end
	
		def create
			user = User.where(email: params[:email]).first
			# first make sure we actually find a user
			# then see if user authenticates
			if user && user.authenticate(params[:password])
				# sets the cookie to the browser
				session[:user_id] = user.id
				redirect_to root_url, notice: "Logged in!"
			else
				flash.now.alert = "Email or password is invalid"
				render "new"
				# redirect_to new_session_path
			end
		end
	
		def destroy
			# Kill our cookies!
			reset_session
			redirect_to root_path, notice: "Logged out!"
		end
	end
ok so now we can sign up and log in to our app. But we need to be able to logout as well...

#logout
enter in this code for the following files...

application_controller.rb

	class ApplicationController < ActionController::Base
	  # Prevent CSRF attacks by raising an exception.
	  # For APIs, you may want to use :null_session instead.
	  protect_from_forgery with: :exception
	
	private
	
	  def current_user
	  	@current_user ||= User.find(session[:user_id]) if session[:user_id]	
	  end
	  helper_method :current_user
	end

application.html.erb

	<div id="user_header">
        <% if current_user %>
          Logged in as <%= current_user.email %>.
          <%= link_to "Log Out", session_path("current") %>
        <% else %>
          <%= link_to "Sign Up", new_user_path %> or
          <%= link_to "Log In", new_session_path %>
        <% end %>
	</div>
	
Now when we go to localhost:3000 we can sign up, login and logout

	NOTE: how in the url you have...http://localhost:3000/sessions/new
	
	well that looks not so pretty...why don't we make it look like this instead...http://localhost:3000/login
	
this is how....

#Pretty routes

edit the following files....

routes.rb

	Paperclipfun::Application.routes.draw do
		get 'signup', to: 'users#new', as: 'signup'
		get 'login', to: 'sessions#new', as: 'login'
		get 'logout', to: 'sessions#destroy', as: 'logout'
	
		resources :sessions
		resources :users
	
		root 'users#index'
	end
	
application.html.erb

	inside the div id=container ...

	<div id="user_header">
		<% if current_user %>
		  Logged in as <%= current_user.email %>.
		  <%= link_to "Log Out", logout_path %>
		<% else %>
		  <%= link_to "Sign Up", signup_path %> or
		  <%= link_to "Log In", login_path %>
		<% end %>
	</div>

NOTE: you can remove the two notices in your session_controller.rb

Now we have a small bump to repair. If you notice when you sign up a new user the app does not automatically log them in...let's fix this.

#Auto login during signup

inside users_controller.rb

	def create
		@user = User.new(user_params)
		if @user.save
			session[:user_id] = @user.id
			redirect_to root_url, notice: "Thank you for signing up!"
		else
			render "new"
		end
	end
	
now when we sign up the user gets logged in automatically...yeah

<!--
#Limit access to pages

a common thing to do is to have your app limit which pages can be viewed by the level of access per user. Let's see how to make this happen...

coming soon
-->


# Step 1 - Paperclip

## Add more Gems
inside your gemfile...

- gem "mongoid-paperclip", "~> 0.0.8", :require => "mongoid_paperclip"
- gem "aws-s3", :require => "aws/s3"

then from the common line run

	bundle install
	
Follow along as we code this fool
