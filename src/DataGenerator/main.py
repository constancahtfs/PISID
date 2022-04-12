from datetime import datetime
import json
import random
import uuid
import time
from pymongo import MongoClient
import pymongo

zones = ["Z1", "Z2"]


def get_database():
    CONNECTION_STRING = "localhost"
    client = MongoClient(CONNECTION_STRING)
    return client['estufa']


def create_data(db, number, collection_name, zone=None):
    elements = []
    collection = db[collection_name]

    for i in range(0, number):
        element = {
            "_id": str(uuid.uuid4()),
            "Zona": zone if zone else random.choice(zones),
            "Data": datetime.today().strftime('%Y-%m-%dT%H:%M:%SZ'),
            "Medicao": random.uniform(1.5, 8.9)
        }

        elements.append(element)

    collection.insert_many(elements)


def simulate_sensor():
    print("Connecting...")
    db = get_database()
    print("Starting...")

    while True:
        #create_data(db, 300, "sensorL1", "Z1")
        #create_data(db, 300, "sensorL2", "Z2")

        #create_data(db, 300, "sensorT1", "Z1")
        #create_data(db, 300, "sensorT2", "Z2")

        create_data(db, 300, "sensorH1", "Z1")
        #create_data(db, 300, "sensorH2", "Z2")
        print("Inserted")
        time.sleep(1)


simulate_sensor()
