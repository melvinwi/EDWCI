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
                    var generateDoc = new GenerateDoc(artefactName, schema, design); 

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