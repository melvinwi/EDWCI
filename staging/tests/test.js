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
		else if (input.indexOf('\\')!=-1) { 
			input = input.split('\\')[1] // windowze
		}

		var artefactName = input.split('.')[0];



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
				row.TYPE.toLowerCase().should.match(/binary|bit|datetime|datetime2|decimal|int|integer|money|nchar|numeric|nvarchar|varchar/)
			}
			catch(e) {
				// ERROR
				logger.error('error with TYPE', 'incorrect TYPE in row '+(index+1)+' ('+row.COLUMN+') - value: "'+row.TYPE+'" should be one of: binary|bit|datetime|datetime2|decimal|int|integer|money|nchar|numeric|nvarchar|varchar');
				success = false;
			}

			try {
				if (row.TYPE.toLowerCase().trim()=='decimal') {
					try {
						row.LENGTH.should.containEql(',');

						var parts = row.LENGTH.split(',');

						Number(parts[0]).should.be.a.Number;

						Number(parts[1]).should.be.a.Number;

						Number(parts[0]).should.be.greaterThan(parts[1]);
					}
					catch(ee) {
						logger.error('ERROR with LENGTH', 'incorrect decimal must contain format "M,D" where M is the maximum number of digits (the precision) and D is the number of digits to the right of the decimal point (the scale), and M is greater than D'+(index+1)+' ('+row.COLUMN+') - value: "'+row.LENGTH+'"');
						success = false;
					}
					
				}
				else if (row.TYPE.toLowerCase().trim()!='datetime' || row.TYPE.toLowerCase().trim()!='date') {
					
					if (row.TYPE.toLowerCase().trim()=='integer' || row.TYPE.toLowerCase().trim()=='int') {
						row.TYPE='INT';

						if (row.LENGTH.length==0) {
							row.LENGTH = 18; // default to 18
						}
					}
					

					Number(row.LENGTH).should.be.a.Number;
				}
			}
			catch(e) {
				// ERROR
				logger.error('ERROR with LENGTH', 'incorrect LENGTH in row '+(index+1)+' ('+row.COLUMN+') - value: "'+row.LENGTH+'" must contain an integer');
				success = false;
			}

			try {
				row.NOT_NULL.toLowerCase().should.match(/true|false|^$/)
			}
			catch(e) {
				// ERROR
				logger.error('ERROR with NOT_NULL', 'incorrect NOT_NULL in row '+(index+1)+' ('+row.COLUMN+') - value: "'+row.NOT_NULL+'" must contain: true|false|^$ (i.e. true|false or empty == false)');
				success = false;
			}	

			try {
				row.PK.toLowerCase().should.match(/true|false|^$/)
			}
			catch(e) {
				// ERROR
				logger.error('ERROR with PK', 'incorrect PK in row '+(index+1)+' ('+row.COLUMN+') - value: "'+row.PK+'" must contain: true|false|^$ (i.e. true|false or empty == false)');
				success = false;
			}		

			try {	
				row.AUTO_INCREMENT.toLowerCase().should.match(/true|false|^$/)
			}
			catch(e) {
				// ERROR
				logger.error('ERROR with AUTO_INCREMENT', 'incorrect AUTO_INCREMENT in row '+(index+1)+' ('+row.COLUMN+') - value: "'+row.AUTO_INCREMENT+'" must contain: true|false|^$ (i.e. true|false or empty == false)');
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