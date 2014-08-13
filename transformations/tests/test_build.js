var logger = require('./lib/logger.js');
var should = require('should');
var fs = require('fs');

var db = require('./lib/db.js');


var sys = require('sys')
var exec = require('child_process').exec;



function test_build(artefactName, object, schema, design, selectionCriteria) // Constructor
{

    // dbType
    dbType = db.dbType();


    // RUN TESTS
    //logger.info(artefactName, 'running BUILD tests');



    // construct source and destination object arrays
    var sourceTables = new Array();
    var destinationTables = new Array(); 

    object.forEach(function(row, index) {
        
        if (index<object.length-1) {

            if (row.SOURCE.length>0) {

                if (row.SOURCE.split('.')[0]!=undefined) {
                    sourceTables[sourceTables.length] = ''+row.SOURCE.split('.')[0]+'';
                }

                if (row.DESTINATION.split('.')[0]!=undefined) {
                    destinationTables[destinationTables.length] = ''+row.DESTINATION.split('.')[0]+'';
                }
            }
        }
    });

    sourceTables = sourceTables.unique();
    var sourceTablesString = '';
    for (var i=0; i<sourceTables.length; i++) {

        var row = sourceTables[i];

        sourceTablesString+=row;

        if (i<sourceTables.length-1){
            sourceTablesString+=','
        }
    }

    destinationTables = destinationTables.unique();
    var destinationTablesString = '';
    for (var i=0; i<destinationTables.length; i++) {

        var row = destinationTables[i];

        destinationTablesString+=row;

        if (i<destinationTables.length-1){
            destinationTablesString+=','
        }
    }


    // make source columns unique
    var sourceColumnsArray = new Array();
    for (var i=0; i<object.length-1; i++) {

        sourceColumnsArray[sourceColumnsArray.length] = object[i].SOURCE;
    }

    sourceColumnsArray = sourceColumnsArray.unique();

    var sourceColumnsString = '';
    for (var i=0; i<sourceColumnsArray.length; i++) {

        var row = sourceColumnsArray[i];

        sourceColumnsString+=''+row+'';

        if (i<object.length-1){
            sourceColumnsString+=','
        }
    }


    var destinationColumnsString = '';
    for (var i=0; i<object.length; i++) {

        var row = object[i].DESTINATION;

        destinationColumnsString+=''+row+'';

        if (i<object.length-1){
            destinationColumnsString+=','
        }
    }


    testProcedure(artefactName, sourceTables, destinationTables, object, sourceColumnsString, destinationColumnsString, schema, selectionCriteria)

} 




function testProcedure(artefactName, sourceTables, destinationTables, object, sourceColumnsString, destinationColumnsString, schema, selectionCriteria) {

    logger.info(artefactName, 'running BUILD test for procedure');

    // check procedure exists
    var sqlToCheckIfProcExists = ''

    if (dbType=='MYSQL') {
        sqlToCheckIfProcExists = 'SHOW PROCEDURE STATUS where `Name`= "'+artefactName+'" and `Db`="'+schema+'"'
    }
    else if (dbType=='SQLSERVER'){
        sqlToCheckIfProcExists = 'SELECT 1 FROM sys.procedures WHERE Name = \''+artefactName+'\'';
    }

    db.sql(sqlToCheckIfProcExists, function(err, result1) {
        try {

            should.not.exist(err);

            result1.length.should.equal(1);

            logger.OK(artefactName, 'PASSED BUILD test for procedure');
            
            var count = 0;


            // load source test data
            for (var i=0; i<sourceTables.length; i++) {

                loadTestData(sourceTables[i], object, schema, function(res) { 

                    count++

                    if (res=='OK') {

                        if (count==sourceTables.length) { // all data is loaded...

                            // execute proc then check mapping was successfully applied to each destination column
                            // check each column contains source data
                            runTests(artefactName, sourceTables, destinationTables, sourceColumnsString, destinationColumnsString, schema, selectionCriteria);

                        }
                    }
                    else {
                        
                        process.exit();
                    }

                });
            }


            // check test document exists, otherwise generate skeleton
            if (fs.existsSync(artefactName+'_tests.tsv')==false) {
                // ERROR
                logger.error(artefactName, 'missing transform test artefact: '+artefactName+'_tests.tsv');

                // GENERATE ARTEFACT         
                var GenerateTest = require('./test_generate.js');
                var generateBuild = new GenerateTest(artefactName, object, true, schema, dbType, selectionCriteria); 
                process.exit();
            }
            else {

            }


        } catch(e) {
            // ERROR
            logger.error(artefactName, 'procedure does not exist: '+e)

            logger.error(artefactName, 'FAILED BUILD test for procedure');

            // GENERATE ARTEFACT         
            var Generate = require('./test_generate.js');
            var generate = new Generate(artefactName, object, false, schema, dbType, selectionCriteria); 
            process.exit();
        }


    });

}
    

function loadTestData(artefactName, object, schema, callback) {

    // this is an alias if prefixed with _
    if (artefactName.substring(0,1)!='_') {

        if (artefactName.length>0) {

            logger.info(artefactName, 'running TEST DATA load');

            // load test data
            if (fs.existsSync('../../staging/tests/'+artefactName+'_data.tsv')==false) {
                // ERROR
                logger.error(artefactName, 'missing test data: '+artefactName+'_data.tsv');

                var testDataHeader = '';
                object.forEach(function(row, index) {
                    testDataHeader += row.COLUMN+'\t';
                });
                logger.info(artefactName, 'generating header for test data...');
                //console.log(testDataHeader);
            }
            else {

                // first drop existing data
                db.sql('DELETE FROM '+schema+'.'+artefactName, function(err, result) {
                    try {
                        if (err) {
                            logger.error(artefactName, 'failed to execute "DELETE FROM '+schema+'.'+artefactName+'" - '+err);
                        }
                        
                        // now parse data file
                        var parser = require('./lib/parser.js');
                        parser.parse('../../staging/tests/'+artefactName+'_data.tsv', false, function(data) {

                            var insertCounter = 0;
                            var wasSuccessful = true;
                            data.forEach(function(row, index) {
                                
                                if (index!=0) { // first row are the column names
                          

                                // replace all empty items with null
                                /* commented out for DT - data inconsistencies mean we want to test with blanks
                                var it = row;
                                var finalRow = '';

                                for (var i=0; i<it.length; i++) {
                                    it[i] = it[i].toString();
                                    if (it[i].trim().length==0) {
                                        row[i] = 'null';
                                    }
                                    else {
                                        row[i] = it[i];
                                    }
                                }
                                */

                                // replace all textual uppercase NULLs with null
                                var it = row;
                                var finalRow = '';

                                for (var i=0; i<it.length; i++) {
                                    it[i] = it[i].toString();
                                    if (it[i]=='NULL') {
                                        row[i] = 'null';
                                    }
                                    else {
                                        row[i] = it[i];
                                    }
                                }



                                    db.sqlSubstitution('INSERT INTO '+schema+'.'+artefactName+' VALUES (??)', row, function(err, result) {
                                        try {
                                            should.not.exist(err);
                                        } catch(e) {
                                            // ERROR
                                            
                                            logger.error(artefactName, 'failed to load test data: '+err);
                                            wasSuccessful = false;

                                            if (dbType=='SQLSERVER' && err.toString().indexOf('An explicit value for the identity column in table')!=-1) {
                                                logger.error(artefactName, 'FATAL - FAILED TEST DATA load - error with test data - \nYour table '+artefactName+' has a column that is of type AUTO_INCREMENT; a value cannot be specified for this column.\n\nRESOLUTION: please delete column from your test data set.\n')
                                                process.exit();
                                            }
                                        }
                                        insertCounter++;

                                        if (insertCounter==data.length-1) {
                                            if (wasSuccessful==true) {
                                                logger.OK(artefactName, 'PASSED TEST DATA load');
                                                callback ('OK')
                                            }
                                            else 
                                            {
                                                logger.error(artefactName, 'FAILED TEST DATA load'); 
                                                callback('OK') 
                                                process.exit();
                                            } 
                                        }
                                    });
                                }
                            });

                        });


                    } catch(e) {
                        // ERROR
                        logger.error(artefactName, e);
                    }
                });                
            }
        }
    }

}


Array.prototype.contains = function(v) {
    for(var i = 0; i < this.length; i++) {
        if(this[i] === v) return true;
    }
    return false;
};

Array.prototype.unique = function() {
    var arr = [];
    for(var i = 0; i < this.length; i++) {
        if(!arr.contains(this[i])) {
            arr.push(this[i]);
        }
    }
    return arr; 
}



function runTests(artefactName, sourceTables, destinationTable, sourceColumnsString, destinationColumnsString, schema, selectionCriteria) {
    // executes command
    var cmd = 'node test_transform.js --artefactName '+artefactName+' --sourceTables '+sourceTables+' --destinationTable '+destinationTable+' --sourceColumns "'+sourceColumnsString+'" --destinationColumns '+destinationColumnsString+' --schema '+schema+' --dbType '+dbType+' --selectionCriteria '+selectionCriteria;

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


module.exports = test_build;