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
- COMPLEX DATA TYPE - object JSON, array, 
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
```
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
```
- Adding test data
```
$ [elasticsearch] curl -XPOST http://localhost:9200/ecommerce/product/_bulk --data-binary "@test-data.json"
```
- Adding a document
```
PUT /ecommerce/product/1001
{
  "name":"Zend framework",
  "price":30.00,
  "description":"Learn a framework",
  "status":"active",
  "quantity":1,
  "categories":[{"name":"SOFTWARE"}],
  "tags":["Zend framework", "zf2", "php", "programming"]
}
```
- Replacing a document
```
PUT /ecommerce/product/1001
{
  "name":"Zend framework",
  "price": 40.00,
  "description":"Learn a framework",
  "status":"active",
  "quantity":1,
  "categories":[{"name":"SOFTWARE"}],
  "tags":["Zend framework", "zf2", "php", "programming"]
}
```
- Updating a document
```
POST /ecommerce/product/1001/_update
{
  "doc":{
   "price": 50.00 
  }
}
```
- Deleting a document
  - Only delete by ID, there is a plugin to delete by query
```
DELETE /ecommerce/product/1001
```
- Batch processing
```
POST /ecommerce/product/_bulk
{"index":{"_id":"1002"}}
{"name":"Why elastic search is Awesome","price":"50.00","description":"This book is all about Elasticsearch!","status":"active","quantity":12,"category":[{"name":"Software"}],"tags":["elasticsearch","programming"]}
{"index":{"_id":"1003"}}
{"name":"Peanuts","price":"3.00","description":"Peanuts with salt.","status":"active","quantity":56,"category":[{"name":"Food"}],"tags":["snacks"]}
```
```
POST /ecommerce/product/_bulk
{"delete":{"_id":"1"}}
{"update":{"_id":"1002"}}
{"doc":{"quantity":11}}
```
- Batch without informing the index and type to the URL
```
POST /_bulk
{"update":{"_id":"1002", "_index":"ecommerce", "_type":"product"}}
{"doc":{"quantity":10}}
```
- Retriece a document
```
GET /ecommerce/product/1002
```
# SEARCHING
Relevancy and Scoring
* Query string : 
```
GET http://localhost:9200/ecommerce/product/_search?q=Awesome
```
* Query DSL
```
GET http://localhost:9200/ecommerce/product/_search
{
    "query":{
      "match":{
        "name":"awesome"
      }
    }
}
```

## Types of Queries
- Leaf and Compound Queries
  - Leaf : particular values in particular fields 
  - Compound : combine multiple queries
- Full Text
- Term Level
  - Exact values/matching
- Joining Queries
  - Nested query
  - has_child - returns parents
  - has_parent - return children
- Geo Queries
  - geo_point
  - geo_shape

## Query String
```
 GET /ecommerce/product/_search?q=pasta
 GET /ecommerce/product/_search?q=name:pasta
 GET /ecommerce/product/_search?q=description:pasta
```
```
GET /ecommerce/product/_search?q=name:(pasta AND spaghetti)
GET /ecommerce/product/_search?q=name:(pasta OR spaghetti)
GET /ecommerce/product/_search?q=(name:(pasta OR spaghetti) AND status:active)
GET /ecommerce/product/_search?q=name:+pasta -spaghetti
```

```
GET /ecommerce/product/_search?q=name:"pasta spaghetti"
GET /ecommerce/product/_search?q=name:"spaghetti pasta"
    
    [Deprecated]
GET /_analyze?analyzer=standard&text=Pasta - Spaghetti
    [Deprecated]
```

# Query DSL - Full text queries
```
GET /ecommerce/product/_search
{
    "query":{
        "match_all":{}
    }
}

```
```
GET /ecommerce/product/_search
{
    "query":{
        "match":{
            "name":"pasta"
        }
    }
}
```
```
GET /ecommerce/product/_search
{
    "query":{
        "multi_match":{
            "query":"pasta", 
            "fields":["name", "description"]
        }
    }
}
```
```
GET /ecommerce/product/_search
{
    "query":{
        "match_phrase":{
            "name":"pasta spaghetti" 
        }
    }
}
```
## Query DSL - Term level queries
_Exact matching of values_
```
GET /ecommerce/product/_search
{
    "query":{
        "term":{
            "status":"active"
        }
    }
}
```
```
GET /ecommerce/product/_search
{
    "query":{
        "terms":{
            "status":["active", "inactive"]
        }
    }
}
```
```
GET /ecommerce/product/_search
{
  "query":{
      "range":{
          "quantity":{
            "gte":1,
            "lte":10
          }
      }
  }
}
```
## Compound Queries
```
GET /ecommerce/product/_search
{
    "query":{
        "bool":{
            "must":[
                {"match":{"name":"pasta"}},
                {"match":{"name":"spaghetti"}}
            ]
        }
    }
}
```
```
GET /ecommerce/product/_search
{
    "query":{
        "bool":{
            "must":[
                {"match":{"name":"pasta"}}
            ],
            "must_not":[
                {"match":{"name":"spaghetti"}}
            ]
        }
    }
}
```
* with **should** the term **must** is not required but used for scoring. 
```
GET /ecommerce/product/_search
{
    "query":{
        "bool":{
            "must":[
                {"match":{"name":"pasta"}}
            ],
            "should":[
                {"match":{"name":"spaghetti"}}
            ]
        }
    }
}
```

## Indexing and Mapping Types
* new index
```
PUT /myfoodblock/recepie/1
{
    "name":"Pasta Quattro Formaggi",
    "description": "First you boil the pasta, then you add the cheese.",
    "ingredientes":[
        {
            "name":"Pasta",
            "amount":"500g"
        },{
            "name":"Fontina Cheese",
            "amount":"100g"
        },{
            "name":"Parmesan Cheese",
            "amount":"100g"
        },{
            "name":"Romano Cheeses",
            "amount":"100g"
        },{
            "name":"Gorgonzola Cheese",
            "amount":"100g"
        }
    ]
}
```




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

