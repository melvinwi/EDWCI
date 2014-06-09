var logger = require('./lib/logger.js');
var should = require('should');
var fs = require('fs');

var db = require('./lib/db.js');


function test_build(artefactName, object, schema, design) // Constructor
{

    // RUN TESTS
    logger.info(artefactName, 'running BUILD tests');



    // -- enter tests below here --

    // check table exists
    db.sql('SELECT * FROM '+schema+'.'+artefactName, function(err, result) {
        try {
            should.not.exist(err);
        } catch(e) {
            // ERROR
            logger.error(artefactName, e)

            // GENERATE ARTEFACT         
            var GenerateTest = require('./test_generate.js');
            var generateBuild = new GenerateTest(artefactName, object, schema); 

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
                        var generateDoc = new GenerateDoc(artefactName, schema, design); 

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

                            db.sqlSubstitution('INSERT INTO '+schema+'.'+artefactName+' VALUES (??)', row, function(err, result) {
                                try {
                                    should.not.exist(err);
                                } catch(e) {
                                    // ERROR
                                    logger.error(artefactName, 'failed to load test data: '+err);
                                }
                            });
                        }

                        insertCounter++;

                        if (insertCounter==data.length) {
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

                });


            } catch(e) {
                // ERROR
                logger.error(artefactName, e);
            }
        });                
    }

}

module.exports = test_build;