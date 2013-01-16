var express = require('express'),
  everyauth = require('everyauth');

var users = {};

everyauth.everymodule.findUserById(function(userId, callback){
  // User.findById(userId, callback);
  // callback has the signature, function (err, user) {...}
  callback(null, users[userId]);
});

everyauth.twitter
  .consumerKey(process.env.CRASH_TWITTER_KEY)
  .consumerSecret(process.env.CRASH_TWITTER_SECRET)
  .findOrCreateUser(function(session, accessToken, accessTokenSecret, twitterUserMetadata){
    users[twitterUserMetadata.id] = twitterUserMetadata;
    return twitterUserMetadata;
  })
  .redirectPath('/');

var app = express();
app.use(express.bodyParser());
app.use(express.cookieParser());
app.use(express.session({secret: 'mr ripley'}));
app.use(everyauth.middleware());

app.get('/', function(req, res){
  var user = req.user;
  if (user){
    res.json(req.user);  
  } else {
    res.redirect('/auth/twitter');
  }
});

app.listen(3000);
console.log('Listening on port 3000');
