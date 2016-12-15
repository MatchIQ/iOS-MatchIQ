from flask import Flask
from flask import jsonify
from flask import request

import json
import os
import math
from os.path import join, dirname
from math import radians, cos, sin, asin, sqrt, atan2
from watson_developer_cloud import TradeoffAnalyticsV1

app = Flask(__name__)
id_current = 0

def increment_id_current():
    global id_current
    id_current = id_current+1

class Column():
    "Stores the column objectives"
    def __init__(self, key, ctype, goal, is_objective, full_name):
        self.key = key
        self.type = ctype
        self.goal = goal
        self.is_objective = is_objective
        self.full_name = full_name

    def to_json(self):
        return  {
            "key":self.key,
            "type":self.type,
            "goal":self.goal,
            "is_objective":self.is_objective,
            "full_name":self.full_name
            }

class Card():
    "Stores the data set"
    def __init__(self, id_from_table, title, description, city, address, zipcode, latitude, longitude, url, thumbnail, tripadvisor, user_rating, category, price):
        self.id = int (id_from_table)
        self.title = title
        self.description = description
        self.city = city
        self.address = address
        self.zipcode = zipcode
        self.latitude = float (latitude.replace(",", "."))
        self.longitude = float (longitude.replace(",", "."))
        self.url = url
        self.thumbnail = thumbnail
        self.tripadvisor = (tripadvisor.replace(",", "."))
        self.user_rating = int (user_rating)
        self.category = category
        self.price = int (price.rstrip('\r\n'))
        distance = self.distance_from_city_center(self.latitude, self.longitude)
        self.distance = distance

    def distance_from_city_center(self, lat2, lng2):
        lat1 = 52.3731
        lng1 = 4.8926

        radius = 6371

        dLat = (lat2-lat1) * math.pi / 180
        dLng = (lng2-lng1) * math.pi / 180

        lat1 = lat1 * math.pi / 180
        lat2 = lat2 * math.pi / 180

        val = sin(dLat/2) * sin(dLat/2) + sin(dLng/2) * sin(dLng/2) * cos(lat1) * cos(lat2)
        ang = 2 * atan2(sqrt(val), sqrt(1-val))
        return radius * ang

class Tradeoff_values():
    "Stores the variables required for tradeoff analytics"
    def __init__(self, distance, tripadvisor_rating, user_rating, price):
        self.distance = distance
        self.tripadvisor_rating = tripadvisor_rating
        self.user_rating = user_rating
        self.price = price

    def to_json(self):
        return { "distance":self.distance,
                 "tripadvisor_rating":self.tripadvisor_rating,
                 "user_rating":self.user_rating,
                 "price":self.price
                 }

class Tradeoff_card():
    "stores the entire card sent for each attraction for tradeoff analytics"
    def __init__(self, key, name, value):
        self.key = key
        self.name = name
        self.value = value

    def to_json(self):
        return {
                'values':self.value.to_json(),
                'name':self.name,
                'key':self.key
                 }

tradeoff_analytics = TradeoffAnalyticsV1(
    username='5a147b54-27e1-4b54-a3cf-7b584552a338',
    password='stcMENKASW3h')

columns = []

columns.append(Column("distance", "numeric", "max", "true", "Distance").to_json())
columns.append(Column("tripadvisor_rating", "numeric", "max", "true", "tripadvisor rating").to_json())
columns.append(Column("user_rating", "numeric", "max", "true", "User rating").to_json())
columns.append(Column("price", "numeric", "min", "true", "Price of Attraction").to_json())

dataset = []
init_dataset = []

#with io.open('file.txt', encoding='utf_8_sig'):
#    data = f.read()
filestream = open('cleaned_dataset.csv', 'r')
#filestream = filestream[3:]
#filestream = open('dataset_test', 'r')
for line in filestream:
    line.rstrip('\r\n')
    current_line = line.split(';')
    init_dataset.append(Card(current_line[0], current_line[1], current_line[2], current_line[3], current_line[4], current_line[5], current_line[6], current_line[7], current_line[8], current_line[9], current_line[10], 5, current_line[12], current_line[13]))

@app.route('/initdata', methods=['GET', 'POST'])
def initialise_data():
    categories = request.get_json(silent=True)

    for category in categories:
        for data in init_dataset:
            if (category["user_category"] == data.category):
                dataset.append(data)
    return jsonify(categories)

@app.route('/newcard', methods=['GET', 'POST'])
def new_card_request():

    options = []
    # 1. Send current table to watson - tradeoff analysis.
    # 2. Rank the viable options returned by watson.
    # 3. Return the primary key of the top card. - Assumption : App and server share the exact same database.
    global dataset

    if not dataset:
        dataset = init_dataset

    for data in dataset:
        options.append(Tradeoff_card(data.id, data.title, Tradeoff_values(float (data.distance), float (data.tripadvisor.rstrip('\r\n')), data.user_rating, int(data.price))).to_json())

    #print options
    tradeoff_problem = {}
    tradeoff_problem["options"] = options
    tradeoff_problem["columns"] = columns
    tradeoff_problem["subject"] = "magiq"

    #content = request.get_json(force=True)
    #print tradeoff_problem
    #with open(os.path.join(os.path.dirname(__file__), 'problem.json')) as problem_json:
    dilemma = tradeoff_analytics.dilemmas(tradeoff_problem, generate_visualization=False)

    #print 1

    #print dilemma
    resolution = dilemma['resolution']

    #print resolution
    success = []
    for d in resolution['solutions']:
        if(d['status']=='FRONT'):
            success.append(d)

    #success.sort() #TODO figure out how to sort according to one particular key


    return jsonify(success)
    #return jsonify(dilemma)

@app.route('/update', methods=['GET', 'POST'])
def update_table_request():
    # 1. Receive the top card and the user's response to it (left, right, up)
    card_update = request.get_json(silent=True)
    key = int (card_update['key'])
    action = int (card_update['action'])

    #print "key"
    #print key

    if (action == -1):
        user_rating_update = -0.5
    else:
        user_rating_update = 0.5

    for card in dataset:
        if (card.id == key):
            category = card.category
            dataset.remove(card)
            break

    for card in dataset:
        if (card.category == category):
            card.user_rating = card.user_rating + user_rating_update
            if (card.user_rating > 10) :
                card.user_rating = 10
            elif (card.user_rating < 10) :
                card.user_rating = 0

    # 2. Manipulate the data set.
    return jsonify(card_update)

@app.route('/test', methods=['GET', 'POST'])
def test():
    columns = []
    col = Column("zipcode", "numeric", "max", "true", "Location Zipcode")
    columns.append(col)
    return json.dumps(col.__dict__)
