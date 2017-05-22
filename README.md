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

# Metafields
- _index : 
- _type  : 
- _id    : doc id
- _uid   : type # id 

Doc source metafileds
- _source : (not indexed)
- _size   : size of the source (plugin)
 
Indexing metafields
- _all         :
- _field_names :

Routing metafilds
- _parent  : (create parent-child relationship between doc)
- _routing : route to particular shard
 
Other metafileds
- _meta : 

# ..
- Add mapping to a index;
````
PUT /ecommerce
{
    "mappings":{ 
      "product":{
        "properties":{
          "name":{
            "type": "text"
          },
          "price":{
            "type": "text"
          },
          "description":{
            "type": "text"
          },
          "status":{
            "type": "text"
          },
          "quantity":{
            "type": "integer"
          },
          "categories":{
            "type": "nested",
            "properties":{
              "name":{
                "type": "text"
              }
            }
          },
          "tags":{
            "type": "text"
          }
        }
      }
    }
}
````
- Adding test data
````
$ [elasticsearch] curl -XPOST http://localhost:9200/ecommerce/product/_bulk --data-binary "@test-data.json"
````
# EXTRAS
* [Readding](https://www.elastic.co/guide/en/kibana/current/connect-to-elasticsearch.html)
* [CURL download](https://curl.haxx.se/)
```
On the curl download page there's a link to the download wizard. 
Complete all the steps as follows:
    
Select Type of Package: curl executable
Select Operating System: Windows / Win32 or Win64
Select for What Flavour: Generic
Select which Win32 Version (only if you selected Windows / Win32 in step 2): Unspecified
If you chose Windows / Win32 you should end up here, a page that links to http://www.paehl.com/open_source/?CURL_x.y.z (x.y.z will change as newer versions of curl are released). There you can click the first link ("Download WITHOUT SSL") or second link ("Download WITH SUPPORT SSL") for a zip file with curl.exe.
    
If you chose Win64 you should end up on this page which should have direct download links from the https://curl.haxx.se website. These too contain only curl.exe.
    
Finally, you can copy curl.exe into %windir% and it should become available on the command line.
    
curl.exe is in the src folder of the downloaded / extracted curl folder.
```

## Annoucements
[Types are being removed from Elasticsearch](https://www.udemy.com/elasticsearch-complete-guide/learn/v4/announcements?ids=882892)
