from __future__ import print_function
import time
# from googleapiclient.errors import HttpError

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException


from database_calls.venue_calls import *

option = webdriver.ChromeOptions()
option.add_experimental_option('excludeSwitches', ['enable-logging'])
option.add_argument("headless")


def getLiveData(id, name, address):
    # TODO Check if it's closed
    day = time.localtime().tm_wday
    hour = time.localtime().tm_hour

    parsedName = ""
    for char in name:
        if char == ' ':
            parsedName += '+'
        else:
            parsedName += char

    parsedAddress = ""
    for char in address:
        if char == ' ':
            parsedAddress += '+'
        else:
            parsedAddress += char

    parsedQueryInput = parsedName+"+"+parsedAddress

    driver = webdriver.Chrome(
        '/chromedriver_win32/chromedriver', options=option)
    # print("here")
    try:
        driver.get(
            "https://www.google.com/search?q=" + parsedQueryInput)
        currentOccupancy = driver.find_element(
            By.CLASS_NAME, "VKx1id")
        count = (float(currentOccupancy.get_attribute('style')[8:-3]) / 10.0)
        # insertVenueData(venue, count, day, hour)
        print(count)
        liveData = count
    # either means that it does not have live data, closed, or no data. The no live data is coded right now
    except NoSuchElementException:
        # try to get predictive data for this hour
        try: 
            driver.get(
                "https://www.google.com/search?q=" + parsedQueryInput)
            currentOccupancy = driver.find_element(
                By.CLASS_NAME, "UmVrSe")
            newCount = (
                float(currentOccupancy.get_attribute('style')[8:-3]) / 10.0)

            print(newCount)
            liveData = newCount
        # the venue is either closed or there's no data, so return -1 I guess
        except NoSuchElementException:
            print('No data; returning -1')
            liveData = -1
    # add liveData to the db
    if id > 0:
        insertVenueData(id, liveData, day, hour)
    else:
        # it's one of the test cases at the bottom of this file, so don't add to the db
        print(name,'has no live data, so we got',liveData,'instead.')

        


def getPredictiveData(name, address):
    # TODO Check if it's closed
    parsedName = ""
    for char in name:
        if char == ' ':
            parsedName += '+'
        else:
            parsedName += char

    parsedAddress = ""
    for char in address:
        if char == ' ':
            parsedAddress += '+'
        else:
            parsedAddress += char

    parsedQueryInput = parsedName+"+"+parsedAddress

    try:
        driver = webdriver.Chrome(
            '/chromedriver_win32/chromedriver', options=option)
        driver.get(
            "https://www.google.com/search?q=" + parsedQueryInput)
        currentOccupancy = driver.find_elements(
            By.CLASS_NAME, "D6mXgd")
        hours = driver.find_elements(
            By.CLASS_NAME, "wYzX9b")

        hoursList = []
        occupancyList = []
        i = 0
        for style in currentOccupancy:

            occupancy = style.find_element(
                By.CLASS_NAME, "cwiwob").get_attribute('style')[8:-3]
            if (float(occupancy) != 0.0):
                occupancyList.append(float(occupancy))
                hoursList.append(hours[i].get_attribute("data-hour"))

            i += 1
        dict = {}
        list = []
        # Check dict for key if not, return 0 it is closed
        for i in range(len(hoursList)):
            print(hoursList[i] + " | " + str(occupancyList[i]))
            dict.update({str(hoursList[i]): str(occupancyList[i])})
            list.append((str(hoursList[i]), str(occupancyList[i])))
        return dict, list

    except:
        # TODO(developer) - Handle errors from gmail API.
        # print(f'An error occurred: {error}')
        print("This place is closed")

# testing to see if getLiveData edge cases (no live data--only hourly & no data at all) work correctly
getLiveData(-1,"Starbucks", "409 University Dr, College Station")
getLiveData(-1,"The Junction Market & Cafe", "177 Joe Routt Blvd")
