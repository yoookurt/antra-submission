# 4. A paragraph on the differences between ETL and ELT. Also, list the pros and cons of each in a chart.

## 1. General Differences:
ETL is the Extract, Transform, and Load process for data. ELT is Extract, Load, and Transform process for data. 

In ETL, data moves from the data source to staging into the data warehouse.

Unlike ETL, extract, load, and transform (ELT) does not require data transformations to take place before the loading process. ELT loads raw data directly into a target data warehouse, instead of moving it to a processing server for transformation or data staging.

With ELT data pipeline, data cleansing, enrichment, and data transformation all occur inside the data warehouse itself. Raw data is stored indefinitely in the data warehouse, allowing for multiple transformations, and can be more cost-effective than ELT.

ETL can help with data privacy and compliance by cleaning sensitive and secure data even before loading into the data warehouse.


## 2. Pros and Cons:

|  | ETL | ELT |
|:---:|:---|:---|
| Pros | Preserves resources | Fast extraction and loading |
| Pros | Improves compliance | Lower upfront development costs |
| Pros | Well-developed tools | More flexibility |
| Cons | Legacy ETL is slow | Overgeneralization |
| Pros | Frequent maintenance | Security gaps |
| Pros | Higher Upfront Cost | Compliance risk |
| Pros |  | Increased Latency |

### Advantages of ETL Processes

- Preserves resources: ETL can reduce the volume of data that is stored in the warehouse, helping companies preserve storage, bandwidth, and computation resources in scenarios where they are sensitive to costs on the storage side. Although with commoditized cloud computing engines, this is less of a concern.
- Improves compliance: ETL can mask and remove sensitive data, such as IP or email addresses, before sending it to the data warehouse. Masking, removing, and encrypting specific information helps companies comply with data privacy and protection regulations such as GDPR , HIPAA, and CCPA.
- Well-developed tools: ETL has existed for decades, and there is a range of robust platforms that businesses can deploy to extract, transform, and load data. This makes it easier to set up and maintain an ETL pipeline.

### Drawbacks of ETL Processes

- Legacy ETL is slow: Traditional ETL tools require disk-based staging and transformations.
- Frequent maintenance: ETL data pipelines handle both extraction and transformation. But they have to undergo refactors if analysts require different data types or if the source systems start to produce data with deviating formats and schemas.
- Higher Upfront Cost: Defining business logic and transformations can increase the scope of a data integration project.

## Advantages of ELT Processes

- ast extraction and loading: Data is delivered into the target system immediately with minimal processing in-flight.
- Lower upfront development costs : ELT tools are typically adept at simply plugging source data into the target system with minimal manual work from the user given that user-defined transformations are not required.
- More flexibility: Analysts no longer have to determine what insights and data types they need in advance but can perform transformations on the data as needed in the warehouse with tools like dbt.

### Challenges of ELT Processes

- Overgeneralization: Some modern ELT tools make generalized data management decisions for their users – such as rescanning all tables in the event of a new column or blocking all new transactions in the case of a long-running open transaction. This may work for some users, but could result in unacceptable downtime for others.
- Security gaps: Storing all the data and making it accessible to various users and applications come with security risks. Companies must take steps to ensure their target systems are secure by properly masking and encrypting data.
- Compliance risk: Companies must ensure that their handling of raw data won’t run against privacy regulations and compliance rules such as HIPAA, PCI, and GDPR.
- Increased Latency: In cases where transformations with business logic ARE required in ELT, you must leverage batch jobs in the data warehouse. If latency is a concern, ELT may slow down your operations.
