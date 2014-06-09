var logger = require('./lib/logger.js');
var should = require('should');
var fs = require('fs');

var db = require('./lib/db.js');


/*  example:

	CREATE TABLE `DATASTORE_CUSTOMER` (
	  `id` int(11) NOT NULL AUTO_INCREMENT,
	  `NUMBER` varchar(45) DEFAULT NULL,
	  `FIRSTNAME` varchar(45) DEFAULT NULL,
	  `SURNAME` varchar(45) DEFAULT NULL,
	  `MIDDLENAME` varchar(45) DEFAULT NULL,
	  `CREATED_DATETIME` datetime DEFAULT NULL,
	  `UPDATED_DATETIME` datetime DEFAULT NULL,
	  PRIMARY KEY (`id`)
	) ENGINE=InnoDB AUTO_INCREMENT=204 DEFAULT CHARSET=latin1;
	
*/


function test_generate_doc(artefactName, schema, design) // Constructor
{

    // RUN
    logger.info(artefactName, 'running GENERATE DOC');

    var filename = '../'+artefactName+'.textile';

    var header = '';
    var forTable = '';

    var lines = design.split('\n');
    for (var i=0; i<lines.length; i++) {
        if (lines[i].substring(0,1)=='#') { // description information
            if (lines[i].indexOf('ARTEFACT')!=-1) {
                header+='\nh2. '+lines[i].substring(1, lines[i].length).trim()+'\n';
            }
            else if (lines[i].indexOf('DESCRIPTION')!=-1) {
                header+='\n'+lines[i].substring(1, lines[i].length).trim()+'\n';
            }
        }
        else {
            forTable += lines[i]+'\n';
        }
    }
    header += '\n'

    var table = forTable.trim().replace(/\t/g, '\t|').replace(/\n/g, '\t|\n|')+'|\n';

    var lines = table.split('\n');
    
    var columns = lines[0].split('\t|');

    var columnHeader = '';
    for(var i=0; i<columns.length; i++) {
        if (columns[i].trim().length>0) {
            columnHeader+= '*'+columns[i]+'*\t|'
        }
    }

    design = header+'|'+columnHeader+'\n'
    for(var i=1; i<lines.length; i++) {
        design+=lines[i]+'\n';
    }
    
    fs.writeFileSync(filename, design);
    
    logger.OK(artefactName, 'PASSED GENERATE DOC (see: '+filename+')');
    
}

module.exports = test_generate_doc;