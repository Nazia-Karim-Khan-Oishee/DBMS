2
a.
db.user.insertOne({"name":"naziakarimkhan","email":"naziakarim@gmail.com","password":"naziakarim123"})

b
db.user.insertMany([{"name":"naziakarim","email":"naziakarim@gmail.com","password":"test@123",
                     "phoneno":"012345","dob":new Date("2002-01-14"),"address":"dhaka","profile_creation_date":new Date(),
                      "Hobbies":["gardening","cooking"]},
                    {"name":"naziakarimkhan","email":"naziakarim@gmail.com","password":"12345",
                    "phoneno":"012345","dob":new Date("2002-01-14"),"address":"dhaka","profile_creation_date":new Date(),
                    "Hobbies":["gardening","sewing"]}])
c
db.user.insertOne({"name":"oishee","email":"naziakarim@gmail.com","password":"naziakarim","phoneno":"012345","dob":new Date("2002-01-14"),"address":"dhaka","date":new Date("2023-03-14"),"working status":"manager"})
d
db.user.updateOne({"name":"oishee"}, {$set:{"followers":["naziakarim","X","Y"]}})
db.user.updateOne({"name":"naziakarim"}, {$set:{"followers":["naziakarim","X","Y"]}})
db.user.updateOne({"name":"naziakarimkhan"}, {$set:{"followers":["naziakarim","X","Y"]}})
e
db.post.insertOne({"postcreator":"naziakarim","date":new Date("2023-03-14"),"like":2,"likedby":["x","y","z"]})
db.post.insertOne({"postcreator":"naziakarimkhan","date":new Date("2022-03-14"),"like":2,"likedby":["x","y","z","w"]})
db.post.insertOne({"postcreator":"naziakarim","date":new Date("2023-03-20"),"like":2,"likedby":["x","y","z"]})

f 
db.post.updateOne({"postcreator":"naziakarim"}, {$set:{"comments":["good","excellent","nice"],"commenter":["naziakarimkhan","oishee"]}})

3
a
-- db.post.aggregate(
-- { $project : { postcreator : 1 } },
--   { $sort : { date : 1 } }
-- );
db.post.find().sort({"date": -1})
b
db.post.find({"date":{$gt:new Date(Date.now() - 24*60*60*1000)}})
c 
db.user.aggregate([{$project: {num: {"$size": {"$ifNull" : ["$followers",[]]}}}} , {$match: {num: {$gt: 3}}}])
d


db.user.updateOne({"name":"oishee"}, {$set:{"following":["naziakarim","X","Y"]}})
db.user.updateOne({"name":"naziakarim"}, {$set:{"following":["naziakarim","X","Y","Z"]}})

db.user.aggregate([{$project: {num: {"$size": {"$ifNull" : ["$following",[]]}}}} , {$match: {num: {$gt: 3}}}])