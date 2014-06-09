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

				row.TYPE.toLowerCase().should.match(/int|varchar|datetime/)

				if (row.TYPE!='datetime') {
					row.LENGTH.should.be.a.Number;
				}

				row.NOT_NULL.toLowerCase().should.match(/true|false/)

				row.PK.toLowerCase().should.match(/true|/)

				
				row.AUTO_INCREMENT.toLowerCase().should.match(/true|false/)


			} catch(e) {
				// ERROR
				logger.error(JSON.stringify(row), e);
				success = false;
			}

			counter++;

			if (counter==object.length) {
				if (success==true) {
					logger.OK(artefactName, 'PASSED DESIGN tests');

					// RUN DICTIONARY TESTS			
					var DictionaryTest = require('./test_dictionary.js');
					var runDictionary = new DictionaryTest(artefactName, object, schema, function(resss) {	

						// RUN BUILD ARTEFACT TESTS			
						var BuildTest = require('./test_build.js');
						var runBuild = new BuildTest(artefactName, object, schema, design);	
					});
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