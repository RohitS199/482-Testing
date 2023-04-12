import psycopg2


# Gets occupancy of each recorded day hour combination for a venue
# Defaults to 5 with no data: TO-DO make the default a bell curve from 3 - 5 to 3 to refelect peak hours

def getDayHourDataForVenue(venueid, day):
    conn = psycopg2.connect(
        host="crowdwatch-database.cf3deobvnxc6.us-east-2.rds.amazonaws.com",
        database="postgres",
        user='postgres',
        password='crowdwatch')
    
    # determine the view name based on the day
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
        case _: # underscore is python's equivalent to default
            name = 'Sunday'
    data = []

    # Open a cursor to perform database operations
    
    # determine the view name based on the day
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
        case _: # underscore is python's equivalent to default
            name = 'Sunday'
    data = []

    # Open a cursor to perform database operations
    cur = conn.cursor()
    for hour in range(24):
        sqlCommand = 'SELECT avg FROM ' + name + str(hour) + ' WHERE venueid = ' + str(venueid)
        try:
            cur.execute(sqlCommand)
            avg = float(cur.fetchone()[0])
            data.append(avg)
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)
    for hour in range(24):
        sqlCommand = 'SELECT avg FROM ' + name + str(hour) + ' WHERE venueid = ' + str(venueid)
        try:
            cur.execute(sqlCommand)
            avg = float(cur.fetchone()[0])
            data.append(avg)
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)

    cur.close()
    conn.close()
    # print(average)
    return data
