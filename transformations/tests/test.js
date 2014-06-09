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
		
		if (input.indexOf('/')!=-1) { 
			input = input.split('/')[1] 
		}
		var artefactName = input.split('.')[0];

		logger.info(artefactName, 'running DESIGN tests');

		var success = true;
		
		var counter = 0;
		// RUN DESIGN ARTEFACT TESTS
		object.forEach(function(row, index) { // check every line
			try {
				if (index-1!=object.length) { // not the last row
					row.should.have.properties('SOURCE', 'DESTINATION', 'SOURCE_FUNCTION_PREFIX', 'SOURCE_FUNCTION_SUFFIX', 'DESCRIPTION');
				}
				else {
					row.should.have.property('SELECTION_CRITERIA')
				}


				if (row.SOURCE_FUNCTION_PREFIX.indexOf('SELECTION_CRITERIA')==-1) { // not the last row

					// check source artefact exists
					var source = row.SOURCE.split('.')[0]+'.csv';

					if (fs.existsSync('../../staging/'+source)!=true)
						throw 'missing SOURCE ../../staging/'+source;



					// check destination artefact exists
					var destination = row.DESTINATION.split('.')[0]+'.csv';
					
					if (fs.existsSync('../../datastore/'+destination)!=true)
						throw 'missing SOURCE ../../datastore/'+destination;
					
				}

			} catch(e) {
				// ERROR
				logger.error(JSON.stringify(row), 'test error: '+ e);
				success = false;
			}

			counter++;

			if (counter==object.length) {
				if (success==true) {
					logger.OK(artefactName, 'PASSED DESIGN tests');
				}
				else {
					logger.error(artefactName, 'FAILED DESIGN tests');	
				}
			}

		});


		// RUN BUILD ARTEFACT TESTS			
		var BuildTest = require('./test_build.js');
		var runBuild = new BuildTest(artefactName, object, schema);	
		


	});

}
else {
	program.help()
}