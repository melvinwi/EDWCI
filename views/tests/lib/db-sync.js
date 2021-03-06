
var DEBUG = false;

var hdb = require('hdb');
var mysql = require('mysql');
var fs = require('fs');
var asyncblock = require('asyncblock');

var dbClient = null;

var DB_USERNAME = '';
var DB_PASSWORD = '';

// default values below; override with --profle=<profilename> in config.json
var DB_SERVER;
var DB_PORT;
var DB_TYPE; // MYSQL or HANA
var PROFILE_NAME= 'MYSQLLOCAL'; // refers to the name in the db_config.json


var config = {};

try {
	config = JSON.parse(fs.readFileSync('./lib/db_config.json').toString());
}
catch (e) {
	process.stderr.write("ERROR: could not read / parse db_config.json\n"+e+'\n');
	end();
}





if (eval('config.Profiles[0].'+PROFILE_NAME)==undefined) {
	console.log('DB CONFIG ERROR: db_config.json does not contain profile "'+PROFILE_NAME+'"\n');
	end();
}
else {
	profile = eval('config.Profiles[0].'+PROFILE_NAME+'[0]');
}

if (profile.DBType==undefined) {
	console.log('DB CONFIG ERROR: config.json profile "'+PROFILE_NAME+'" missing "DBType"\n');
	end();
}
else {
	DB_TYPE = profile.DBType;
}

if (profile.DBServer==undefined) {
	console.log('DB CONFIG ERROR: config.json profile "'+PROFILE_NAME+'" missing "DBServer"\n');
	end();
}
else {
	DB_SERVER = profile.DBServer
}

if (profile.DBPort==undefined) {
	console.log('DB CONFIG ERROR: config.json profile "'+PROFILE_NAME+'" missing "DBPort"\n');
	end();
}
else {
	DB_PORT = profile.DBPort;
}

if (profile.DBUsername==undefined) {
	console.log('DB CONFIG ERROR: config.json profile "'+PROFILE_NAME+'" missing "DBUsername"\n');
	end();
}
else {
	DB_USERNAME = profile.DBUsername;
}

if (profile.DBPassword==undefined) {
	console.log('DB CONFIG ERROR: config.json profile "'+PROFILE_NAME+'" missing "DBPassword"\n');
	end();
}
else {
	DB_PASSWORD = profile.DBPassword;
}






function db() { // constructor
}



function initDBClient() {

	if (DB_TYPE=='HANA') {

		// // attempt the database connnection
		// this.dbClient = hdb.createClient({
		//     host     : DB_SERVER,
		//     port     : DB_PORT,
		//     user     : DB_USERNAME,
		//     password : DB_PASSWORD
		// });
		// this.dbClient.connect(function (err) {
		//   if (err) {
		//     process.stderr.write("ERROR: couldn't connect to database " + DB_SERVER + ":" + DB_PORT + "\n" + err);
		//     process.kill();
		//   }
		// 	debug("Connected to database " + DB_SERVER + ":" + DB_PORT + "\n");
		// 	callback(this.dbClient);
		// });
	}
	else if (DB_TYPE=='MYSQL') {
		this.dbClient = mysql.createConnection({
		  host     : DB_SERVER,
		  port     : DB_PORT,
		  user     : DB_USERNAME,
		  password : DB_PASSWORD
		});

		this.dbClient.connect();

		debug("connected to database " + DB_SERVER + ":" + DB_PORT);
		return this.dbClient;
	}
	else {
		process.stderr.write("ERROR: incorrect DB_TYPE ("+DB_TYPE+') - only HANA or MYSQL are supported');
		process.kill();
	}
}



module.exports = {
  sql: function(statement) {
    sql(statement);
  }
};

function sql(statement) {

	// initialise database connection
	var dbClientResponse = initDBClient();

	debug(statement);

	if (DB_TYPE=='HANA') {
		// dbClientResponse.exec(statement, function (err, result) {

		// 	debug("executed statement '" + statement + "'");
		// 	debug(JSON.stringify(result));
		// 	callback(err, result);

		// });
	}
	else if (DB_TYPE=='MYSQL') {
		
		asyncblock(function(flow){

			try {

				dbClientResponse.query(statement, flow.add());//function (err, result) {
				var results = flow.wait();
				console.log('result received');

			}
			catch(err) {
				debug(err);
				return [err, null];
			}

			debug("executed statement '" + statement + "'");
			//callback(err, result);
			return results;
		  
		});
	}
	else {
		process.stderr.write("ERROR: incorrect DB_TYPE ("+DB_TYPE+') - only HANA or MYSQL are supported');
		process.kill();
	}

}



function debug(string) {
	if (DEBUG==true) {
		console.log('DEBUG: '+string);
	}
}






function end() {
	process.exit();
}

