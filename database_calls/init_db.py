from venue_calls import createVenue, insertVenueData
import psycopg2

conn = psycopg2.connect(
    host="crowdwatch-database.cf3deobvnxc6.us-east-2.rds.amazonaws.com",
    database="postgres",
    user='postgres',
    password='crowdwatch')

# Open a cursor to perform database operations
cur = conn.cursor()


# Execute a command: this creates a new table
cur.execute('DROP TABLE IF EXISTS venueData CASCADE;')

cur.execute('DROP TABLE IF EXISTS venue CASCADE;')

cur.execute('DROP TABLE IF EXISTS userData CASCADE;')

cur.execute('DROP TABLE IF EXISTS favoriteData;')

cur.execute('CREATE TABLE IF NOT EXISTS \
            venue(venueID serial NOT NULL,\
            venueName varchar(65535) NOT NULL,\
            streetAddress varchar(65535) NOT NULL,\
            city varchar(65535) NOT NULL,\
            USstate varchar(65535) NOT NULL,\
            zipCode int,\
            latitude decimal, \
            longitude decimal, \
            currentOccupancy int, \
            maxCapacity int,\
            PRIMARY KEY (venueID))')


cur.execute('CREATE TABLE IF NOT EXISTS \
            venueData(venueDataID serial NOT NULL,\
            venueid int,\
            occupancy int,\
            weekday int,\
            hour int,\
            PRIMARY KEY (venueDataID),\
            FOREIGN KEY (venueid) REFERENCES venue(venueID))')

cur.execute('CREATE TABLE IF NOT EXISTS \
            userData(userID serial NOT NULL,\
            email varchar(65535),\
            password varchar(65535),\
            PRIMARY KEY (userID))')

cur.execute('CREATE TABLE IF NOT EXISTS \
            favoriteData(favoriteID serial NOT NULL,\
            userid int,\
            venueid int, \
            PRIMARY KEY (favoriteID),\
            FOREIGN KEY (venueid) REFERENCES venue(venueID), \
            FOREIGN KEY (userid) REFERENCES userData(userID))')

# create views for predictive modeling
for day in range(7):
    # depending on the day, name the view accordingly
    name = ''
    match day:
        case 0:
            name = 'Monday'
        case 1:
            name = 'Tuesday'
        case 2:
            name = 'Wednesday'
        case 3:
            name = 'Thursday'
        case 4:
            name = 'Friday'
        case 5:
            name = 'Saturday'
        case _:  # underscore is python's equivalent to default
            name = 'Sunday'
    for hour in range(24):
        cur.execute('CREATE VIEW ' + str(name) + str(hour) +
                    ' AS SELECT venueid, avg(occupancy) FROM venuedata \
            WHERE weekday = ' + str(day) + ' AND hour = ' + str(hour) +
                    ' GROUP BY venueid')
# Insert data into the table

conn.commit()

cur.close()
conn.close()

# createVenue("Chase's House", "316 Newcomb Lane",
#             "College Station", "TX", "77845", 10)

createVenue("Sweet Eugenes", "1702 George Bush Dr E",
            "College Station", "TX", "77840", 10)

# createVenue("Alex's House", "409 University Dr",
#             "College Station", "TX", "77840", 10)

# cycle through our 3 dummy venues and add dummy venue data
# for venueid in range(3):
#     # make sure day = 0 cuz of for loop to make views
#     day = 0
#     for day in range(7):
#         # make sure hour = 0 cuz of for loop to make views
#         hour = 0
#         for hour in range(24):
#             print(hour, day)
#             # add seven data pts with occupancies 0 to 6
#             for count in range(7):
#                 insertVenueData(venueid + 1, count, day, hour)
