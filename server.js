var express = require('express'),
  everyauth = require('everyauth'),
  twitter = require('ntwitter');

var app = express();

var users = {};


everyauth.everymodule.findUserById(function(userId, callback){
    // User.findById(userId, callback);
    // callback has the signature, function (err, user) {...}
    callback(null, users[userId]);
  });


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
    var user = twitterUserMetadata;
    user.accessToken = accessToken;
    user.accessTokenSecret = accessTokenSecret;

    users[user.id] = user;
    return user;
  })
  .redirectPath('/');


app.use(express.bodyParser());
app.use(express.cookieParser());
app.use(express.session({secret: 'mr ripley'}));
app.use(everyauth.middleware());
app.use(function(req, res, next){
  // require the user to be logged in
  if (!req.user){
    res.redirect('/auth/twitter');
    // TODO eventually send back to original URL
  } else {
    next();
  }
});


var getNearbyFriends = function(user, callback){
  var twit = new twitter({
    consumer_key: twitterKey,
    consumer_secret: twitterSecret,
    access_token_key: user.accessToken,
    access_token_secret: user.accessTokenSecret
  });

  // TODO _getUsingCursor
  // TODO followers/list
  twit.get('/friends/list.json', {include_user_entities: true}, function(err, data){
    if (err){
      callback(err);
    } else {
      var nearby = data.users.filter(function(friend){
        // TODO also check friend.status.coordinates and friend.status.place.bounding_box
        return (/NY/).test(friend.location);
      });

      callback(null, nearby);
    }
  });
};


app.get('/', function(req, res){
  getNearbyFriends(req.user, function(err, data){
    res.json(err || data);
  });
});

app.get('/friends/nearby.json', function(req, res){
  getNearbyFriends(req.user, function(err, data){
    res.json(err || data);
  });
});


app.listen(3000);
console.log('Listening on port 3000');
