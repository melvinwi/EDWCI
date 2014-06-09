var fs = require('fs'); 
var csvparse = require('csv-parse');
var logger = require('./logger.js');

var DELIMITER = '\t';
var ROW_DELIMITER = '\n';




function parse(file, containsColumnNames, callback) {


	var config = {}

	if (containsColumnNames==true) {
		config = {delimiter: DELIMITER, rowDelimiter: ROW_DELIMITER, trim: true, auto_parse: true, comment: '#', columns: true};
	}
	else {
		config = {delimiter: DELIMITER, rowDelimiter: ROW_DELIMITER, trim: true, auto_parse: true, comment: '#'};
	}

	
	file = file.toString();

	logger.debug('about to read file: '+file, debug);

	var input = fs.readFileSync(file).toString();
	
	csvparse(input, config, function(err, output){
		if (err) {
			throw err;
		}
		else {
			callback(output);
		}
	});
}



module.exports = {
  parse: function(file, containsColumnNames, callback) {
    parse(file, containsColumnNames, callback);
  }
};
