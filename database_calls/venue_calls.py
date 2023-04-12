import psycopg2
import json
import urllib.request


# Stretch Goal TO-DO

# Connection pooling/ find a way to open the connection when you open app and close when you exit


def getLatLongFromAddress(streetAddress, city, state, zipCode):
    parsedAddress = ""
    for char in streetAddress:
        if char == ' ':
            parsedAddress += '%20'
        else:
            parsedAddress += char

    parsedCity = ""
    for char in city:
        if char == ' ':
            parsedCity += '%20'
        else:
            parsedCity += char

    inputAddress = parsedAddress + '%20' + \
        parsedCity + '%20' + state + '%20' + zipCode
    print("Calling w/ Addr = " + inputAddress)
    with urllib.request.urlopen("https://api.tomtom.com/search/2/geocode/" + inputAddress + "\".json?storeResult=false&view=Unified&key=HzCaw6sMLGU2pkrmzVaYgtvAmGNFTQIS") as response:
        data = response.read()
    # data = html[0]  # ["position"]
    dict = json.loads(data)
    latLon = dict["results"][0]["position"]
    # return as json loadable

    return latLon


def createVenue(name, streetAddress, city, state, zipCode, capacity):
    conn = psycopg2.connect(
        host="crowdwatch-database.cf3deobvnxc6.us-east-2.rds.amazonaws.com",
        database="postgres",
        user='postgres',
        password='crowdwatch')

# Open a cursor to perform database operations
    cur = conn.cursor()

    latLon = dict(getLatLongFromAddress(
        streetAddress, city, state, zipCode))
    print(latLon)
    latitude = latLon['lat']
    longitude = latLon['lon']

    sqlCommand = 'INSERT INTO venue(venueName, streetAddress, city, usstate, zipCode, latitude, longitude, currentOccupancy, maxCapacity) VALUES(%s, %s, %s, %s, %s, %s, %s, 0, %s)'

    # Try to execute the insertion of an instance of venue data
    try:
        cur.execute(sqlCommand, (name,
                    streetAddress, city, state, zipCode, latitude, longitude, capacity))

    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

    conn.commit()
    cur.close()
    conn.close()

    return 0

# Get lat and lon of venue by address (this is for search bar)


def getVenue(address):
    conn = psycopg2.connect(
        host="crowdwatch-database.cf3deobvnxc6.us-east-2.rds.amazonaws.com",
        database="postgres",
        user='postgres',
        password='crowdwatch')

    # Open a cursor to perform database operations
    cur = conn.cursor()
    sqlCommand = "SELECT * FROM venue WHERE streetaddress = '" + address + "'"

    try:
        cur.execute(sqlCommand)
        venue = list(cur.fetchall())
        if (len(venue) > 0):
            cur.close()
            conn.close()
            print(venue)
            return venue[0]

            # ask if they want to create new hotspot and route them to page

        cur.close()
        conn.close()
        return "Unable to Fetch Venue"
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

    cur.close()
    conn.close()
    return "Unable to Fetch Venue"

def getVenueByVenueID(id):
    conn = psycopg2.connect(
        host="crowdwatch-database.cf3deobvnxc6.us-east-2.rds.amazonaws.com",
        database="postgres",
        user='postgres',
        password='crowdwatch')

    # Open a cursor to perform database operations
    cur = conn.cursor()
    sqlCommand = "SELECT * FROM venue WHERE venueid = %s"

    try:
        cur.execute(sqlCommand,str(id))
        venue = list(cur.fetchall())
        if (len(venue) > 0):
            cur.close()
            conn.close()
            print(venue)
            return venue[0]
        cur.close()
        conn.close()
        return "Unable to Fetch Venue"
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

    cur.close()
    conn.close()
    return "Unable to Fetch Venue"

# Get venueid of venue by lat and lon (this is for db updating for scans)
def getClosestVenue(latitude, longitude):
    conn = psycopg2.connect(
        host="crowdwatch-database.cf3deobvnxc6.us-east-2.rds.amazonaws.com",
        database="postgres",
        user='postgres',
        password='crowdwatch')

    # Open a cursor to perform database operations
    cur = conn.cursor()

    sqlCommand = "select venueid, 2 * 20903000 * radians(asind(sqrt(power(sind((latitude - %s)/2), 2)\
         + cosd(%s) * cosd(latitude) * power(sind((longitude - %s)/2), 2)))) as dist from venue where \
         2 * 20903000 * radians(asind(sqrt(Power(sind((latitude - %s)/2), 2) + cosd(%s) * cosd(latitude)\
         * power(sind((longitude - %s)/2), 2)))) <= 360 order by dist asc"  # proximity threshold is 360 ft = 120 yds

    try:
        cur.execute(sqlCommand, (latitude, latitude, longitude, latitude, latitude, longitude))
        venue = list(cur.fetchall())
        if (len(venue) > 0):
            for v in venue:
                print("Venue: " + str(v[0]) + " Dist: " + str(v[1]))
            cur.close()
            conn.close()
            return venue[0][0]

            # ask if they want to create new hotspot and route them to page

        cur.close()
        conn.close()
        return "Unable to Fetch Venue"
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

    cur.close()
    conn.close()
    return "Unable to Fetch Venue"


# Gets IDs Names and Adresses for all venues
def getAllVenues():
    conn = psycopg2.connect(
        host="crowdwatch-database.cf3deobvnxc6.us-east-2.rds.amazonaws.com",
        database="postgres",
        user='postgres',
        password='crowdwatch')

    # Open a cursor to perform database operations
    cur = conn.cursor()
    sqlCommand = "SELECT venueID, venueName, streetAddress FROM venue"

    try:
        cur.execute(sqlCommand)
        venueList = []
        venues = list(cur.fetchall())
        if (len(venues) > 0):
            for currVenue in venues:
                venueList.append(currVenue)
            cur.close()
            conn.close()
            return venueList

            # ask if they want to create new hotspot and route them to page

        cur.close()
        conn.close()
        return "Unable to Fetch Venues"
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

    cur.close()
    conn.close()
    return "Unable to Fetch Venues"
# Insert VenueData into DB
# Updates the venue to the latest occupancy


def insertVenueData(venue, count, day, hour):
    conn = psycopg2.connect(
        host="crowdwatch-database.cf3deobvnxc6.us-east-2.rds.amazonaws.com",
        database="postgres",
        user='postgres',
        password='crowdwatch')

# Open a cursor to perform database operations
    cur = conn.cursor()
    sqlCommand = 'INSERT INTO venueData(venueid, occupancy, weekday, hour) VALUES(%s, %s, %s, %s)'
    sqlCommand2 = 'UPDATE venue SET currentOccupancy = ' + \
        str(count)+' WHERE venueid = ' + str(venue)

    # Try to execute the insertion of an instance of venue data

    try:
        cur.execute(sqlCommand, (venue, count, day, hour))

    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

    try:
        cur.execute(sqlCommand2)

    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

    conn.commit()
    cur.close()
    conn.close()
    return 0


def venueAutocomplete(latitude, longitude, searching):
    try:
        # Connect to the PostgreSQL database
        conn = psycopg2.connect(
            host="crowdwatch-database.cf3deobvnxc6.us-east-2.rds.amazonaws.com",
            database="postgres",
            user="postgres",
            password="crowdwatch"
        )
        # Create a cursor object
        cur = conn.cursor()
        # Execute the SQL query
        sqlCommand = "select venuename, streetaddress, city, usstate, zipcode, latitude, longitude, asind( sqrt( power(sind((latitude - " + \
            "%s)/2), 2) + cosd(" + \
            "%s) * cosd(latitude) * power(sind((longitude - " + \
            "%s)/2), 2))) as dist from venue where venuename like " + \
            "%s order by dist asc;"
        cur.execute(sqlCommand, (latitude, latitude, longitude, '%'+searching+'%'))
        venues = list(cur.fetchall())
        if (len(venues) > 0):
            for v in venues:
                print("Venue: " + str(v[0]) + " Dist: " + str(v[1]))
            return venues
        else:
            return 'No Matching Venues Found'
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return 'Unable to Fetch Venues'

    conn.commit()
    cur.close()
    conn.close()

    return 0
