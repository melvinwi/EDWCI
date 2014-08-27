var logger = require('./lib/logger.js');
var parser = require('./lib/parser.js');
var should = require('should');
var fs = require('fs');

var db = require('./lib/db.js');

var useUnderscoreAsDelimiter = false;

function test_dictionary(artefactName, object, schema, useUnderscoreAsDelimiter, callback) // Constructor
{
    
    var wasSuccessful = true;

    // RUN TESTS
    logger.info(artefactName, 'running DICTIONARY tests');

    fs.exists('../DICTIONARY.tsv', function(res) {
        if (res!=true) {
            logger.error(artefactName, 'FAILED DICTIONARY tests: missing file DICTIONARY.tsv - example contents\n');
            console.log('NAME\tDESCRIPTION\tEXAMPLE_VALUES\nFIRST_NAME\tFirst name of customers or contacts\tJohn\n...\n')
            process.exit();
        }
        else {
            parser.parse('../DICTIONARY.tsv', true, function(dictionary) {

            var success = true;

            // RUN STANDARDS ARTEFACT TESTS (dictionary)
            dictionary.forEach(function(row, index) { // check every line
                try {
                    row.should.have.properties('NAME', 'PREFIX_OR_SUFFIX_OR_ANY', 'DESCRIPTION', 'EXAMPLE_VALUES');
                } catch(e) {
                    // ERROR
                    logger.error('FAILED DICTIONARY tests', 'error with dictionary.tsv - missing one or more column headers - should have: NAME, PREFIX_OR_SUFFIX_OR_ANY, DESCRIPTION, EXAMPLE_VALUES');
                    success = false;
                    process.exit();
                }


                try {
                    row.PREFIX_OR_SUFFIX_OR_ANY.toLowerCase().should.match(/prefix|suffix|any|^$/) 
                } catch(e) {
                    // ERROR
                    logger.error('error with PREFIX_OR_SUFFIX_OR_ANY', 'error with dictionary.tsv - incorrect PREFIX_OR_SUFFIX_OR_ANY in row '+(index+1)+' - value: "'+row.PREFIX_OR_SUFFIX_OR_ANY+'" should be one of: prefix|suffix|any|^$ (i.e. empty is valid)');
                    success = false;
                }
            });

            if (success==false) {
                process.exit();
            }


            var wasSuccessfulInner = false;
            listOfColsThatDidNotMatchDictionary = '';

            for (var i=0; i<object.length; i++) {

                for (var x=0; x<dictionary.length; x++) {
                    if (object[i].COLUMN.trim()==dictionary[x].NAME.trim()) {
                        wasSuccessfulInner = true; // match - is in dictionary file
                        break;
                    }
                }
                
                // try name parts split by "_"
                if (wasSuccessfulInner==false) {


                    if (useUnderscoreAsDelimiter==true) {

                        var parts = object[i].COLUMN.trim().split('_');

                        countSuccess = 0;
                        for (var p=0; p<parts.length; p++) {

                            for (var x=0; x<dictionary.length; x++) {

                                if (dictionary[x].NAME.trim()==parts[p]) {

                                    // check prefix / suffix rule applies
                                    if (dictionary[x].PREFIX_OR_SUFFIX_OR_ANY.trim().toLowerCase()=='prefix') {
                                        if (dictionary[x].NAME.trim()==parts[0]) {
                                            countSuccess++; // match - is in dictionary file
                                            break;
                                        }
                                    }
                                    else if (dictionary[x].PREFIX_OR_SUFFIX_OR_ANY.trim().toLowerCase()=='suffix') {
                                        if (dictionary[x].NAME.trim()==parts[parts.length-1]) {
                                            countSuccess++; // match - is in dictionary file
                                            break;
                                        }
                                    }
                                    else {
                                        countSuccess++; // match - is in dictionary file
                                        break;
                                    }
                                }
                            }
                        }

                        if (countSuccess==parts.length) {
                            wasSuccessfulInner=true;
                        }
                    }
                    else { // check start and end rather than "parts" delim by _ (e.g. CamelCase)

                        var col = object[i].COLUMN.trim();

                        var size = col.length;
                        var checked = 0;

                        for (var x=0; x<dictionary.length; x++) {

                            // check prefix / suffix rule applies
                            if (dictionary[x].PREFIX_OR_SUFFIX_OR_ANY.trim().toLowerCase()=='prefix') {
                                if (col.startsWith(dictionary[x].NAME.trim())) {
                                    checked = checked+dictionary[x].NAME.trim().length;
                                }
                            }
                            else if (dictionary[x].PREFIX_OR_SUFFIX_OR_ANY.trim().toLowerCase()=='suffix') {
                                if (col.endsWith(dictionary[x].NAME.trim())) {
                                    checked = checked+dictionary[x].NAME.trim().length;
                                }
                            }
                            else if (dictionary[x].PREFIX_OR_SUFFIX_OR_ANY.trim().toLowerCase()=='any') {
                                if (col.indexOf(dictionary[x].NAME.trim())!=-1) {
                                    checked = checked+dictionary[x].NAME.trim().length;
                                }
                            }
                        }

                        // check that all the values
                        if (size!=checked) {
                            wasSuccessfulInner = false; // failed 
                        }
                        else {
                            wasSuccessfulInner = true; // success
                        }
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
                logger.error(artefactName, 'FAILED DICTIONARY tests for column(s): '+listOfColsThatDidNotMatchDictionary);
                process.exit();
            }
        });

        }
    });

    
}


if (typeof String.prototype.startsWith != 'function') {
  String.prototype.startsWith = function (str){
    return this.slice(0, str.length) == str;
  };
}

if (typeof String.prototype.endsWith != 'function') {
  String.prototype.endsWith = function (str){
    return this.slice(-str.length) == str;
  };
}



module.exports = test_dictionary;