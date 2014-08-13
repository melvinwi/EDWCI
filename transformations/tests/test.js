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
		
		var design = fs.readFileSync(input);

		if (input.indexOf('/')!=-1) { 
			input = input.split('/')[1] 
		}
		else if (input.indexOf('\\')!=-1) { 
			input = input.split('\\')[1] // windowze
		}
		
		var artefactName = input.split('.')[0];

		logger.info(artefactName, 'running DESIGN tests');

		var success = true;

		var selectionCriteria = ''; // will parse out and store the selection criteria
		
		var counter = 0;
		// RUN DESIGN ARTEFACT TESTS
		object.forEach(function(row, index) { // check every line
			try {
				if (index-1!=object.length) { // not the last row
					row.should.have.properties('SOURCE_FUNCTION_PREFIX', 'SOURCE', 'SOURCE_FUNCTION_SUFFIX', 'DESTINATION', 'DESCRIPTION');
				}
				else {
					row.should.have.property('SELECTION_CRITERIA')
				}


				if (row.SOURCE_FUNCTION_PREFIX.indexOf('SELECTION_CRITERIA')==-1) { // not the last row

					// check source artefact exists
					var source = row.SOURCE.split('.')[0]+'.tsv';

					// this is an alias if prefixed with _
					if (source.substring(0,1)!='_') {
						if (source!='.tsv') {
							if (fs.existsSync('../../staging/'+source)!=true)
								throw 'missing SOURCE ../../staging/'+source+' NOTE: if this is an alias (i.e. SELECT col FROM table_name AS alias_name, please prefix the alias name with "_" to ignore';
						}
					}



					// check destination artefact exists
					var destination = row.DESTINATION.split('.')[0]+'.tsv';
					
					
					if (destination!='.tsv') {
						if (fs.existsSync('../../datastore/'+destination)!=true)
							throw 'missing SOURCE ../../datastore/'+destination;
					}
					
				}
				else {
					selectionCriteria = row.SOURCE;
				}

			} catch(e) {
				// ERROR
				logger.error(JSON.stringify(row), 'test error line ('+index+'): '+ e);
				success = false;
			}

			counter++;

			if (counter==object.length) {
				if (success==true) {
					logger.OK(artefactName, 'PASSED DESIGN tests');
				}
				else {
					logger.error(artefactName, 'FAILED DESIGN tests');	
					process.exit();
				}
			}

		});


		// RUN BUILD ARTEFACT TESTS			
		var BuildTest = require('./test_build.js');
		var runBuild = new BuildTest(artefactName, object, schema, design, selectionCriteria);	
		


	});

}
else {
	program.help()
}