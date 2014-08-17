var logger = require('./lib/logger.js');
var should = require('should');
var fs = require('fs');

var db = require('./lib/db.js');


/*  example:


h2. ARTEFACT: VCustomer

DESCRIPTION: view of DimCustomer

|*ATTRIBUTE_NAME*   |*DEFINITION*   |*RULE_DESCRIPTION* |*DATASTORE_OBJECTS*    |*DATASTORE_ATTRIBUTES* |
|Count  |Count of Customers |count(DimCustomer.CustomerKey) |DimCustomer    |CustomerKey|


	
*/

function test_generate_doc(artefactName, schema, design) // Constructor
{
    design = design.toString();

    try {

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

        // var regex = new RegExp(destinationTable, 'g');
        // table = table.replace(regex, '"'+destinationTable+'":../datastore/'+destinationTable+'.textile ');

        // sourceTables = sourceTables.split(',');
        
        // for (var x=0; x<sourceTables.length; x++) {
        //     sourceTable = sourceTables[x];
        //     var regex = new RegExp(sourceTable, 'g');
        //     table = table.replace(regex, '"'+sourceTable+'":../staging/'+sourceTable+'.textile ');

        // }

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
        

        //console.log(design);

        fs.writeFileSync(filename, design);
        
        logger.OK(artefactName, 'PASSED GENERATE DOC (see: '+filename+')');
    }
    catch(ee) {
        logger.error(artefactName, 'FAILED GENERATE DOC: '+ee);
    }
    
}

module.exports = test_generate_doc;