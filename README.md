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
PUT /myfoodblog/recipe/1
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
* list all indexes
```
GET /_cat/indices?v
```
* list documents of an index
```
GET /myfoodblog
```
* search across indexes
```
GET /ecommerce,myfoodblog/product/_search?q=pasta
```
* search across mapping types
```
GET /ecommerce,myfoodblog/product,recipe/_search?q=pasta&size=15
```
* %2B in url + sign is interpreted as space
```
GET /-*ecommerce,%2Bmyfoodblog/product,recipe/_search?q=pasta&size=15
```
[url encode](https://www.w3schools.com/tags/ref_urlencode.asp)

* Search for all types
```
GET /ecommerce/_search?q=pasta
``` 

* Variations
```
GET /_all/product/_search?q=pasta
    
GET /_search?q=pasta
```

## FUZZY SEARCHES
_Fuzziness is the number of characters necessary to change to match terms_

### Levenshtein Distance 
- [https://people.cs.pitt.edu](https://people.cs.pitt.edu/~kirk/cs1501/Pruhs/Spring2006/assignments/editdistance/Levenshtein%20Distance.htm)
- [https://en.wikipedia.org](https://en.wikipedia.org/wiki/Levenshtein_distance)

* Distance of 1
```
GET /ecommerce/_search?q=past~1
```

_The max by Lucene is 2, due to performance concerns._

```
GET /ecommerce/_search
{
    "query":{
        "match":{
            "name":{
                "query":"past",
                "fuzziness":1
            }
        }
    }
}

```
* Recommended in most cases:
```
GET /ecommerce/_search
{
    "query":{
        "match":{
            "name":{
                "query":"past",
                "fuzziness":"AUTO"
            }
        }
    }
}
```

## Proximity searches

_Different orders of terms._

* Two "editions" are allowed in the terms, this way they can be switched
```
GET /ecommerce/product/_search?q=name:"pasta spaghetti"~2
```
* Here only one edit is allowed 
```
GET /ecommerce/product/_search?q=description:"spaghetti pasta"~1
```
* Equivalent 
```
GET /ecommerce/product/_search
{
    "query":{
        "match_phrase":{
            "name":{
                "query": "pasta spaghetti",
                "slop":2
            }
        }
    }
}
```

## Boost Searches

* Boost the term spaghetti (increase the importance)
* Between 0 and 1 decrease the importance
```
GET /ecommerce/product/_search?q=name:pasta spaghetti^2.0
```
* Boosting a phrase (sentence)
```
GET /ecommerce/product/_search?q=name:"pasta spaghetti"^2.0
```
* 
```
GET /ecommerce/product/_search
{
    "query":{
        "bool":{
            "must":[
                {"match":{"name":"pasta"}}
            ],
            "should":[
                {
                    "match":{
                        "name":{
                            "query":"spaghetti",
                            "boost": 2.0
                        }
                    }
                },{
                    "match":{
                        "name":{
                            "query":"noodle",
                            "boost": 1.5
                        }
                    }
                }
            ]
        }
    }
}
```
## Filtering Result

* 2 query contexts
  * query context
    * queries in query context affects the relevance of query documents
  * filter context
    * queries in query context do not affect the relevance

```
GET /ecommerce/product/_search
{
    "query":{
        "bool":{
            "must":[
                {
                    "match":{
                        "name":"pasta"
                    }
                }
            ],
            "filter":[
                {
                    "range":{
                        "quantity":{
                            "gte":10,
                            "lte":15
                        }
                    }
                }
            ]
        }
    }
}
```
## Change the size of result set

* Query string search
```
GET /ecommerce/product/_search?q=name:pasta&size=2
```
* Equivalente query (DSL)
```
GET /ecommerce/product/_search
{
    "query":{
        "match":{
            "name":"pasta"
        }
    },
    "size":2
}
```

## Pagination

* Starting from 0 (zeero)
```
GET /ecommerce/product/_search?q=name:pasta&size=5
```
```
GET /ecommerce/product/_search?q=name:pasta&size=5&from=5
```

```
GET /ecommerce/product/_search
{
    "query":{
        "match":{
            "name":"pasta"
        }
    },
    "size":5,
    "from":5
}
```

## Sorting Results
```
GET /ecommerce/product/_search
{
    "query":{
        "match":{
            "name":"pasta"
        }
    },
    "sort":[
        {
            "quantity": {
                "order": "desc"
            }
        }
    ]
}
```

## Agregations
* Grouping and extracting statistics

* Types
  * Metrics
    * Values
  * Bucket
    * 
  * Pipeline
    * Experimental
    
### Single Value Aggregation
* Sum
```
GET /ecommerce/product/_search
{
     "query":{
         "match_all":{}
     },
     "size":0,
     "aggs":{
         "quantity_sum":{
             "sum":{
                 "field":"quantity"
             }
         }
     }
}
```
```
GET /ecommerce/product/_search
 {
    "query":{
        "match":{
          "name":{
            "query":"pasta"
          }
        }
    },
    "size":0,
    "aggs":{
        "quantity_sum":{
            "sum":{
                "field":"quantity"
            }
        }
    }
 }
```
* Average
```
GET /ecommerce/product/_search
 {
    "query":{
        "match":{
          "name":{
            "query":"pasta"
          }
        }
    },
    "size":0,
    "aggs":{
        "avg_qty":{
            "avg":{
                "field":"quantity"
            }
        }
    }
 }
```

* Min and Max
```
GET /ecommerce/product/_search
 {
    "query":{
        "match":{
          "name":{
            "query":"pasta"
          }
        }
    },
    "size":0,
    "aggs":{
        "min_qty":{
            "min":{
                "field":"quantity"
            }
        }
    }
 }
```
### Multiple Value Aggregation
* Metric Aggregations - Stats
```
GET /ecommerce/product/_search
 {
    "query":{
        "match":{
          "name":{
            "query":"pasta"
          }
        }
    },
    "size":0,
    "aggs":{
        "qty_stats":{
            "stats":{
                "field":"quantity"
            }
        }
    }
 }
```

## Bucket Aggregations

```
GET /ecommerce/product/_search
 {
    "query":{
        "match_all":{ }
        }
    },
    "size":0,
    "aggs":{
        "qty_ranges":{
            "range":{
                "field":"quantity",
                "ranges":[
                    {
                        "from":1, 
                        "to":50
                    },
                    {
                       "from":50, 
                       "to":100
                    }
                ]
            }
        }
    }
 }
```
* Mixing Aggregations
```
GET /ecommerce/product/_search
 {
    "query":{
        "match_all":{ }
    },
    "size":0,
    "aggs":{
        "qty_ranges":{
            "range":{
                "field":"quantity",
                "ranges":[
                    {
                        "from":1, 
                        "to":50
                    },
                    {
                       "from":50, 
                       "to":100
                    }
                ]
            },
            "aggs":{
                "qwuantity_stats":{
                    "stats":{
                        "field":"quantity"
                    }
                }
            }
        }
    }
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

