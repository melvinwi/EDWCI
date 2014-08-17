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
	.option('--dbType [dbType]')
	.option('--selectionCriteria [selectionCriteria]')
	.parse(process.argv);


if (program.artefactName && program.sourceTables && program.destinationTable && program.sourceColumns && program.destinationColumns && program.schema && program.dbType && program.selectionCriteria) {
	artefactName = ('%s',program.artefactName);
	sourceTables = ('%s',program.sourceTables);
	destinationTable = ('%s',program.destinationTable);
	sourceColumns = ('%s',program.sourceColumns);
	destinationColumns = ('%s',program.destinationColumns);
	schema = ('%s',program.schema);
	dbType = ('%s',program.dbType);
	selectionCriteria = ('%s',program.selectionCriteria);
	design = fs.readFileSync('../'+artefactName+'.tsv').toString();

	
	var SOURCE_SQL_FILE = 'RESULT-sql-source_.tsv'
	var DESTINATION_SQL_FILE = 'RESULT-sql-destination_.tsv'
	var SOURCE_SQL_RESULTS = 'RESULT-sql-source_resultset.tsv'
	var DESTINATION_SQL_RESULTS = 'RESULT-sql-destination_resultset.tsv'
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
	var header = '# transformation test result artefact\n'
	header += '# ARTEFACT: '+artefactName+'\n'
	header += '# CREATED DATE: '+moment().format(DATE_FORMAT)+'\n\n';
	fs.writeFileSync(SOURCE_SQL_FILE, header);
	fs.writeFileSync(DESTINATION_SQL_FILE, header);
	fs.writeFileSync(SOURCE_SQL_RESULTS, header);
	fs.writeFileSync(DESTINATION_SQL_RESULTS, header);
	fs.writeFileSync(TEST_RESULTS, header);


	run(artefactName, sourceTables, destinationTable, sourceColumns, destinationColumns, schema, design, selectionCriteria);

}
else {
	console.log('ERROR / TRANSFORM NOT TESTED - invalid usage for test_transform');
}


function logIt(artefactName, data, isResult) {
	if (isResult==true) { // else this is debug
		console.log('\n'+data.trim());
	}
	//fs.appendFile('result-'+moment().format(DATE_FORMAT)+'-'+artefactName+'.tsv', data, function(err) {
	fs.appendFile(artefactName, data, function(err) {	
		if (err) {
			console.log(err);
		}
	});
}

function run(artefactName, sourceTables, destinationTable, sourceColumns, destinationColumns, schema, design, selectionCriteria) {
	
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
			//sourceColumnsFrom += '`'+schema+'`.`'+sourceColumns[i]+'`';
			sourceColumnsFrom += '`'+sourceColumns[i]+'`';

			if (i!=sourceColumns.length-1) {
				sourceColumnsFrom += ',';
			}
		}
	}
	if (sourceColumnsFrom.substring(sourceColumnsFrom.length-1, sourceColumnsFrom.length)==',') {
		sourceColumnsFrom = sourceColumnsFrom.substring(0, sourceColumnsFrom.length-1);
	}

	// quick fix for sourcing all data
	// sourceColumnsFrom = ' * ' -- doesn't work!

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

	var callProcSQL = '';

	if (dbType=='MYSQL') {
		callProcSQL = 'CALL `'+schema+'`.`'+artefactName+'`';
	}
	else if (dbType=='SQLSERVER') {
		callProcSQL = 'EXEC '+schema+'.'+artefactName+'';	
	}

    db.sql(callProcSQL, function(err, result) {
        
        try {
            should.not.exist(err);

            if (result) {
	            logger.OK(artefactName, 'PASSED EXECUTE transformation procedure', true);
	        }

	        logger.info(artefactName, 'running TESTS', true);
	        console.log('******** ******** ******** ********')
			var exists = fs.existsSync(artefactName+'_tests.tsv');
			
			if (exists==false) {

				logger.error(artefactName, 'FAILED TESTS: missing test file ('+artefactName+'_tests.tsv)');

			}
			else {

				parser.parse(artefactName+'_tests.tsv', true, function(object) {

					// for (var i=0; i<object.length; i++) {

					// 	var sourceSQL = 'SELECT '+sourceColumnsFrom+' FROM '+sourceTablesFrom+' '+object[i].SOURCE_SELECTION_CRITERIA//.replace(/'/g, '"')
					// 	var destinationSQL = 'SELECT '+destinationColumnsFrom+' FROM `'+schema+'`.`'+destinationTable+'` '+object[i].DESTINATION_SELECTION_CRITERIA//.replace(/'/g, '"')
					// 	var test = object[i].TEST;
						
					// 	logIt(SOURCE_SQL_FILE, sourceSQL+'\n');
					// 	logIt(DESTINATION_SQL_FILE, destinationSQL+'\n');


						
					// 	runTest(sourceSQL, destinationSQL, test, i, artefactName, object.length, schema, design, sourceTables, destinationTable)
						
					// }

					executeTests(object, sourceColumnsFrom, destinationColumnsFrom, schema, destinationTable, sourceTablesFrom, artefactName)

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


function executeTests(object, sourceColumnsFrom, destinationColumnsFrom, schema, destinationTable, sourceTablesFrom, artefactName, i) {


	if (i==undefined) {
		i=0; // initial
	}
	
	//var sourceSQL = 'SELECT '+sourceColumnsFrom+' FROM '+sourceTablesFrom+' '+object[i].SOURCE_SELECTION_CRITERIA//.replace(/'/g, '"')
	var sourceSQL = 'SELECT '+sourceColumnsFrom+' '+object[i].SOURCE_SELECTION_CRITERIA;
	var destinationSQL = 'SELECT '+destinationColumnsFrom+' FROM `'+schema+'`.`'+destinationTable+'` '+object[i].DESTINATION_SELECTION_CRITERIA//.replace(/'/g, '"')
	var test = object[i].TEST;
	
	if (dbType=='SQLSERVER') {
		sourceSQL = sourceSQL.replace(/`/g, '');
		destinationSQL = destinationSQL.replace(/`/g, '');
	}
	
	logIt(SOURCE_SQL_FILE, (i+1)+'\t'+sourceSQL+'\n');
	logIt(DESTINATION_SQL_FILE, (i+1)+'\t'+destinationSQL+'\n');


	
	runTest(sourceSQL, destinationSQL, test, i, artefactName, object.length, schema, design, sourceTables, destinationTable, function(res) {
		// recurse
		setTimeout(function() {
			
			i = i+1;
			executeTests(object, sourceColumnsFrom, destinationColumnsFrom, schema, destinationTable, sourceTablesFrom, artefactName, i);
		}, 50);
	});
	
		
}

var counter = 1;
var passedOverall = true;
function runTest(sourceSQL, destinationSQL, test, index, artefactName, test_length, schema, design, sourceTables, destinationTable, callback) {
	
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
		            	areTestsFinished(counter, test_length, artefactName, schema, design, sourceTables, destinationTable)
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
		            	areTestsFinished(counter, test_length, artefactName, schema, design, sourceTables, destinationTable)
		            	callback('OK');
		            }

	        	});
	        }
	        else {
		        counter++;
		        areTestsFinished(counter, test_length, artefactName, schema, design, sourceTables, destinationTable)
		        callback('OK');
	        }
		});
	}
	else {
		counter++;
		areTestsFinished(counter, test_length, artefactName, schema, design, sourceTables, destinationTable)
		callback('OK');
	}
		
}



function areTestsFinished(counter, test_length, artefactName, schema, design, sourceTables, destinationTable) {
	
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
            var generateDoc = new GenerateDoc(artefactName, schema, design, sourceTables, destinationTable); 

    		
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