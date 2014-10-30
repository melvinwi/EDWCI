**[Detailed Design](Detailed Design)**

Logical Architecture components described.

> Key diagrams
> * [Logical Architecture - Components](Detailed Design#Logical Architecture - Components)


### LAYER: Data Source

**COMPONENT: Orion**

Orion is the primary operational database of record for Lumo Energy. 

Characteristics:

􏰀* All Orion source tables have Change Data Capture enabled

* CDC data is retained for 3 days.


**COMPONENT: Force**

Force is the API for the database of record for Lumo Energy customer complaints. (The Force Database is named Complaints.)

Characteristics:
􏰀
* All Complaints source tables have Change Data Capture enabled

* CDC data is retained for 3 days.

**COMPONENT: Dynamics (Great Plains)**

Great Plains is the finance management system for Lumo Energy.

**COMPONENT: Flat Files**

Flat Files (e.g. comma separated values) are the data source for internal campaign definitions, and 3rd party survey data, for Lumo Energy.


### LAYER: Staging

A single area to land and share data with components in the Work layer.

**COMPONENT: Staging Tables**

Staging Tables are 1:1 copies of the source table, XML or CSV structures.

Characteristics:

􏰀* Support for structured data, landed from multiple sources.
􏰀
* Sources are provisioned as SQL Server Tables for persistent storage.
􏰀
* The architecture requires minimal transformation of data before Staging. 
􏰀
* Transaction-based tables may be partitioned (scheme to be confirmed in design) to provide distribution of load.

Staging Tables may differ from sources in the following respects:
􏰀
* A Primary Key is applied if none exists
􏰀
* Foreign Keys and Default Constraints are not replicated
􏰀
* All columns (except for the Primary Key) are nullable
􏰀
* Tables include the following metadata columns to support incremental processing, auditing and a future Archiving component:
􏰀	* Meta_Insert_TaskExecutionInstanceId
􏰀	* Meta_LatestUpdate_TaskExecutionInstanceId

**COMPONENT: Temp Staging Tables**

Temp Staging Tables provide a temporary landing area for data from Data Sources, before being applied to Staging Tables.

Characteristics:
Temp Staging Tables are identical to Staging Tables, with the following exceptions:
􏰀
* They do not contain a Primary Key.
􏰀
* All columns are nullable.
􏰀
* They only include one Meta Data column:
	* Meta_LatestUpdate_TaskExecutionInstanceId


### LAYER: Work

**COMPONENT: Transformation Procedures**

Provides the mapping and transformation rules for promoting data from Staging Tables to Dimensional Tables.

Characteristics:
􏰀
* Provides broad functional capabilities for evaluating transformation rules - e.g. date translation rules; string manipulation; evaluating regular expressions (regex)
􏰀
* Supports incremental processing by ignoring unchanged source data.
􏰀
* Supports SQL access to source and destination layers
􏰀
* Transformation Procedures implemented in SQL Server Stored Procedures.
􏰀
* Design and build artefact templates will ensure developers maintain standards to simplify support and maintenance. 


**COMPONENT: Work Fact & Dimension Tables**

Work tables are temporary locations for storing the result from Transformation Procedures.  They are responsible for staging data before it is merged with the Dimensional layer.

Characteristics:
􏰀
* Tables reflect the structure of the Dimensional layer, excluding the internal surrogate key, which takes the form: <DimensionName>Id
􏰀
* Referential integrity is not enforced; referential integrity control is maintained by the Data Warehouse Execution Framework, Job Configuration and Sequencing component
􏰀
* Work tables are implemented using SQL Server Tables.


### LAYER: Dimensional

**COMPONENT: Fact Tables**

Fact Tables contain transaction information, or represent many-to-many relationships between dimensions (known as factless-facts). 

Characteristics:
􏰀
* Type 1 Slowly Changing Dimensions
􏰀
* Reference Dimension Tables using the internal surrogate key: <DimensionName>Id
􏰀
* Fact tables are implemented using SQL Server Tables.

Tables contain the following metadata columns to support auditing:
􏰀	* Meta_Insert_TaskExecutionInstanceId
􏰀 	* Meta_LatestUpdate_TaskExecutionInstanceId


**COMPONENT: Dimension Tables**

Dimension Tables contain descriptive information about business concepts. 

Characteristics:
􏰀
* Type 2 Slowly Changing Dimensions
􏰀
* Effective date ranges reflect the point in time at which the data arrives in the Dimensional Layer, (not the time of the change in the source system).
􏰀
* Dimension tables are implemented using SQL Server Tables.

Tables contain the following metadata columns to support the requirements of Access Views, audit and a future Archiving component:
􏰀	* Meta_IsCurrent
􏰀	* Meta_EffectiveStartDate
􏰀	* Meta_EffectiveEndDate
􏰀	* Meta_Insert_TaskExecutionInstanceId
􏰀	* Meta_LatestUpdate_TaskExecutionInstanceId


### LAYER: Access

**COMPONENT: Views**

Views present data, formatted for consumption by end-users.

Characteristics:
􏰀
* Views support real-time transformations for presentation to the Consumption Layer.
􏰀
* NULL handling
􏰀
* To mitigate latency, typically limited to simple joins and transformations.


### LAYER: API Services

**COMPONENT: Web APIs**


### LAYER: Consumption

**COMPONENT: Client-side BI Tools**

**COMPONENT: Web Browser**


### LAYER: Data Warehouse Execution Framework

**COMPONENT: Refresh Staging Table**

Performs a Full or Incremental Refresh of a Staging Table.

Characteristics:
􏰀
* Takes the form of one SSIS package per source object.
􏰀
* The Incremental Refresh relies on Change Data Capture in the source system, and makes use of the Temp Staging Table.

**COMPONENT: Execute Transform Common Package**

Executes a given transform procedure.

Characteristics:
􏰀
* Facilitates both full or incremental loads.
􏰀
* If an incremental load, the latest successful 'Task Execution Instance Id' is determined and used to ignore unchanged data.

**COMPONENT: Merge Common Package**

Loads a target table (typically a Fact or Dimension Table) with data from a similarly structured source table.

Characteristics:
􏰀
* Supports propogation of all values (including NULLs).
􏰀
* Supports Types 1 and 2 Slowly Changing Dimensions
􏰀
* Supports default NULL handling
􏰀
* Does not currently support deletions.
􏰀
* Ignores fields that do not match in both name and datatype. Also ignores fields beginning: Meta_

**COMPONENT: Application Configuration and Sequencing Component**

Supports the execution of a set of ordered of tasks.

Characteristics:
􏰀
* Tasks can be assigned precedent constraints.
􏰀
* Error handling can include: stopping/continuing the application execution, and on subsequent application executions, restarting from the first or last successful task.
􏰀
* Supports parallel execution.

**COMPONENT: Logging**

Logging includes: task start and end times, derived variables, task execution statuses and error messages.

**COMPONENT: Scheduling**

Scheduling is managed via SQL Server Agent.

Characteristics:
􏰀
* A master job is scheduled to run nightly, which executes Applications serially.

### LAYER: Data Warehouse Monitoring and Security

**COMPONENT: Auditing**

SQL Server Audit records the following:

* DDL activity

* Permission changes

* Failed Logins

* Executions

* Deletions

* Selections (if the table contains personally identifiable information).


**COMPONENT: Database Monitoring**

Quest Foglight is used for monitoring and alerting.

**COMPONENT: Authentication and Authorisation**

Authentication is managed via Windows Authentication.

Authorisation is determined by membership in an Active Directory entity, which has been assigned to a database role with permission to access an appropriate subset of Views. 
