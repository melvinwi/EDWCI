// load modules
var fs = require('fs');
var express = require('express');
var https = require('https');
var app = express();
var moment = require('moment');


// setup ssl options
var privateKey = fs.readFileSync('./certificates/server.key').toString();
var certificate = fs.readFileSync('./certificates/server.crt').toString();

var options = {
  key : privateKey, 
  cert : certificate,
  passphrase: "password"
}

// temp store for credentials
var credentials = new Array();


// use www directory as root static directory
app.use(express.static(__dirname + '/www'));


// global vars
var SSL_PORT = 7070; 	// for all API calls
var PORT = 8080; 		// may be used for static content
var DATE_FORMAT = 'YYYY-MM-DD HH:mm:ss' // for logging - see function log(message)
var DATE_FORMAT_EXPIRATION = 'YYYY-MM-DDTHH:mm:ss' // for logging - see function log(message)
var EXPIRE_CREDENTIAL_IN_MINUTES = 60;


// load api config
var config = {};

try {
	config = JSON.parse(fs.readFileSync('./lib/apis.json').toString());
}
catch (e) {
	process.stderr.write("ERROR: could not read / parse apis.json\n"+e+'\n');
}





// API interface for configuration in apis.json
app.get('/api/:APIName/:token', function(req, res) {


	// only support HTTPS
	if (req.secure==false) {
		var errMessage = JSON.parse('{ "ERROR": "Insecure HTTP requests not permitted for APIs - you must use HTTPS on port '+SSL_PORT+'" }')
		log(JSON.stringify(errMessage));
		res.send(errMessage);
	}	
	else {

		var object = authToken(req.params.token);

		if (object==undefined) { // token has expired or is invalid
			var errMessage = JSON.parse('{ "ERROR": "token '+req.params.token+' has expired" }');
			log(JSON.stringify(errMessage));
			res.send(errMessage);
		}
		else {

			// check if the api exists
			if (eval('config.API.'+req.params.APIName)!=undefined) {
				log('INFO: request for API "'+req.params.APIName+'"');

				// init database connection
				var db = require('./lib/db.js');

				// set username and password for connection
				db.setUsernamePassword(object.username, object.password);

				// get sql statement from config
				var sqlStatement = eval('config.API.'+req.params.APIName+'.sql');

				// replace all {{params}} embedded in sql
				var errored = false;
				var apiParams = eval('config.API.'+req.params.APIName+'.parameters')
				if (apiParams!=undefined) {
					for (var i=0; i<apiParams.length; i++) {

						var name = ''+apiParams[i].name+'';
						
						sqlStatement = eval('sqlStatement.replace(/'+name+'/g, req.param(name))');

						if (req.param(apiParams[i].name)==undefined && apiParams[i].mandatory==true) {
							var errMessage = JSON.parse('{ "ERROR" : "mandatory URL parameter ?'+apiParams[i].name+'=[value] missing for API '+req.params.APIName+'" }')
							log(JSON.stringify(errMessage));
							res.send(errMessage);
							errored = true;
						}
				 	}
				}

				if (errored==false) {
					if (sqlStatement==undefined) {
						var errMessage = JSON.parse('{ "ERROR" : "API '+req.params.APIName+' is missing SQL object; error with apis.config" }')
						log(JSON.stringify(errMessage));
						res.send(errMessage)
					}
					else {
						// execute sql statement
						db.sql(sqlStatement , function(err, result) {
							if (err) {
								var errMessage = err;
								log(JSON.stringifyerrMessage);
								res.send(errMessage); // send back to requestor
							}
							else {
								log('INFO: '+JSON.stringify(result));
								res.send(JSON.parse('{ "'+req.params.APIName+'":'+JSON.stringify(result)+" }")); // send back to requestor
							}
						});
					}
				}

			}
			else {
				var errMessage = JSON.parse('{ "ERROR": "API '+req.params.APIName+' was not found!" }');
				log(JSON.stringify(errMessage));
				res.send(errMessage)
			}
		}
	}

});



//// //// //// //// AUTHENTICATION //// //// //// //// 

// authenticate
app.get('/auth/:username/:password', function(req, res) {

	log('INFO: auth request by "'+req.params.username+'"');

	auth(req.params.username, req.params.password, function(err, object) {
		if (err) {
			var errMessage = JSON.parse('{ "ERROR": "'+err+'" }');
			log(JSON.stringify(errMessage));
			res.send(errMessage)
		}
		else {
			log('INFO: token issued for user "'+req.params.username+'" - '+object.token);
			res.send(object);
		}
	});

});



// authenticate user/pass and issue a token
function auth(username, password, callback) {

	// init database connection
	var db = require('./lib/db.js');

	// set username and password for connection
	db.setUsernamePassword(username, password);

	// execute sql statement to authenticate
	db.sql('SELECT \'nothing\'' , function(err, result) {
		if (err) {
			callback (err, undefined);
		}
		else {
			var token = createToken();

			var object = {};
			object.token = token;
			object.username = username;
			object.password = password;
			object.createdDateTime = moment().format(DATE_FORMAT_EXPIRATION);

			credentials[credentials.length] = object;

			callback (undefined, object);
		}
	});

}


// authenticate token and return user/pass object
function authToken(token) {

	var found = false;

	var newCredentialArray = credentials;

	for (var i=0; i<credentials.length; i++) {
		var object = credentials[i];

		if (hasExpired(object)==false) {

			if (object.token == token) {
				found = true;
				return object;
			}
		}
		else {
			// remove it if it's expired
			newCredentialArray.splice(i, 1);
		}
	}

	if (found==false) {
		return undefined;
	}

	// credentials 
	credentials = newCredentialArray;
}


// generate a unique token
function createToken() {
	// http://www.ietf.org/rfc/rfc4122.txt
	var s = [];
	var hexDigits = "0123456789abcdef";
	for (var i = 0; i < 36; i++) {
	    s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
	}
	s[14] = "4";  // bits 12-15 of the time_hi_and_version field to 0010
	s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);  // bits 6-7 of the clock_seq_hi_and_reserved to 01
	s[8] = s[13] = s[18] = s[23] = "-";

	var uuid = s.join("");
	return uuid;
}


// check if token has expired
function hasExpired(object) {
	
	if (moment().diff(moment(object.createdDateTime),'minutes') >= EXPIRE_CREDENTIAL_IN_MINUTES) {
		return true
	}
	else {
		return false;
	}
}



//// //// //// //// UTILITIES //// //// //// //// 


// log with date/time prefix
function log(message) {
	console.log(moment().format(DATE_FORMAT)+' '+message);
}








// init app listeners
app.listen(PORT)
https.createServer(options, app).listen(SSL_PORT);
log('listening on port '+SSL_PORT+' (HTTPS)');
log('listening on port '+PORT+' (HTTP)');



