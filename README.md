### Cloning Repository ###
```https://github.com/CSCE482-Spring2023-Taele/Spearow.git```

### Starting your python environment: FIRST TIME ###
#### MacOS/Linux ####
1. ```python3 -m venv env```
2. ```pip install -r requirements.txt```
3. ```source env/bin/activate```

#### Windows ####
1. ```python3 -m venv env```
2. ```.\env\Scripts\activate```
3. ```pip install -r requirements.txt```

### Creating a new branch ###
1. Go to https://github.com/CSCE482-Spring2023-Taele/Spearow/tree/main 
2. Click on "main"
3. Type in new branch name.
4. On your command line, type in ```git pull``` in order to update your local files.
5. Type ```git checkout -b <branch_name>``` in order to to switch to your branch.

### Starting up a Local Server ###
1. Download PostgreSQL from the internet. 
2. Run ```psql -U postgres ``` to access database (could possibly be ```sudo -iu postgres psql``` for your first time)
3. Create your database ```CREATE DATABASE capacitytracker;```
4. Create a user ```CREATE USER [username] WITH PASSWORD [password];```
5. Give yourself some rights ```GRANT ALL PRIVILEGES ON DATABASE capacitytracker TO [username];```
6. Get into our environment and then set the username and password to your username and password ```export DB_USERNAME=[username]``` and ```export password=[password]```
7. Run the beautiful initialization of the database ```python init_db.py```

### Deactivating python environment ###
1. ```deactivate```
 
### Updating requirements.txt ###
1. ```pip freeze > requirements.txt```

