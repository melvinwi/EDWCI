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

The architecture requires minimal transformation of data before Staging; therefore these tables are mirrors of the source table or XML structures.
Tables will may contain the following metadata columns to support the needs of Audit and a future Archiving component (to be confirmed through design phase):
􏰀 Modified Date - the modified date/time for the row in the Staging Table (provided by the source system).


### LAYER: Work

**COMPONENT: Transformaiton Procedures**

**COMPONENT: Work Fact & Dimension Tables**


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


