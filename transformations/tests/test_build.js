var logger = require('./lib/logger.js');
var should = require('should');
var fs = require('fs');

var db = require('./lib/db.js');


var sys = require('sys')
var exec = require('child_process').exec;


function test_build(artefactName, object, schema) // Constructor
{

    // RUN TESTS
    //logger.info(artefactName, 'running BUILD tests');



    // construct source and destination object arrays
    var sourceTables = new Array();
    var destinationTables = new Array(); 

    object.forEach(function(row, index) {
        
        if (index<object.length-1) {
            
            sourceTables[sourceTables.length] = ''+row.SOURCE.split('.')[0]+'';
            destinationTables[destinationTables.length] = ''+row.DESTINATION.split('.')[0]+'';

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


    var sourceColumnsString = '';
    for (var i=0; i<object.length-1; i++) {

        var row = object[i].SOURCE;

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


    testProcedure(artefactName, sourceTables, destinationTables, object, sourceColumnsString, destinationColumnsString, schema)

} 



/* function testDestination() {

    // -- enter tests below here --
    
    logger.info(artefactName, 'running BUILD test for destination');

    // check destination exists
    var counter = 0;
    var wasSuccessful = true;

    for (var i=0; i<destinationTables.length; i++) {
            
        db.sql('SELECT * FROM `CI`.`'+destinationTables[i]+'`', function(err, result) {
            try {

                should.not.exist(err);

            } catch(e) {
                // ERROR
                logger.error(destinationTables[i], e)
                wasSuccessful = false;
            }

            counter++;

            if (counter==destinationTables.length) {

                if (wasSuccessful==true) {
                    logger.OK(artefactName, 'PASSED BUILD test for destination');
                    loadTestData(artefactName, object, function(res) {
                        process.exit();
                    });
                }
                else {
                    logger.error(artefactName, 'FAILED BUILD test for destination');
                    process.exit();
                }
            }
        });
    }

} */


function testProcedure(artefactName, sourceTables, destinationTables, object, sourceColumnsString, destinationColumnsString, schema) {

    //console.log('sourceColumnsString: '+sourceColumnsString);
    //console.log('destinationColumnsString: '+destinationColumnsString);

    logger.info(artefactName, 'running BUILD test for procedure');

    // check procedure exists
    db.sql('SHOW PROCEDURE STATUS where `Name`= "'+artefactName+'" and `Db`="'+schema+'"', function(err, result1) {
        try {

            should.not.exist(err);

            result1.length.should.equal(1);

            logger.OK(artefactName, 'PASSED BUILD test for procedure');
            //logger.OK(artefactName, 'EXISTS `CI`.`'+artefactName+'`');


            var count = 0;

            // load source test data
            for (var i=0; i<sourceTables.length; i++) {

                //try {
                    loadTestData(sourceTables[i], schema, function(res) { 

                        count++

                        if (res=='OK') {
                            
                            if (count==sourceTables.length) { // all data is loaded...

                                // execute proc then check mapping was successfully applied to each destination column
                                // check each column contains source data
                                runTests(artefactName, sourceTables, destinationTables, sourceColumnsString, destinationColumnsString, schema);

                            }
                        }
                        else {
                            
                            process.exit();
                        }

                    });
                // }
                // catch(e) {
                //     // ERROR
                //     logger.error(sourceTables[i], 'procedure does not exist: '+e)   
                // }
            }


            // check test document exists, otherwise generate skeleton
            if (fs.existsSync(artefactName+'_tests.csv')==false) {
                // ERROR
                logger.error(artefactName, 'missing transform test artefact: '+artefactName+'_tests.csv');

                // GENERATE ARTEFACT         
                var GenerateTest = require('./test_generate.js');
                var generateBuild = new GenerateTest(artefactName, object, true, schema); 
                process.exit();
            }
            else {

                // execte transform test - check mapping was successfully applied to each destination column
                try {
                    setTimeout(function() {

                        //var TestTransform = require('./test_transform.js');
                        //var testtransform = new TestTransform(artefactName, sourceTablesString, destinationTablesString); 
                    }, 1000);
                }
                catch (eee) {
                    // ERROR
                    logger.error(artefactName, 'error with test_transform: '+eee)
                }
            }


        } catch(e) {
            // ERROR
            logger.error(artefactName, 'procedure does not exist: '+e)

            logger.error(artefactName, 'FAILED BUILD test for procedure');

            // GENERATE ARTEFACT         
            var Generate = require('./test_generate.js');
            var generate = new Generate(artefactName, object, false, schema); 
            process.exit();
        }


    });

}
    

function loadTestData(artefactNameTable, schema, callback) {

    var success = true;
    var count = 1;

    logger.info(artefactNameTable, 'running TEST DATA load');


    // load test data
    if (fs.existsSync('../../staging/tests/'+artefactNameTable+'_data.csv')==false) {
        // ERROR
        logger.error(artefactNameTable, 'missing test data: '+artefactNameTable+'_data.csv');
    }
    else {

        // first drop existing data
        db.sql('DELETE FROM '+schema+'.'+artefactNameTable, function(err, result) {
            try {
                should.not.exist(err);
                
                // now parse data file
                var parser = require('./lib/parser.js');
                parser.parse('../../staging/tests/'+artefactNameTable+'_data.csv', false, function(data) {

                
                    data.forEach(function(row, index) {

                        if (index!=0) { // first row are the column names

                            db.sqlSubstitution('INSERT INTO '+schema+'.'+artefactNameTable+' VALUES (??)', row, function(err, result) {
                                try {
                                    should.not.exist(err);
                                } catch(e) {
                                    // ERROR
                                    logger.error(artefactNameTable, 'error loading test data: '+err);
                                    success = false;
                                }

                                count++;

                                if (data.length==count) {
                                    if (success==true) {
                                        logger.OK(artefactNameTable, 'PASSED TEST DATA load');
                                        callback('OK')
                                    }
                                    else {
                                        logger.error(artefactNameTable, 'FAILED TEST DATA load'); 
                                        callback('FAIL');
                                        process.exit();
                                    }
                                }
                            });
                        }
                    });

                });


            } catch(e) {
                // ERROR
                logger.error(artefactNameTable, 'FAILED TEST DATA load: '+e);
                process.exit();
            }
        });                
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



function runTests(artefactName, sourceTables, destinationTable, sourceColumnsString, destinationColumnsString, schema) {
    // executes command
    child = exec('node test_transform.js --artefactName '+artefactName+' --sourceTables '+sourceTables+' --destinationTable '+destinationTable+' --sourceColumns "'+sourceColumnsString+'" --destinationColumns '+destinationColumnsString+' --schema '+schema, function (error, stdout, stderr) {
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