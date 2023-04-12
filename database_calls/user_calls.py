import psycopg2


def validateUserLogin(email, password):
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
        cur.execute(
            "SELECT userid FROM userData WHERE email=%s AND password=%s",
            (email, password)
        )
        # Fetch the result
        result = cur.fetchone()
        # Close the cursor and connection
        cur.close()
        conn.close()
        # Return True if the result is not None
        return result is not None
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False


def addUser(user):
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
        cur.execute(
            "SELECT userid FROM userData WHERE email=%s",
            (user.email)
        )
        # Fetch the result
        result = cur.fetchone()
        # If the email is not already registered, add the user to the database
        if result is None:
            cur.execute(
                "INSERT INTO userData (email, password) VALUES (%s, %s)",
                (user.email, user.password)
            )
            conn.commit()
            cur.close()
            conn.close()
            return True
        else:
            cur.close()
            conn.close()
            return False
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        return False



# def validateSignIn(email, password):
#     conn = psycopg2.connect(
#         host="crowdwatch-database.cf3deobvnxc6.us-east-2.rds.amazonaws.com",
#         database="postgres",
#         user='postgres',
#         password='crowdwatch')
# # Open a cursor to perform database operations
#     cur = conn.cursor()
#     sqlCommand = 'SELECT email FROM userData WHERE email = ' + \
#         email + ' AND password = ' + password
#     try:
#         cur.execute(sqlCommand)
#         users = list(cur.fetchall())
#         cur.close()
#         conn.close()
#         if len(users) > 0:
#             return True
#         return False
#     except (Exception, psycopg2.DatabaseError) as error:
#         print(error)

#     cur.close()
#     conn.close()

#     return 0


def emailExists(email, password):
    conn = psycopg2.connect(
        host="crowdwatch-database.cf3deobvnxc6.us-east-2.rds.amazonaws.com",
        database="postgres",
        user='postgres',
        password='crowdwatch')

# Open a cursor to perform database operations
    cur = conn.cursor()
    sqlCommand = 'SELECT email FROM userData WHERE email = ' + email
    try:
        cur.execute(sqlCommand)
        users = list(cur.fetchall())
        cur.close()
        conn.close()
        if len(users) > 0:
            return True
        return False
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

    cur.close()
    conn.close()

    return 0


def getFavorites(userid):
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
        sqlCommand = "select * from favoriteData where userid = %s;"

        cur.execute(sqlCommand, userid)
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

    conn.commit()
    cur.close()
    conn.close()

    return 0
