import psycopg2
import json


def getHeatMapData():

    conn = psycopg2.connect(
        host="crowdwatch-database.cf3deobvnxc6.us-east-2.rds.amazonaws.com",
        database="postgres",
        user='postgres',
        password='crowdwatch')

    # # Open a cursor to perform database operations
    cur = conn.cursor()

    sqlCommand = 'SELECT latitude, longitude, currentOccupancy FROM venue'
    # # Try to execute the insertion of an instance of venue data
    try:

        cur.execute(sqlCommand)
        heatMapData = list(cur.fetchall())

    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

    conn.commit()
    cur.close()
    conn.close()

    dict = {
        "type": "FeatureCollection",
        "features": []
    }

    for point in heatMapData:
        longitude = float(point[0])
        latitude = float(point[1])
        magnitude = point[2]

        heatPoint = {
            "type": "Feature",
            "properties": {"mag": magnitude},
            "geometry": {
                    "type": "Point",
                    "coordinates": [latitude, longitude]
            }
        }
        featureList = dict.get("features")
        featureList.append(heatPoint)
        dict.update([('features', featureList)])

    return json.dumps(dict)
