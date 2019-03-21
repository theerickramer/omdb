# OMDB
Search movies using OMDB API
Save Rating & Comment

## Run
- [Install and run mongoDB](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/)
- Clone this repo and `cd omdb/`
- Start Sinatra server `ruby server.rb`
- Visit `http://localhost:4567/` in your browser

## To Do for production deploy
- figure out Heroku mLab connection issue
- figure out why updating rating / comment fires onchange twice with undefined event on second time.
- switch git pre-commit build vue hook to file watch build (vue-cli dev server creates cross origin issue where POST requests are converted to preflight OPTIONS)
