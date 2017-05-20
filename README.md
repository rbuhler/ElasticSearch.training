# python.elasticSearch

# TERMINOLOGY
- **Cluster** (Collection of nodes - default "elasticseach") - _search capability_
- **Nodes** (Single server) - _store searchable data_
- **Index** (**Database** - collection of documents)
  - Type (**Table** - Class or category)
    - Mapping (Schema - describe the fields)
- **Document**(**Rows**/**Object** - basic unit of information)
- **Shards** (Index divided into pieces) - _horizontal scalability_
- **Replica** (Copies of indexes) - _availability_

# APACHE LUCENE
[**Apache Lucene**](https://lucene.apache.org/)

# EXERCISES
## CREATE A NEW INDEX
```
PUT /ecommerce
{
  
}
```
## RETRIEVE DATA FROM INDEXES
```
get /_cat/indices?v
```
## DELETE A INDEX
```
DELETE /ecommerce
```
## RETRIEVE DATA FROM INDEXES
```
GET _cat/indices?v
```

# MAPPING

# TYPES (fase out)
- CORE DATA TYPES - string, numeric, boolean ..
- COMPLEX DATA TYPE - object JASON, array, 
  - Array - deserves deep learning
- GEO DATA TYPE
- SPECIALIZED DATA TYPE - ipv4, completion, token count, attachments(plugin)

# EXTRAS
[Readding](https://www.elastic.co/guide/en/kibana/current/connect-to-elasticsearch.html)

## Annoucements
[Types are being removed from Elasticsearch](https://www.udemy.com/elasticsearch-complete-guide/learn/v4/announcements?ids=882892)
