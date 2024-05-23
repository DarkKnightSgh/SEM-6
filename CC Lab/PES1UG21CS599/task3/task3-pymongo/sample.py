from pymongo import MongoClient

host = MongoClient("172.17.0.4")
#host = MongoClient("mongodb")

db = host["sample_db"]
collection = db["sample_collection"]

sample_data = {"Name:":"Siri Gowri H","SRN":"PES1UG21CS599"}
collection.insert_one(sample_data)
print('Inserted into the MongoDB database!')

rec_data = collection.find_one({"SRN":"PES1UG21CS599"})
print("Fecthed from MongoDB: ",rec_data)