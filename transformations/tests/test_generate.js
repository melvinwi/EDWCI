var logger = require('./lib/logger.js');
var should = require('should');
var fs = require('fs');

var db = require('./lib/db.js');


/*  example - sql proc:

    DELIMITER $$

    CREATE DEFINER=`root`@`localhost` PROCEDURE `TRANSFORM_CUSTOMER`(
        IN sourceID VARCHAR(25),
    BEGIN 
        INSERT INTO `STAGING_CUSTOMER` (`NUMBER`) 
            SELECT `DATASTORE_CUSTOMER.NUMBER`
            FROM `STAGING_CUSTOMER` 
            WHERE `STAGING_CUSTOMER.NUMBER` is not null; 
    END
	
*/


/* example - csv test:
    # design artefact           
    # ARTEFACT: TRANSFORM_CUSTOMER_tests            
    # DESCRIPTION: Test each transformation rule            
    SOURCE_SELECTION_CRITERIA   DESTINATION_SELECTION_CRITERIA  TEST    DESCRIPTION
    WHERE `NUMBER` is not null      source.length.should.equal(destination.length)  row counts should match
    WHERE `NUMBER` = “NUMBER1”  WHERE `NUMBER` = “NUMBER1”  source.FIRSTNAME.substring(0,2).should.equal(destination.FIRST_NAME)   check substring rule is applied
    WHERE `NUMBER` = “NUMBER1”  WHERE `NUMBER` = “NUMBER1”  source.SURNAME.should.equal(destination.LAST_NAME)  check map rule is applied
    WHERE `NUMBER` = “NUMBER1”  WHERE `NUMBER` = “NUMBER1”  source.MIDDLENAME.should.equal(destination.MIDDLE_NAME) check map rule is applied
    WHERE `NUMBER` = “NUMBER1”  WHERE `NUMBER` = “NUMBER1”  source.UPDATED_DATETIME.should.equal(destination.UPDATED_DT)    check map rule is applied

*/


function test_generate(artefactName, object, generateOnlyTest, schema, dbType) // Constructor
{

    // RUN TESTS
    logger.info(artefactName, 'about to run GENERATE');


    // construct source and destination object arrays
    var sourceTables = new Array();
    var destinationTables = new Array(); 

    object.forEach(function(row, index) {
        
        if (index<object.length-1) {
            if (row.SOURCE.trim().length>0 && row.SOURCE!=undefined) {
                sourceTables[sourceTables.length] = '`'+row.SOURCE.split('.')[0]+'`';
            }

            if (row.DESTINATION.trim().length>0 && row.DESTINATION!=undefined) { 
                destinationTables[destinationTables.length] = '`'+row.DESTINATION.split('.')[0]+'`';
            }

        }
    });

    sourceTables = sourceTables.unique();
    var sourceTablesString = '';
    for (var i=0; i<sourceTables.length; i++) {

        var row = sourceTables[i];

        if (row.toString()!='undefined') {
            sourceTablesString+='`'+schema+'`.'+row;

            if (i<sourceTables.length-1){
                sourceTablesString+=','
            }
        }
    }

    // put a dummy where statement in to ensure the developer is notified of the join requirement
    if (sourceTables.length>1) {
        sourceTablesString += '\n\t  WHERE --TODO! join required--'
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
    


    if (generateOnlyTest!=true) {


        var sql = '';

        if (dbType=='MYSQL') {
            sql += 'DELIMITER $$\n\n';
            sql += 'CREATE DEFINER=`root`@`localhost` PROCEDURE `'+schema+'`.`'+artefactName+'`()\n';
        }
        else if (dbType=='SQLSERVER') {
            sql += 'CREATE PROCEDURE '+schema+'.'+artefactName+' AS\n'
        }

        sql += 'BEGIN\n'

        for (var i=0; i<destinationTables.length; i++) {
            sql += '\tDELETE FROM `'+schema+'`.'+destinationTables[i]+';\n';  
        }

        sql += '\tINSERT INTO `'+schema+'`.'+destinationTablesString+' (\n';     

        // construct destination cols
        object.forEach(function(row, index) {
            
            if (index<object.length-1) {
                sql += '\t\t`'+row.DESTINATION.split('.')[0]+'`.`'+row.DESTINATION.split('.')[1]+'`';
            }

            if (index<object.length-2) {
                sql += ',\n'
            }
            else {
                // nothing
            }
        });

        sql += ')\n';

        
        sql += '\t  SELECT\n'

        // construct source cols
        object.forEach(function(row, index) {
            
            if (index<object.length-1) {
                sql += '\t\t';

                if (row.SOURCE_FUNCTION_PREFIX.trim().length>0) {
                    sql += row.SOURCE_FUNCTION_PREFIX
                }
                
                if (row.SOURCE.trim().length>0) {
                    sql += '`'+row.SOURCE.split('.')[0]+'`.`'+row.SOURCE.split('.')[1]+'`';
                }

                if (row.SOURCE_FUNCTION_SUFFIX.trim().length>0) {
                    sql += row.SOURCE_FUNCTION_SUFFIX
                }
            }

            if (index<object.length-2) {
                sql += ',\n'
            }
            else {
                // nothing
                sql += ''
            }
        });


        sql += '\n\t  FROM '+sourceTablesString+'\n' // distinct list of sources as it may come from many tables

        var whereStatement = ''
        while (object[object.length-i].SOURCE==undefined) {
            i++;
            if (object[object.length-i].SOURCE!=undefined) {
                whereStatement = '\t  '+object[object.length-i].SOURCE+''
            }
        }
        sql += whereStatement+';'; // where statement

        sql += '\nEND';


        if (dbType=='SQLSERVER') {
            sql = sql.replace(/`/g, '');
        }

        console.log(sql);
    }
    else {

        var tst = '';
        tst += '# test artefact\n'  
        tst += '# ARTEFACT: '+artefactName+'_tests\n'            
        tst += '# DESCRIPTION: Test each transformation rule\n'            
        tst += 'SOURCE_SELECTION_CRITERIA\tDESTINATION_SELECTION_CRITERIA\tTEST\tDESCRIPTION\n',
        tst += ''+object[object.length-1].SOURCE+'\t\tsource.length.should.equal(destination.length)\trow counts should match\n'


        // read source data to get first line, first matching row
        var data = (fs.readFileSync('../../staging/tests/'+object[0].SOURCE.split('.')[0]+'_data.tsv').toString().split('\n'))
        var header = data[0].split('\t');
        var firstRow = data[1].split('\t');

        var firstColumnInObjectToTest = object[0].SOURCE.split('.')[1];

        var singleForDataToSelect = ''

        for (var i=0; i<header.length; i++) {
            if (header[i]==firstColumnInObjectToTest) {
                singleForDataToSelect = firstRow[i];
                break;
            }
        }


        var singleRowSelectionCriteria = '';

        if (object[0].SOURCE.split('.').length==2) {
            singleRowSelectionCriteria = 'WHERE `'+object[0].SOURCE.split('.')[1]+'` = \''+singleForDataToSelect+'\'' 
        }
        else {
            singleRowSelectionCriteria = 'WHERE '+object[0].SOURCE+' = \''+singleForDataToSelect+'\'' 
        }


        var singleRowSelectionCriteriaDestination = '';

        if (object[0].DESTINATION.split.length==2) {
            singleRowSelectionCriteriaDestination = 'WHERE `'+object[0].DESTINATION.split('.')[1]+'` = \''+singleForDataToSelect+'\'' 
        }
        else {
            singleRowSelectionCriteriaDestination = 'WHERE '+object[0].DESTINATION+' = \''+singleForDataToSelect+'\'' 
        }

        for (var i=0; i<object.length; i++) {
            if (object[i].DESTINATION.split('.')[1]!=undefined) {
                tst += singleRowSelectionCriteria+'\t'+singleRowSelectionCriteriaDestination+'\t'+'source[0].'+object[i].SOURCE.split('.')[1]+'.should.equal(destination[0].'+object[i].DESTINATION.split('.')[1]+')\tone to one\n';
            }
        }
        
        console.log(tst);

        process.exit();

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


module.exports = test_generate;