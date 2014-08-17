var db = require('./lib/db.js');
var parser = require('./lib/parser.js');
var logger = require('./lib/logger.js');
var should = require('should');
var fs = require('fs');
var moment = require('moment');
var program = require('commander');

var DATE_FORMAT = 'YYYY-MM-DDTHHmmss' 
var DATE_FORMAT2 = 'YYYY-MM-DD HH:mm:ss' 

var source = null;
var destination = null;

var DEBUG = false;



// setup acceptable input params
program
	.option('--artefactName [name]')
	.option('--schema [schema]')
	.parse(process.argv);


if (program.artefactName && program.schema) {
	artefactName = ('%s',program.artefactName);
	schema = ('%s',program.schema);
	
	design = fs.readFileSync('../'+artefactName+'.tsv').toString();

	
	var SOURCE_SQL_FILE = 'RESULT-sql-datastore_.tsv'
	var DESTINATION_SQL_FILE = 'RESULT-sql-view_.tsv'
	var SOURCE_SQL_RESULTS = 'RESULT-sql-datastore_resultset.tsv'
	var DESTINATION_SQL_RESULTS = 'RESULT-sql-view_resultset.tsv'
	var TEST_RESULTS = 'RESULT-'+artefactName+'-'+'TESTS.tsv'

	// refresh
	try {
		fs.unlinkSync(SOURCE_SQL_FILE);
	}
	catch (e) {console.log(e)}
	try {
		fs.unlinkSync(DESTINATION_SQL_FILE);
	}
	catch (e) {console.log(e)}
	try {	
		fs.unlinkSync(SOURCE_SQL_RESULTS);
	}
	catch (e) {console.log(e)}
	try {
		fs.unlinkSync(DESTINATION_SQL_RESULTS);
	}
	catch (e) {console.log(e)}
	try {
		fs.unlinkSync(TEST_RESULTS);
	}
	catch (e) {console.log(e)}	

	// prime
	var header = '# view test result artefact\n'
	header += '# ARTEFACT: '+artefactName+'\n'
	header += '# CREATED DATE: '+moment().format(DATE_FORMAT)+'\n\n';
	fs.writeFileSync(SOURCE_SQL_FILE, header);
	fs.writeFileSync(DESTINATION_SQL_FILE, header);
	fs.writeFileSync(SOURCE_SQL_RESULTS, header);
	fs.writeFileSync(DESTINATION_SQL_RESULTS, header);
	fs.writeFileSync(TEST_RESULTS, header);


	run(artefactName, schema, design);

}
else {
	console.log('ERROR / TRANSFORM NOT TESTED - invalid usage for test_transform');
}


function logIt(artefactName, data, isResult) {
	console.log(artefactName+' | '+data.trim());
	if (isResult==true) { // else this is debug
		console.log('\n'+data.trim());
	}
	//fs.appendFile('result-'+moment().format(DATE_FORMAT)+'-'+artefactName+'.tsv', data, function(err) {
	fs.appendFile(artefactName, data, function(err) {	
		if (err) {
			console.log(err);
		}
		else {
			console.log('WROTE! '+ artefactName+' | '+data.trim());
		}
	});
}

function run(artefactName, schema, design) {
	
	

	        logger.info(artefactName, 'running TESTS', true);
	        console.log('******** ******** ******** ********')
			var exists = fs.existsSync(artefactName+'_tests.tsv');
			
			if (exists==false) {

				logger.error(artefactName, 'FAILED TESTS: missing test file ('+artefactName+'_tests.tsv)');

			}
			else {

				parser.parse(artefactName+'_tests.tsv', true, function(object) {

					executeTests(object, artefactName, schema, design)

				});
			}
	
	
}


function executeTests(object, artefactName, schema, design, i) {


	if (i==undefined) {
		i=0; // initial
	}
	
	var sourceSQL = object[i].DATASTORE_SQL;
	var destinationSQL = object[i].VIEW_SQL;
	var test = object[i].TEST;

	
	logIt(SOURCE_SQL_FILE, (i+1)+'\t'+sourceSQL+'\n');
	logIt(DESTINATION_SQL_FILE, (i+1)+'\t'+destinationSQL+'\n');


	
	runTest(sourceSQL, destinationSQL, test, i, artefactName, object.length, schema, design, function(res) {
		// recurse
		setTimeout(function() {
			
			i = i+1;
			executeTests(object, artefactName, schema, design, i);
		}, 50);
	});
	
		
}

var counter = 1;
var passedOverall = true;
function runTest(sourceSQL, destinationSQL, test, index, artefactName, test_length, schema, design, callback) {
	
	if (test.trim().length>0) {

		db.sql(sourceSQL, function(err, sourceRes) {
			try {
	            should.not.exist(err);
	        }
	        catch(e) {
	        	
	        	logIt(artefactName, moment().format(DATE_FORMAT2)+'\tFAILED\terror executing sourceSQL ('+sourceSQL+'): '+e+'\n', true);
	        	passedOverall = false;
	        }

	        if (sourceRes) {
	        	
	        	source = sourceRes;
	        	logIt(SOURCE_SQL_RESULTS, (index+1)+'\t'+JSON.stringify(source)+'\n');

	        	db.sql(destinationSQL, function(err2, destinationRes) {
	        		try {
	                	should.not.exist(err2);
		            }
		            catch(e) {
		            	
	        			logIt(artefactName, moment().format(DATE_FORMAT2)+'\tFAILED\terror executing destinationSQL ('+destinationSQL+'): '+e+'\n', true);
	        			passedOverall = false;

	        			counter++;
		            	areTestsFinished(counter, test_length, artefactName, schema, design)
		            	callback('OK');
		            }

		            if (destinationRes) {
		            	
		            	destination = destinationRes;

						logIt(DESTINATION_SQL_RESULTS, (index+1)+'\t'+JSON.stringify(destination)+'\n');
						

		            	var result = '';

		            	try {
		            		
		            		result +=moment().format(DATE_FORMAT2)+'\t'+(index+1)+'\tPASSED\t'+test+'\t'+JSON.stringify(eval(test))+''
		            	}
		            	catch(erro) {
		            		if (JSON.stringify(erro)=='{}') {
		            			result +=moment().format(DATE_FORMAT2)+'\t'+(index+1)+'\tFAILED\t'+test+' problem processing test - please update\t'+erro;
		            			passedOverall = false;
		            		}
		            		else {
		            			result +=moment().format(DATE_FORMAT2)+'\t'+(index+1)+'\tFAILED\t'+test+'\t'+JSON.stringify(erro);
		            			passedOverall = false;
		            		}
		            	}


		            	logIt(TEST_RESULTS, result+'\n', true);
		            	counter++;
		            	areTestsFinished(counter, test_length, artefactName, schema, design)
		            	callback('OK');
		            }

	        	});
	        }
	        else {
		        counter++;
		        areTestsFinished(counter, test_length, artefactName, schema, design)
		        callback('OK');
	        }
		});
	}
	else {
		counter++;
		areTestsFinished(counter, test_length, artefactName, schema, design)
		callback('OK');
	}
		
}



function areTestsFinished(counter, test_length, artefactName, schema, design) {
	
    if (counter==test_length+1) {

    	if (passedOverall == false) {
    		console.log('******** ******** ******** ********')
    		logger.error(artefactName, 'FAILED TESTS');
    		
    	}
    	else {
    		console.log('\n******** ******** ******** ********')
    		logger.OK(artefactName, 'PASSED TESTS');

    		// GENERATE DOCUMENATION         
            var GenerateDoc = require('./test_generate_doc.js');
            var generateDoc = new GenerateDoc(artefactName, schema, design); 

    	}
    	console.log('\n-- see the following files for further details')
    	console.log(''+SOURCE_SQL_FILE+' - source sql executed');
    	console.log(''+DESTINATION_SQL_FILE+' - destination sql executed');
    	console.log(''+SOURCE_SQL_RESULTS+' - source result set');
    	console.log(''+DESTINATION_SQL_RESULTS+' - destination result set');

    	console.log('')

	    }
}


module.exports = run;