var fs = require('fs');

var Promise = require('promise');

//var readFile = Promise.denodeify(require('fs').readFile);
// now `readFile` will return a promise rather than expecting a callback

var finishedFlag = false;
var finishedObject = undefined;

function readJSON(filename){
  // If a callback is provided, call it with error as the first argument
  // and result as the second argument, then return `undefined`.
  // If no callback is provided, just return the promise.
  //return readFile(filename, 'utf8').then(JSON.parse).nodeify(callback);

  fs.readFile(filename, 'utf8', function(err, result) {
  	setTimeout(function() {
	  	var object = {};
	  	object.err = err;
	  	object.result = result;
	  	didFinish(object);
	},1000);
  });
}


function didFinish(object) {
	finishedObject = object
	finishedFlag = true;
}

function checkFinished() {
	return finishedObject;
}

function wasFinished() {
	setTimeout(function() {
		if (checkFinished()!=undefined) {
			
		}
		else {
			wasFinished();
		}
	}, 100);
}



readJSON('db_config.json');
if (wasFinished()==true) {
	console.log(JSON.stringify(wasFinished()));
}



