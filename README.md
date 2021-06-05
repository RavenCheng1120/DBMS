# DBMS

## Homework 2 - MySQL basic

Build a database based on the ER model you built in Homework 1. We use ‘MySQL Command line client Unicode’ in this homework.

## Homework 3 - MySQL

Based on the ER model and relational database you built in Homework 1 and 2 , we design SQL statements to extract useful or interesting information in this homework. We will use ‘MySQL Command line client - Unicode’.

## Homework 4 - Python and MySQL

In this homework, you need to write a Python program and write SQL statement inside the Python program to complete various tasks. You should need mysql.connector as your mySQL connection package.

## Homework 6 - MongoDB

### Basic instruction

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