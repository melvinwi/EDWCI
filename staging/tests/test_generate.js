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


function test_generate(artefactName, object, schema) // Constructor
{

    // RUN TESTS
    logger.info(artefactName, 'about to run GENERATE');


    var sql = 'CREATE TABLE `'+schema+'`.`'+artefactName+'` (\n';

    // construct cols
    object.forEach(function(row, index) {

    	sql += '`'+row.COLUMN+'` ';

    	if (row.TYPE.toLowerCase()!='datetime') {
    		sql += row.TYPE+'('+row.LENGTH+') ';
    	}
    	else {
    		sql += row.TYPE+' ';
    	}

    	if (row.DEFAULT.length>0) {
    		sql+= 'DEFAULT '+row.DEFAULT;
    	}
    	else {
    		sql+= 'DEFAULT NULL';
    	}

        if (row.AUTO_INCREMENT.toLowerCase()=='true') {
            sql += ' AUTO_INCREMENT';
        }

    	if (index<object.length-1) {
    		sql += ',\n'
    	}
    	else {
    		// nothing
    	}

    });

    // construct pk
    var pk_flag = false;
    var pks = '';
    object.forEach(function(row, index) {
    	if (row.PK.toLowerCase()=='true') {
    		if (pk_flag==false) {
    			pk_flag = true;
    			sql += ',\nPRIMARY KEY ('
    			pks+='`'+row.COLUMN+'`'
    		}
    		else {
    			pks+=',`'+row.COLUMN+'`'
    		}
    	}
    });

    if (pk_flag==true) {
    	sql += pks+')\n';
    }
    else {
    	sql += '\n'
    }

    sql += ')'

    sql += 'ENGINE=InnoDB AUTO_INCREMENT=204 DEFAULT CHARSET=latin1;'

    console.log(sql);
}

module.exports = test_generate;