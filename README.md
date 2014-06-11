CI
==

CI is Continuous Integration framework for Data Integration (DI) solutions.  

For enterprise capabilities - scalable, multi-project Agile project delivery teams - the CI framework may be used in conjunction with a code management system such as GitHub paired with an Agile Project Management tool such as Rally or PivotalTracker.

> "Continuous integration (CI) is the practice of merging all developer working copies with a shared mainline several times a day. Its main aim is to prevent integration problems" - wikipedia.com

The CI framework for DI:

* automates design artefact quality checks

* automates generation of build artefacts from design artefacts (partial)

* automates generation of test artefacts from design artefacts (partial)

* automates execution of test artefacts against build artefacts

* automates the generation of documentation from design artefacts


##Structure

The framework has been built with a simple data integration architecture in mind.

The DI architecture comprises three **layers** and two supporting **components**.

The DI Layers providing storage are layers:

(1) **Staging** (layer) -  storage location for "raw" system of record data

(2) **Data Store** (layer) - longterm storage location for transaction data and conformed master data objects


Supporting the promotion of data from Staging --> Data Store are components:

a. **Transformations** (component) - the execution logic for selecting data from Staging and inserting into the Data Store

b. **Functions** (component) - providing reusable transformation functions


And finally:

(3) **Views** (layer) - the layer for business access to Data Store tables

a. **Functions** (component) - providing reusable business rules for views


##Scope

To deliver an object in a *layer* or *component* you must first construct a **Design Artefact**.  Design Artefact's are Tab Separated Value (tsv) text files.  For developers, these may be cut-and-paste into a spreadsheet tool for editing - e.g. Excel, Numbers.

Design Artefacts may also rely on one of the following Supporting Artefacts **data artefact**, **standard artefact** or **test artefact**; also tsv files.

The following is the list of artefacts required to define a layer or component object, and the automated features available in DI to support the developer: tests, code generation, documentation generation


![Scope](/z.info/scope.png)

###Staging

Provisioning a staging layer object (table) requires the creation of two artefacts

**Design Artefacts**

`staging\STAGING_<OBJECT_NAME>.tsv`

```
# design artefact							
# ARTEFACT: STAGING_<OBJECT_NAME>							
# DESCRIPTION: <object description>							
COLUMN	DESC	TYPE	LENGTH	DEFAULT	NOT_NULL	PK	AUTO_INCREMENT
...
```


`staging\tests\STAGING_<OBJECT_NAME>_data.tsv`

```
# data artefact
# ARTEFACT: STAGING_<OBJECT_NAME>_data							
# DESCRIPTION: data to drive all test scenarios
COL1	COL2	COL3
...
```

**Tests**

a. design artefact contains the correct column headers

b. design artefact column values are correct (e.g. TYPE is varchar, etc.; NOT_NULL is true or false)

c. build artefact exists (table)

d. build artefact (table) contains each column name and type as specified in the design artefact

e. data artefact exists

f. data artefact contains the columns required for the build

g. data artefact can load correctly in the table and columns


**Code Generation**

a. if build artefact doesn't exist, "create table" statement generated

b. if data artefact doesn't exist, "data columns" (tsv) is generated


**Documentation Generation**

a. design artefact as a .textile markup file for rendering in GitHub or other wiki



###Data Store

**Design Artefacts**

`datastore\DATASTORE_<OBJECT_NAME>.tsv`

```
# design artefact							
# ARTEFACT: DATASTORE_<OBJECT_NAME>							
# DESCRIPTION: <object description>							
COLUMN	DESC	TYPE	LENGTH	DEFAULT	NOT_NULL	PK	AUTO_INCREMENT
...
```


`datastore\DICTIONARY.tsv`

```
# standards artefact
# ARTEFACT: DICTIONARY							
# DESCRIPTION: a valid list of valid business attribute names, descriptions and sample values 
NAME	DESCRIPTION	EXAMPLE_VALUES
...
```


**Tests**

a. design artefact contains the correct column headers

b. design artefact column values are correct (e.g. TYPE is varchar, etc.; NOT_NULL is true or false)

c. design artefact column values are present in the dictionary tsv

d. build artefact exists (table)

e. build artefact (table) contains each column name and type as specified in the design artefact


**Code Generation**

a. if build artefact doesn't exist, "create table" statement generated


**Documentation Generation**

a. design artefact as a .textile markup file for rendering in GitHub or other wiki




###Transformations

**Design Artefacts**

`transformations\TRANSFORM_<OBJECT_NAME>.tsv`

```
# design artefact				
# ARTEFACT: TRANSFORM_<OBJECT_NAME>				
# DESCRIPTION: Promote data from <Staging Object(s)> to <DataStore Object> 				
SOURCE_FUNCTION_PREFIX	SOURCE	SOURCE_FUNCTION_SUFFIX	DESTINATION	DESCRIPTION
...
```


`transformations\tests\TRANSFORM_<OBJECT_NAME>_tests.tsv`

```
# design test artefact					
# ARTEFACT: TRANSFORM_CUSTOMER_ALL_tests					
# DESCRIPTION: Test each transformation rule					
SOURCE_SELECTION_CRITERIA	DESTINATION_SELECTION_CRITERIA	TEST	DESCRIPTION		
...
```


**Tests**

a. design artefact contains the correct column headers

b. design artefact column values are present in the source (staging) and destination (datastore) objects

c. build artefact exists for source object (staging) and destination object (datastore)

d. data artefact exists for source object (staging)

e. build artefact exists (procedure)

f. build artefact (procedure) executes successfully

g. test artefact exists

h. test artefact line "TEST" logic adheres to standard ("should.js test framework" - https://github.com/shouldjs/should.js)

i. test artefact line "..._SELECTION_CRITERIA" executes successfully against database (i.e. source sql, destination sql)


**Code Generation**

a. if build artefact doesn't exist, "create procedure" statement generated

b. if test artefact doesn't exist, "test artefact for 1:1 map tests" (tsv) is generated


**Documentation Generation**

a. design artefact as a .textile markup file with links to source (staging) and destination (datastore) .texttile pages for rendering in GitHub or other wiki




##Workflow

Paired with GitHub and Rally, the following workflow may apply.

1. Before starting an Iteration, the Technical Assurance Team branches the "mainline" for the planned iteration in GitHub - e.g. branch "Project A, Iteration 1"

1. Developer "starts" a Story from Rally for Iteration 1 with Story Id 8881

1. Developer clones the GitHub branch "Project A, Iteration 1" which contains all design, test and documentation artefacts

1. Developer completes work to address the Story

	a. clones the code - i.e. the "mainline" schema copied to their private schema

	b. runs tests across the code set to confirm the baseline is sound

	c. create/update the design, tests, and data dictionary to address the Story and provide full testing scope

	d. executes tests against their private schema, which should FAIL

	e. complete code updates in their private schema, which may use CI's generated code

	f. execute tests regularly until PASSED (once passed, DI will automatically update the documentation)

1. Developer commits the change with the comment containing information about the change and the text #<RallyStoryId> (e.g. #8881)

1. Rally will automatically update the Story to the next status in the workflow (e.g. "Deliver")

1. Technical Assurance team review all Stories in Rally that have status "Deliver" and complete a quality review

	a. in GitHub, the team will review design, tests, and data dictionary changes (identified in GitHub by the #<RallyStoryId>); line-by-line changes are able to be reviewed to confirm test scope coverage, standards and quality are adhered to

	b. If the TA review fails, the Story may be "Rejected" with the rationale and returned to the developer; the commit is rolled back and the developer rectifies their changes in their private repository  

	c. If the TA review passes, the Story is updated to "Awaiting Integration Test" and the developer is instructed to promote the build artefacts to the mainline schema for integration testing

	d. Once the build artefacts are promoted by the Developer and confired by updating the Story to "Ready for Integration", the full suite of tests are executed against the repository by the TA - an automated nightly process

	e. If the build tests FAIL for the artefact, the Story is "Rejected" and returned to the Developer

	f. If the build tests PASS, the Story is updated to "Ready for Release"


1. At the end of the Iteration:
	
	a. all commits that are in the repository - i.e. the "Ready for Release" items - are merged with the "mainline" GitHub branch by the TA team

	b. the "mainline" schema is promoted to the next environment by the TA team (e.g. pre-production or production)


##Extensions and Customisations

Additional quality checks may be incorporated into the DI scripts by editing the "test.js" script in each artefact directory - i.e. staging, datastore, transformation, views, and functions.

You may support other database notations generated and DI frameworks by adjusting the "test_generate.js" script in each artefact directory.

You may vary the documentation structures generated by adjusting "test_generate_doc.js" script in each artefact directory.

You may support other databases (currently MySQL and SAP HANA are supported) by extending the db.js script in the lib directory under each in each artefact directory - i.e. staging, datastore, transformation, views, and functions.


