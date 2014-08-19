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
                    
                    loadTestData(artefactName, object, schema, function(res) {

                        // GENERATE DOCUMENATION         
                        var GenerateDoc = require('./test_generate_doc.js');
                        var generateDoc = new GenerateDoc(artefactName, schema, design, dbType); 

                        process.exit();
                    });
                    
                }
                else {
                    logger.error(artefactName, 'FAILED BUILD tests');
                    process.exit();
                }
            }
        });
    });

}


function loadTestData(artefactName, object, schema, callback) {

    logger.info(artefactName, 'running TEST DATA load');

    // load test data
    if (fs.existsSync(artefactName+'_data.tsv')==false) {
        // ERROR
        logger.error(artefactName, 'missing test data: '+artefactName+'_data.tsv');

        var testDataHeader = '';
        object.forEach(function(row, index) {
            testDataHeader += row.COLUMN+'\t';
        });
        logger.info(artefactName, 'generating header for test data...');
        console.log(testDataHeader);
    }
    else {

        // if SQL Server and there is an auto-increment, need to ommit from data load file
        //fs.readFileSync

        // first drop existing data
        db.sql('DELETE FROM '+schema+'.'+artefactName, function(err, result) {
            try {
                should.not.exist(err);
                
                // now parse data file
                var parser = require('./lib/parser.js');
                parser.parse(artefactName+'_data.tsv', false, function(data) {

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

                            // turn DWSTR prefix into a string
                            var it = row;
                            var finalRow = '';

                            for (var i=0; i<it.length; i++) {
                                it[i] = it[i].toString();
                                if (it[i].substring(0,5)=='DWSTR') {
                                    row[i] = it[i].substring(5).toString();
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


module.exports = test_build;