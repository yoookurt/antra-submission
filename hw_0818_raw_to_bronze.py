# Databricks notebook source
# MAGIC %md
# MAGIC ## Project: Delta Lake for Movie Jsons

# COMMAND ----------

# path
import re
source_path = '/mnt/antrastrg01adls/adlscontainer01/dataset/'
raw_path = '/FileStore/movie/raw/'
bronze_path = '/FileStore/movie/bronze/'
sivler_path = '/FileStore/movie/silver/'
gold_path = '/FileStore/movie/gold/'

# COMMAND ----------

# MAGIC %md
# MAGIC ### 0. mounted storage to a Raw folder

# COMMAND ----------

# Make Raw Idempotent
dbutils.fs.rm(raw_path, recurse=True)

def retrieve_data(file: str, dest_path: str) -> bool:
    """Download file from remote location to driver. Move from driver to DBFS."""
    src = source_path + file
    dest = dest_path + file
    dbutils.fs.cp(src, dest)
    return True

def prepare_raw(dest_path=raw_path) -> bool:
    """Search for movie*.json data files, then call retrieve_data method to download to the destination raw pool."""
    json_pattern = '^movie.*\.json$'
    for f in dbutils.fs.ls(source_path):
        if re.match(json_pattern, f.name) is not None:
            retrieve_data(f.name, dest_path)
            
prepare_raw()

# COMMAND ----------

# MAGIC %md
# MAGIC ### 1. Raw to Bronze

# COMMAND ----------

from pyspark.sql.types import ArrayType, StructType,StructField, StringType, IntegerType, DateType, DoubleType, FloatType, LongType, TimestampType, DateType, BooleanType, MapType
from pyspark.sql.functions import col, explode, current_date, current_timestamp, lit
from pyspark.sql.dataframe import DataFrame

# COMMAND ----------

# Prepare Bronze path
dbutils.fs.rm(bronze_path, recurse=True)

# COMMAND ----------

# Ingest with a simple schema and metadata
movie_schema = StructType([StructField('movie', ArrayType(StringType()), True),])
    
def raw_to_bronze(src_path=raw_path, dest_path=bronze_path, schema=movie_schema, persist=True) -> DataFrame:
    """
    One by one ingestion to show json file names as the datasource.
    """
    for f in dbutils.fs.ls(src_path):
        movie_raw_df = (spark.read.option("inferSchema", 'false').option('multiline', 'true').schema(movie_schema).json(f.path))
        movie_raw_df = movie_raw_df.withColumn('movie', explode('movie'))
        movie_meta_df = movie_raw_df.select('Movie', lit(f.name).alias('SourceFile'), current_timestamp().alias('IngestTime'), current_timestamp().cast('date').alias('p_IngestDate'), lit('new').alias('Status'))
        movie_meta_df.write.format('delta').mode('append').save(dest_path)
        return movie_meta_df

movie_meta_df = raw_to_bronze(persist=True)

# COMMAND ----------

# Alternatively, batch ingestion with detailed schema
movie_schema = StructType().add('movie', ArrayType(
    StructType([
    StructField('BackdropUrl', StringType(), True),
    StructField('Budget', FloatType(), True),
    StructField('CreatedBy', StringType(), True),
    StructField('CreatedDate', TimestampType(), True),
    StructField('Id', LongType(), True),
    StructField('ImdbUrl', StringType(), True),
    StructField('OriginalLanguage', StringType(), True),
    StructField('Overview', StringType(), True),
    StructField('PosterUrl', StringType(), True),
    StructField('Price', FloatType(), True),
    StructField('ReleaseDate', TimestampType(), True),
    StructField('Revenue', FloatType(), True),
    StructField('RunTime', IntegerType(), True),
    StructField('Tagline', StringType(), True),
    StructField('Title', StringType(), True),
    StructField('TmdbUrl', StringType(), True),
    StructField('UpdatedBy', StringType(), True),
    StructField('UpdatedDate', TimestampType(), True),
    StructField('genres', ArrayType(StructType([
        StructField('id', LongType(), True),
        StructField('name', StringType(), True),
    ])), True),
])
), True)

def raw_to_bronze(src_path=raw_path, dest_path=bronze_path, schema=movie_schema, persist=True) -> DataFrame:
    """
    Batch ingestion with wildcard.
    """
    movie_raw_df = (spark.read.option("inferSchema", 'false').option('multiline', 'true').schema(movie_schema).json(src_path+'movie*.json'))
    movie_raw_df = movie_raw_df.withColumn('movie', explode('movie'))
    movie_meta_df = movie_raw_df.select('Movie', lit('movie_json').alias('SourceFile'), current_timestamp().alias('IngestTime'), current_timestamp().cast('date').alias('p_IngestDate'), lit('new').alias('Status'))
    movie_meta_df.write.format('delta').mode('append').save(dest_path)
    return movie_meta_df

movie_meta_df = raw_to_bronze(persist=True)

# COMMAND ----------

# MAGIC %sql
# MAGIC 
# MAGIC -- show history of the bronze folder
# MAGIC DESCRIBE HISTORY '/FileStore/movie/bronze'

# COMMAND ----------

# Register the Bronze Table in the Metastore
spark.sql(
    """
    CREATE SCHEMA IF not EXISTS delta_lake
    """
)
spark.sql(
    """
    USE delta_lake
    """
)
spark.sql(
    """
    DROP TABLE IF EXISTS movie_bronze
    """
)
spark.sql(
    f"""
CREATE TABLE movie_bronze
USING DELTA
LOCATION "{bronze_path}"
"""
)

# COMMAND ----------

# MAGIC %sql
# MAGIC -- quety the bronze table
# MAGIC SELECT * FROM movie_bronze limit 10;
