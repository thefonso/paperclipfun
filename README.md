#Rails 4.0.4, Mongo, Paperclip


specifications:

	a user can login to it
	
	a user can upload pictures to it.



###How to get this code running

- fork this code
- clone it down to your local machine

You will need to switch branches. Switch to the "finished" branch like so...

	git checkout finished
	
then run

	bundle install

	rake db:create
	rake db:migrate

```
signup
http://localhost:3000/

add photos
http://localhost:3000/photos/new

see all your users
http://localhost:3000/users
```

NOTE: if you want the automatic resizing of images feature just - brew install imagemagick and uncomment the sections in 

	model/photo.rb
	views/users/index.html.erb
