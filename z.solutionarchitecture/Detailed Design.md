**[Detailed Design](Detailed Design)**

Logical Architecture components described.

> Key diagrams
> * [Logical Architecture - Components](Detailed Design#Logical Architecture - Components)


### LAYER: Data Source

**COMPONENT: Orion**

Orion is the primary operational database of record for Lumo Energy. 

**COMPONENT: Force**

Force is the database of record for complaints made to the industry Ombudsman.

**COMPONENT: Dynamics (Great Plains)**

Great Plains is the finance management system for Lumo Energy.

### LAYER: Staging

**COMPONENT: Temp Staging Tables**



**COMPONENT: Staging Tables**

A single area to land and share data with components in the Data Warehousing layer. 

Characteristics:

􏰀* Support for structured data landed from multiple sources

􏰀* Provisioned as tables for persistent storage that reflects the data stored in the source system.

The Staging Tables will be provisioned as SQL Server tables. Transaction-based tables may be partitioned (scheme to be confirmed in design) to provide distribution of load.

The architecture requires minimal transformation of data before Staging; therefore these tables are mirrors of the source table or XML or CSV structures.

Tables will may contain the following metadata columns to support the needs of Audit and a future Archiving component:
􏰀 Modified Date - the modified date/time for the row in the Staging Table (provided by the source system).


### LAYER: Work

**COMPONENT: Transformation Procedures**

Provides the mapping and transformation rules for promoting data from Staging Tables to Work Tables.

Characteristics:

􏰀* Provides broad functional capabilities for evaluating transformation rules - e.g. date translation rules; string manipulation; evaluating regular expressions (regex)

* Supports SQL access to source and destination layers

Transformation Procedures will be implemented in Stored Procedures.  Design and build artefact templates will ensure developers maintain standards to simplify support and maintenance. 


**COMPONENT: Work Fact & Dimension Tables**

Work tables are temporary locations for storing the result from Transformation Procedures.  They are responsible for staging data before it is merged with the Dimensional layer.

Characteristics:

* Tables that reflect the structure of Dimensional layer excluding the internal ID

* Referential integrity is not enforced; referential integrity control is maintained by the Data Warehouse Execution Framework, Job Configuration and Sequencing component

Work tables are implemented using Tables.


### LAYER: Dimensional

**COMPONENT: Fact Tables**

**COMPONENT: Dimension Tables**


### LAYER: Access

**COMPONENT: Views**


### LAYER: API Services

**COMPONENT: Web APIs**


### LAYER: Consumption

**COMPONENT: Client-side BI Tools**

**COMPONENT: Web Browser**


### LAYER: Data Warehouse Execution Framework

**COMPONENT: Load Staging Initial**

**COMPONENT: Load Staging Incremental**

**COMPONENT: Load Work Common Package**

**COMPONENT: Load Dimension Common Package**

**COMPONENT: Load Fact Common Package**

**COMPONENT: Job Configuration and Sequencing Component**

**COMPONENT: Logging**

**COMPONENT: Scheduling**


### LAYER: Data Warehouse Monitoring and Security

**COMPONENT: Auditing**

**COMPONENT: Database Monitoring**

**COMPONENT: Authentication and Authorisation**


