var logger = require('./lib/logger.js');
var should = require('should');
var fs = require('fs');

var db = require('./lib/db.js');


function test_build(artefactName, object, schema, design) // Constructor
{

    // dbType
    dbType = db.dbType();

    // RUN TESTS
    logger.info(artefactName, 'running BUILD tests');



    // -- enter tests below here --

    // check table exists
    var sqlStatement = '';

    if (dbType=='MYSQL') {
       sqlStatement = 'SELECT * FROM '+schema+'.'+artefactName+' limit 1';
    }
    else if (dbType=='SQLSERVER') {
        sqlStatement = 'SELECT top 1 * FROM '+schema+'.'+artefactName
    }
    else {
        sqlStatement = 'SELECT * FROM '+schema+'.'+artefactName+' top 1';
    }

    // check table exists
    db.sql(sqlStatement, function(err, result) {
        try {
            should.not.exist(err);
        } catch(e) {
            // ERROR
            logger.error(artefactName, e)

            // GENERATE ARTEFACT         
            var GenerateTest = require('./test_generate.js');
            var generateBuild = new GenerateTest(artefactName, object, schema, dbType); 
            process.exit();
        }
    });


    var counter = 0;
    var wasSuccessful = true;
    // check each column exists
    object.forEach(function(row, index) {
        db.sql('SELECT '+row.COLUMN+' FROM '+schema+'.'+artefactName, function(err, result) {
            try {
                should.not.exist(err);
            } catch(e) {
                // ERROR
                logger.error(artefactName, e);
                wasSuccessful = false;
            }

            counter++;

            if (counter==object.length) {

                if (wasSuccessful==true) {
                    logger.OK(artefactName, 'PASSED BUILD tests');
                    
                    // GENERATE DOCUMENATION         
                    var GenerateDoc = require('./test_generate_doc.js');
                    var generateDoc = new GenerateDoc(artefactName, schema, design, dbType); 

                    process.exit();
                    
                }
                else {
                    logger.error(artefactName, 'FAILED BUILD tests');
                    process.exit();
                }
            }
        });
    });

}


module.exports = test_build;