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
	.option('--sourceTables [name]')
	.option('--destinationTable [name]')
	.option('--sourceColumns [name]')
	.option('--destinationColumns [name]')
	.option('--schema [schema]')
	.parse(process.argv);


if (program.artefactName && program.sourceTables && program.destinationTable && program.sourceColumns && program.destinationColumns && program.schema) {
	artefactName = ('%s',program.artefactName);
	sourceTables = ('%s',program.sourceTables);
	destinationTable = ('%s',program.destinationTable);
	sourceColumns = ('%s',program.sourceColumns);
	destinationColumns = ('%s',program.destinationColumns);
	schema = ('%s',program.schema);

	


	var SOURCE_SQL_FILE = 'RESULT-sql-source_.csv'
	var DESTINATION_SQL_FILE = 'RESULT-sql-destination_.csv'
	var SOURCE_SQL_RESULTS = 'RESULT-sql-source_resultset.csv'
	var DESTINATION_SQL_RESULTS = 'RESULT-sql-destination_resultset.csv'
	var TEST_RESULTS = 'RESULT-'+artefactName+'-'+'TESTS.csv'

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
	var header = '# transformation test result artefact\n'
	header += '# ARTEFACT: '+artefactName+'\n'
	header += '# CREATED DATE: '+moment().format(DATE_FORMAT)+'\n\n';
	fs.writeFileSync(SOURCE_SQL_FILE, header);
	fs.writeFileSync(DESTINATION_SQL_FILE, header);
	fs.writeFileSync(SOURCE_SQL_RESULTS, header);
	fs.writeFileSync(DESTINATION_SQL_RESULTS, header);
	fs.writeFileSync(TEST_RESULTS, header);


	run(artefactName, sourceTables, destinationTable, sourceColumns, destinationColumns, schema);

}
else {
	console.log('ERROR / TRANSFORM NOT TESTED - invalid usage for test_transform');
}


function logIt(artefactName, data, isResult) {
	if (isResult==true) { // else this is debug
		console.log(data.trim());
	}
	//fs.appendFile('result-'+moment().format(DATE_FORMAT)+'-'+artefactName+'.csv', data, function(err) {
	fs.appendFile(artefactName, data, function(err) {	
		if (err) {
			console.log(err);
		}
	});
}

function run(artefactName, sourceTables, destinationTable, sourceColumns, destinationColumns, schema) {
	
	sourceTables = sourceTables.split(',');
	var sourceTablesFrom = '';

	for (var i=0; i<sourceTables.length; i++) {
		sourceTablesFrom += '`'+schema+'`.`'+sourceTables[i]+'`';

		if (i!=sourceTables.length-1) {
			sourceTablesFrom += ',';
		}
	}


	sourceColumns = sourceColumns.split(',');
	var sourceColumnsFrom = '';

	for (var i=0; i<sourceColumns.length; i++) {

		var parts = sourceColumns[i].split('.'); // cater for [table].[col] notatation
		if (parts.length==2) {
			sourceColumns[i] = parts[0]+'`.`'+parts[1];
			//logIt('here-source', sourceColumns[i]);
		}

		if (sourceColumns[i].trim().length>0) {
			sourceColumnsFrom += '`'+schema+'`.`'+sourceColumns[i]+'`';

			if (i!=sourceColumns.length-1) {
				sourceColumnsFrom += ',';
			}
		}
	}
	if (sourceColumnsFrom.substring(sourceColumnsFrom.length-1, sourceColumnsFrom.length)==',') {
		sourceColumnsFrom = sourceColumnsFrom.substring(0, sourceColumnsFrom.length-1);
	}


	destinationColumns = destinationColumns.split(',');
	var destinationColumnsFrom = '';

	for (var i=0; i<destinationColumns.length; i++) {

		var parts = destinationColumns[i].split('.'); // cater for [table].[col] notatation
		if (parts.length==2) {
			destinationColumns[i] = parts[0]+'`.`'+parts[1];
			//logIt('here-destintation', destinationColumns[i]);
		}
		
		if (destinationColumns[i].trim().length>0) {
			destinationColumnsFrom += '`'+schema+'`.`'+destinationColumns[i]+'`';

			if (i!=destinationColumns.length-1) {
				destinationColumnsFrom += ',';
			}
		}
	}
	if (destinationColumnsFrom.substring(destinationColumnsFrom.length-1, destinationColumnsFrom.length)==',') {
		destinationColumnsFrom = destinationColumnsFrom.substring(0, destinationColumnsFrom.length-1);
	}

	//logIt('sourceColumnsFrom', sourceColumnsFrom);
	//logIt('destinationColumnsFrom', destinationColumnsFrom);

	logger.info(artefactName, 'running EXECUTE transformation procedure', true);

	// execute procedure
    db.sql('CALL `'+schema+'`.`'+artefactName+'`', function(err, result) {
        //console.log(result);
        try {
            should.not.exist(err);

            if (result) {
	            logger.OK(artefactName, 'PASSED EXECUTE transformation procedure', true);
	        }

	        logger.info(artefactName, 'running TESTS', true);

			var exists = fs.existsSync(artefactName+'_tests.csv');
			
			if (exists==false) {

				logger.error(artefactName, 'FAILED TESTS: missing test file ('+artefactName+'_tests.csv)');

			}
			else {

				parser.parse(artefactName+'_tests.csv', true, function(object) {

					for (var i=1; i<object.length; i++) {

						var sourceSQL = 'SELECT '+sourceColumnsFrom+' FROM '+sourceTablesFrom+' '+object[i].SOURCE_SELECTION_CRITERIA//.replace(/'/g, '"')
						var destinationSQL = 'SELECT '+destinationColumnsFrom+' FROM `'+schema+'`.`'+destinationTable+'` '+object[i].DESTINATION_SELECTION_CRITERIA//.replace(/'/g, '"')
						var test = object[i].TEST;
						
						logIt(SOURCE_SQL_FILE, sourceSQL+'\n');
						logIt(DESTINATION_SQL_FILE, destinationSQL+'\n');

						runTest(sourceSQL, destinationSQL, test, i, artefactName, object.length)
						
					}

				});
			}

		}
        catch(ee) {
            // ERROR
            //logger.error(artefactName, 'problem executing procedure: '+ee)
            logger.error(artefactName, 'FAILED EXECUTE transformation procedure: '+ee, true);
            process.exit();
        }

    });
	
	
}


var counter = 1;
var passedOverall = true;
function runTest(sourceSQL, destinationSQL, test, index, artefactName, test_length) {

	
	if (test.trim().length>0) {

		db.sql(sourceSQL, function(err, sourceRes) {
			try {
	            should.not.exist(err);
	        }
	        catch(e) {
	        	//
	        	//logger.error(artefactName, 'error executing sql ('+sourceSQL+'): '+e)
	        	logIt(artefactName, moment().format(DATE_FORMAT2)+'\tFAILED\terror executing sourceSQL ('+sourceSQL+'): '+e+'\n', true);
	        }

	        if (sourceRes) {
	        	
	        	source = sourceRes;
	        	logIt(SOURCE_SQL_RESULTS, JSON.stringify(source)+'\n');

	        	db.sql(destinationSQL, function(err2, destinationRes) {
	        		try {
	                	should.not.exist(err2);
		            }
		            catch(e) {
		            	//
		            	//logger.error(artefactName, 'error executing sql ('+destinationSQL+'): '+e)
		            	//logger.error(artefactName, 'error executing sql ('+sourceSQL+'): '+e)
	        			logIt(artefactName, moment().format(DATE_FORMAT2)+'\tFAILED\terror executing sourceSQL ('+destinationSQL+'): '+e+'\n', true);
	        			passedOverall = false;
		            }

		            if (destinationRes) {
		            	//console.log(res2);
		            	destination = destinationRes;
						logIt(DESTINATION_SQL_RESULTS, JSON.stringify(destination)+'\n');
						

		            	var result = '';

		            	try {
		            		result +=moment().format(DATE_FORMAT2)+'\tPASSED\t'+test+'\t'+JSON.stringify(eval(test))
		            	}
		            	catch(erro) {
		            		if (JSON.stringify(erro)=='{}') {
		            			result +=moment().format(DATE_FORMAT2)+'\tFAILED\t'+test+' problem processing test - please update\t'+erro;
		            			passedOverall = false;
		            		}
		            		else {
		            			result +=moment().format(DATE_FORMAT2)+'\tFAILED\t'+test+'\t'+JSON.stringify(erro);
		            			passedOverall = false;
		            		}
		            	}


		            	logIt(TEST_RESULTS, result+'\n', true);
		            	counter++;
		            	areTestsFinished(counter, test_length)
		            }

	        	});
	        }
		});
	}
	else {
		counter++;
		areTestsFinished(counter, test_length)
	}
		
}



function areTestsFinished(counter, test_length) {
	
    if (counter==test_length) {

    	if (passedOverall == false) {
    		logger.error(artefactName, 'FAILED TESTS');
    		process.exit();
    	}
    	else {
    		logger.OK(artefactName, 'PASSED TESTS');
    		process.exit();
    	}
    	console.log('\n-- see the following files for further details')
    	console.log(''+SOURCE_SQL_FILE+' - source sql executed');
    	console.log(''+DESTINATION_SQL_FILE+' - destination sql executed');
    	console.log(''+SOURCE_SQL_RESULTS+' - source result set');
    	console.log(''+DESTINATION_SQL_RESULTS+' - destination result set');

    	console.log('')
    	process.exit();
	    }
}


module.exports = run;