var logger = require('./lib/logger.js');
var parser = require('./lib/parser.js');
var should = require('should');
var fs = require('fs');

var db = require('./lib/db.js');


function test_dictionary(artefactName, object, schema, callback) // Constructor
{
    
    var wasSuccessful = true;

    // RUN TESTS
    logger.info(artefactName, 'running DICTIONARY tests');

    fs.exists('../DICTIONARY.csv', function(res) {
        if (res!=true) {
            logger.error(artefactName, 'FAILED DICTIONARY tests: missing file DICTIONARY.csv - example contents\n');
            console.log('NAME\tDESCRIPTION\tEXAMPLE_VALUES\nFIRST_NAME\tFirst name of customers or contacts\tJohn\n...\n')
            process.exit();
        }
        else {
            parser.parse('../DICTIONARY.csv', true, function(dictionary) {

            var wasSuccessfulInner = false;
            listOfColsThatDidNotMatchDictionary = '';

            for (var i=0; i<object.length; i++) {

                for (var x=0; x<dictionary.length; x++) {
                    if (object[i].COLUMN.trim()==dictionary[x].NAME.trim()) {
                        wasSuccessfulInner = true; // match - is in dictionary file
                        break;
                    }
                }
                
                if (wasSuccessfulInner==false) {

                    if (listOfColsThatDidNotMatchDictionary.length>0) {
                        listOfColsThatDidNotMatchDictionary +=', '
                    }
                    listOfColsThatDidNotMatchDictionary += object[i].COLUMN

                    wasSuccessful = false; // overall
                }

                wasSuccessfulInner = false; // reset
            }

            if (wasSuccessful==true) {
                logger.OK(artefactName, 'PASSED DICTIONARY tests');
                callback('OK');
                
            }
            else {
                logger.error(artefactName, 'FAILED DICTIONARY tests for columns: '+listOfColsThatDidNotMatchDictionary);
                process.exit();
            }
        });

        }
    });

    
}




module.exports = test_dictionary;