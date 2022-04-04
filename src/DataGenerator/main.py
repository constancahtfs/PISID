from datetime import datetime
import json
import random
import uuid

elements = []

zones = ["Z1", "Z2"]


def create_data(number, file_name, zone=None):
    for i in range(0, number):
        element = {
            "_id": str(uuid.uuid4()),
            "Zona": zone if zone else random.choice(zones),
            "Data": datetime.today().strftime('%Y-%m-%dT%H:%M:%SZ'),
            "Medicao": random.uniform(1.5, 8.9)
        }

        elements.append(element)

        elements_json = json.dumps(elements, indent=2)

        # Change the file path for your local box
        f = open(f"C:\\Users\\const\\PycharmProjects\\CreatePISIDData\\{file_name}.json", "w")
        f.write(elements_json)
        f.close()


create_data(300, "sensorL1", "Z1")
create_data(300, "sensorL2", "Z2")

create_data(300, "sensorT1", "Z1")
create_data(300, "sensorT2", "Z2")

create_data(300, "sensorH1", "Z1")
create_data(300, "sensorH2", "Z2")