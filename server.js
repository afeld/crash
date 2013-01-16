var express = require('express'),
  everyauth = require('everyauth');

var app = express();

var users = {};


everyauth.everymodule.findUserById(function(userId, callback){
    // User.findById(userId, callback);
    // callback has the signature, function (err, user) {...}
    callback(null, users[userId]);
  });

app.configure(function(){
  var twitterKey = process.env.CRASH_TWITTER_KEY,
    twitterSecret = process.env.CRASH_TWITTER_SECRET;

  if (!twitterKey){
    throw new Error("must set CRASH_TWITTER_KEY");
  }
  if (!twitterSecret){
    throw new Error("must set CRASH_TWITTER_SECRET");
  }

  everyauth.twitter
    .consumerKey(twitterKey)
    .consumerSecret(twitterSecret)
    .findOrCreateUser(function(session, accessToken, accessTokenSecret, twitterUserMetadata){
      users[twitterUserMetadata.id] = twitterUserMetadata;
      return twitterUserMetadata;
    })
    .redirectPath('/');
});


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
