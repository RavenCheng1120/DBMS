# DBMS

## Homework 2 - MySQL basic

Build a database based on the ER model you built in Homework 1. We use ‘MySQL Command line client Unicode’ in this homework.

## Homework 3 - MySQL

Based on the ER model and relational database you built in Homework 1 and 2 , we design SQL statements to extract useful or interesting information in this homework. We will use ‘MySQL Command line client - Unicode’.

## Homework 4 - Python and MySQL

In this homework, you need to write a Python program and write SQL statement inside the Python program to complete various tasks. You should need mysql.connector as your mySQL connection package.

## Homework 6 - MongoDB & Neo4j

### MongoDB Basic instruction

1. Start MongoDB server

```shell
$ brew services start mongodb-community
```

2. Close MongoDB server

```shell
$ brew services stop mongodb-community
```

3. Start the MongoDB shell to localhost/port=27017

 ```shell
 $ mongo
 ```



### MongoDB Shell commands

1. Currently selected database

```shell
> db
```

2. Show database names, collections in current database

```shell
> show dbs
> show collections
```

3. Switch database

```shell
> use databaseName
```

4. mongoimport the csv file

```shell
$ mongoimport -d databaseName -c collectionName --type csv --file data.csv --headerline
```

5. Select all from a collection

```shell
> db.collectionName.find({}).pretty()
```

6. Update documents

```shell
> db.your_collection.update(
  {},
  { $set: {"new_field": 1} },
  false,
  true
)
```

In the above example last 2 fields `false, true` specifies the `upsert` and `multi` flags.

**Upsert:** If set to true, creates a new document when no document matches the query criteria.

**Multi:** If set to true, updates multiple documents that meet the query criteria. If set to false, updates one document.

7. Increment aggregation pipeline (Task 6)

```shell
updateSessionStats = function(startDate) {
	db.students.aggregate([
		{ $match: { 日期: { $lte: startDate } } },
		{ $group: { _id: {系所:"$系所"}, count: { $sum: 1 } } },
		{ $group: { _id: null, DEPT_GROUP: { $push: { dept: "$_id.系所", number: "$count" } } } },
		{ $project: { _id: "tally", dept_group: "$DEPT_GROUP" } },
		{ $merge: {
			into: "students",
			whenNotMatched: "insert"
		}}
	]);
};
```

Task 6 Ref: https://stackoverflow.com/questions/42456436/mongodb-aggregate-nested-group



### Neo4j installation

Download the free community edition neo4j **tar** file [here](https://neo4j.com/download-center/#community). Unzip the file, and run `./bin/neo4j console` for Mac OS.

If it shows an error for <u>Unable to find any JVMs matching version "11"</u>, installing OpenJDK 11 with `brew install openjdk@11`. And then symlink with `sudo ln -sfn /usr/local/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk`. Reference: https://community.neo4j.com/t/unable-to-find-any-jvms-matching-version-11/18183/4

Once the server starts running, visit remote interface at http://localhost:7474/ in web browser. Default login is **username 'neo4j'** and **password 'neo4j'**.



### Neo4j Shell and Cypher

[Tutorial link](https://neo4j.com/docs/cypher-manual/4.2/introduction/#cypher-intro)

1. helps

```she
$ :help commands
$ :help server
$ :server status
```

2. Create 

```cypher
CREATE (john:Person {name: 'John'})
CREATE (joe:Person {name: 'Joe'})
CREATE (steve:Person {name: 'Steve'})
CREATE (sara:Person {name: 'Sara'})
CREATE (maria:Person {name: 'Maria'})
CREATE (john)-[:FRIEND]->(joe)-[:FRIEND]->(steve)
CREATE (john)-[:FRIEND]->(sara)-[:FRIEND]->(maria)
```

3. Load csv file

Neo4j security has a default setting that local files can only be read from the Neo4j **import directory**.

```cypher
LOAD CSV FROM "file:///hw6_student_data.csv" AS line
RETURN line
LIMIT 10
```

> Creating databases is only available at Enterprise Edition.

4. SELECT

```cypher
MATCH (n:Student {學號: 'r09922063'}) RETURN n
//or
MATCH (n:Student) WHERE n.系所 = '資工系碩士班_一年級 ' RETURN n
```

5. Create relationship

```cypher
MATCH (a:Student {學號: 'r09922063'}),(b:Student {系所: '資工系碩士班_一年級 '})
WHERE b.學號 <> 'r09922063'
CREATE (a)-[r:peer]->(b)
RETURN type(r)
```

6. Delete relationship

```cypher
// Delete particular relationship
MATCH (a:Student {學號: 'r09922063'})-[r:peer]-(b:Student {系所: '資工系碩士班_一年級 '})
DELETE r
                                                           
// Delete all relationship
MATCH (n)-[r]-() DELETE r
```

7. Return list of nodes

```cypher
MATCH (s:Student {系所: '資工系碩士班_一年級 '})
RETURN COLLECT(s)
```

8. Delete all node

```cypher
MATCH (n) DELETE n
```

9. Remove constraint

use `:Schema` to show constraint information.

```cypher
DROP CONSTRAINT ON (a:Student) ASSERT a.學號 IS UNIQUE
```

10. Use Merge instead of Create

Merge: Create relationship if the relationship isn't exist.

```cypher
LOAD CSV WITH HEADERS FROM "file:///hw6_hobbies.csv" AS csvLine
MERGE (:Student {學號: csvLine.學號, 姓名: csvLine.姓名})
```

