from flask import Flask, jsonify, request, request
from flask_cors import CORS

from occupancy_data_calls import *

from database_calls.pm_calls import *
from database_calls.user_calls import *
from database_calls.hm_calls import *
from database_calls.venue_calls import *


app = Flask(__name__)
CORS(app)


@app.route('/')
def hello():
    return {
        "type": "FeatureCollection",
        "features": [
                {
                    "type": "Feature",
                    "properties": {"mag": 1.29},
                    "geometry": {
                        "type": "Point",
                        "coordinates": [-118.806, 34.022]
                    }
                },
            {
                    "type": "Feature",
                    "properties": {"mag": 1.3},
                    "geometry": {
                        "type": "Point",
                        "coordinates": [-118.806, 34.022]
                    }
                },
        ]
    }

# TO-DO
# Add in views for constantly updating averages
# ^^^ views already exist (see lines 60-83 in init_db.py) and auto-update avgs :)

@app.route('/heat-map')
def HeatMapping():

    data = getHeatMapData()

    return data


@app.route('/search-bar')
def searchbar():
    # get what's been typed so far in the search bar as well as the
    # longitude and latitude by passing it the url like:
    # http://127.0.0.1:5000/search-bar?text=foobar&lat=12&long=34
    searchText = request.args.get('text', default = '', type = str)
    lat = request.args.get('lat', default = 30.617815, type = float)
    long = request.args.get('long', default = -96.346304, type = float)
    print('searchText',searchText,'lat',lat,'long',long)
    return venueAutocomplete(lat, long, searchText)
    

@app.route('/show-page')
def showpage():
    # get address sent via route in the form
    # http://127.0.0.1:5000/show-page?address=123 Seasame St
    address = request.args.get('address', default = '1', type = str)
    # get the venue info associated with the address
    venue = getVenue(address)
    if venue != "Unable to Fetch Venue":
        # address was in db, so venue variable looks like
        # [(venueid, venuename, streetaddress, city, usstate,
        # zipcode, latitude, longitude, currentoccupancy, maxcapacity)]
        day = time.localtime().tm_wday  # gets what day of the week today is
        data = getDayHourDataForVenue(venue[0], day)
        return {'venuename': venue[1], 'streetaddress': venue[2],
                'city': venue[3], 'usstate': venue[4], 'zipcode': venue[5],
                'currentOccupancy': venue[8], 'hourlydata': data}
    else:
        # address wasn't in db, so venue variable = "Unable to Fetch Venue"
        return venue


@app.route('/predictive-modeling')
def PredictionModeling():

    data = getPredictiveData("Sweet Eugenes", "1702 George Bush Dr E")

    # venue = getVenue(address)
    # day = time.localtime().tm_wday
    # data = []
    # for i in range(24):
    #     data.append(getDayHourDataForVenue(venue, day, i))

    return data

@app.route('/closest-venue')
def closestVenue():
    # get the longitude and latitude by passing it the url like:
    # http://127.0.0.1:5000/closest-venue?lat=12&long=34
    lat = request.args.get('lat', default = 30.617815, type = float)
    long = request.args.get('long', default = -96.346304, type = float)
    print('lat',lat,'long',long)
    id = getClosestVenue(lat, long)
    if(id == "Unable to Fetch Venue"):
        return "Unable to Fetch Venue: Maybe Try Coordinates Closer to a Venue?"
    venue = getVenueByVenueID(id)
    if venue != "Unable to Fetch Venue":
        # address was in db, so venue variable looks like 
        # [(venueid, venuename, streetaddress, city, usstate,
        # zipcode, latitude, longitude, currentoccupancy, maxcapacity)]
        return {'venuename':venue[1],'streetaddress':venue[2],
                'city':venue[3],'usstate':venue[4],'zipcode':venue[5],
                'currentOccupancy':venue[8],'latitude':venue[6], 'longitude':venue[7]}
    else:
        # address wasn't in db, so venue variable = "Unable to Fetch Venue"
        return venue

@app.route('/occupancy')
def deviceInfo():  # latitude, longitude):

    venueList = getAllVenues()
    print(venueList)
    for venue in venueList:
        id = venue[0]
        name = venue[1]
        address = venue[2]
        print(id, name, address)
        getLiveData(id, name, address)
        # TODO implement fallback to predictive data
        # Implement Closed

    return '0'


@app.route('/login', methods=['POST'])  # this looks good
def login():
    data = request.get_json()
    email = data['email']
    password = data['password']
    is_valid = validateUserLogin(email, password)
    return jsonify({'isValid': is_valid})


class User:
    def __init__(self, email, password):
        self.email = email
        self.password = password

    def __repr__(self):
        return f'<User {self.email}>'


@app.route('/signup', methods=['POST'])
def signup():
    data = request.get_json()
    email = data['email']
    password = data['password']
    if not email or not password:
        return jsonify({'error': 'Email and password are required.'}), 400
    user = User(email=email, password=password)
    is_registered = addUser(user)
    if is_registered:
        return jsonify({'isRegistered': True}), 201
    else:
        return jsonify({'isRegistered': False}), 409


@app.route('/user_favorites')
def favorites():
    data = request.get_json()
    userid = data['userid']
    results = getFavorites(userid)
    return jsonify({'results': results})
