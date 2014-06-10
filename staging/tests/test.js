var fs = require('fs');
var parser = require('./lib/parser.js');
var logger = require('./lib/logger.js');

var should = require('should');
var program = require('commander');

// setup acceptable input params
program
	.option('--file <name>')
	.option('--schema <name>')
	.parse(process.argv);


// execute
if (program.file && program.schema) {

	var input = ('%s',program.file);
	var schema = ('%s',program.schema);

	parser.parse(input, true, function(object) {

		var design = fs.readFileSync(input).toString();

		//input = program.args.toString();
		if (input.indexOf('/')!=-1) { 
			input = input.split('/')[1] 
		}
		var artefactName = input.split('.')[0];

		console.log('artefactName: '+artefactName);
		

		logger.info(artefactName, 'running DESIGN tests');

		var success = true;

		var counter = 0;
		// RUN DESIGN ARTEFACT TESTS
		object.forEach(function(row, index) { // check every line
			try {
				row.should.have.properties('COLUMN', 'TYPE', 'DESC', 'LENGTH', 'DEFAULT', 'NOT_NULL', 'PK', 'AUTO_INCREMENT');
			} catch(e) {
				// ERROR
				logger.error('FAILED DESIGN tests', 'missing one or more column headers - should have: COLUMN, TYPE, DESC, LENGTH, DEFAULT, NOT_NULL, PK, AUTO_INCREMENT');
				success = false;
				process.exit();
			}
			
			try {	
				row.TYPE.toLowerCase().should.match(/int|varchar|datetime/)
			}
			catch(e) {
				// ERROR
				logger.error('error with TYPE', 'incorrect TYPE in row '+(index+1)+' - value: "'+row.TYPE+'" should be one of: int|varchar|datetime');
				success = false;
			}

			try {
				if (row.TYPE!='datetime') {
					row.LENGTH.should.be.a.Number;
				}
			}
			catch(e) {
				// ERROR
				logger.error('ERROR with LENGTH', 'incorrect LENGTH in row '+(index+1)+' - value: "'+row.LENGTH+'" must contain an integer');
				success = false;
			}

			try {
				row.NOT_NULL.toLowerCase().should.match(/true|false|^$/)
			}
			catch(e) {
				// ERROR
				logger.error('ERROR with NOT_NULL', 'incorrect NOT_NULL in row '+(index+1)+' - value: "'+row.NOT_NULL+'" must contain: true|false|^$ (i.e. true|false or empty == false)');
				success = false;
			}	

			try {
				row.PK.toLowerCase().should.match(/true|false|^$/)
			}
			catch(e) {
				// ERROR
				logger.error('ERROR with PK', 'incorrect PK in row '+(index+1)+' - value: "'+row.PK+'" must contain: true|false|^$ (i.e. true|false or empty == false)');
				success = false;
			}		

			try {	
				row.AUTO_INCREMENT.toLowerCase().should.match(/true|false|^$/)
			}
			catch(e) {
				// ERROR
				logger.error('ERROR with AUTO_INCREMENT', 'incorrect AUTO_INCREMENT in row '+(index+1)+' - value: "'+row.AUTO_INCREMENT+'" must contain: true|false|^$ (i.e. true|false or empty == false)');
				success = false;
			}		


			// } catch(e) {
			// 	// ERROR
			// 	logger.error(JSON.stringify(row), JSON.stringify(e));
			// 	success = false;
			// }

			counter++;

			if (counter==object.length) {
				if (success==true) {
					logger.OK(artefactName, 'PASSED DESIGN tests');

					// RUN BUILD ARTEFACT TESTS			
					var BuildTest = require('./test_build.js');
					var runBuild = new BuildTest(artefactName, object, schema, design);	
				}
				else {
					logger.error(artefactName, 'FAILED DESIGN tests');
				}

			}

		});


		
		


	});

}
else {
	program.help()
}