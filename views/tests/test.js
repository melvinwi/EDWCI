var fs = require('fs');
var parser = require('./lib/parser.js');
var logger = require('./lib/logger.js');

var should = require('should');
var program = require('commander');

var sys = require('sys')
var exec = require('child_process').exec;


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

		if (object.length==0) {
			logger.error(artefactName, 'FAILED DESIGN tests - missing content');	
			process.exit();
		};

		// RUN DESIGN ARTEFACT TESTS
		object.forEach(function(row, index) { // check every line
			try {
				if (index-1!=object.length) { // not the last row
					row.should.have.properties('ATTRIBUTE_NAME','DEFINITION', 'RULE_DESCRIPTION', 'DATASTORE_OBJECTS', 'DATASTORE_ATTRIBUTES');
				}


				// check sources artefacts exist
				var sources = row.DATASTORE_OBJECTS.split(',');

				for (var i=0; i<sources.length; i++) {

					var source = sources.toString().trim().split('.')[0]+'.tsv';

					// this is an alias if prefixed with _
					if (source.substring(0,1)!='_') {
						if (source!='.tsv') {
							if (fs.existsSync('../../datastore/'+source)!=true)
								throw 'missing SOURCE ../../datastore/'+source;
						}
					}
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
		//var BuildTest = require('./test_build.js');
		//var runBuild = new BuildTest(artefactName, object, schema, design, selectionCriteria);	
		
		// RUN TESTS
		runTests(artefactName, schema)


	});

}
else {
	program.help()
}



function runTests(artefactName, schema) {
    // executes command
    var cmd = 'node test_view.js --artefactName '+artefactName+' --schema '+schema;
    
    console.log(cmd);

    child = exec(cmd, function (error, stdout, stderr) {
      if (stdout) {
        console.log(stdout);
      }
      else if (error){
        console.log(error);
      }
      else if (stderr){
        console.log(stderr);
      }

      process.exit();
    });

}

