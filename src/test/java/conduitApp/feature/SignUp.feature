Feature: Sign Up new user

    Background: Preconditions
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def timeValidator = read('classpath:helpers/timeValidator.js')
        * def randomEmail = dataGenerator.getRandomEmail()
        * def randomUsername = dataGenerator.getRandomUsername()
        * url apiUrl

    Scenario: New user Sign Up
        Given path 'users'
        And request 
        """
            {
                "user":{
                    "email": #(randomEmail),
                    "password":"123Karate123",
                    "username":#(randomUsername)
                }
            }
        """
        When method Post
        Then status 200
        And match response ==
        """
            {
            "user":{
                "email": #(randomEmail),
                "username": #(randomUsername),
                "bio": null,
                "image": "https://api.realworld.io/images/smiley-cyrus.jpeg",
                "token": "#string"
                }
            }
        """

    Scenario Outline: Validate Sign Up error messages
        Given path 'users'
        And request
        """
            {
                "user": {
                    "email": "<email>",
                    "password":"<password>",
                    "username": "<username>"
                }
            }
        """
            When method Post
            Then status 200
            And match response == <errorResponse>

            Examples:
                | email                    | password  | username                     | errorResponse                                                                        |
                | #(randomEmail)           | Karate123 | KarateUser123                | {"errors":{"username":["has already been taken"]}}                                   |
                | gustavo.teo@outlook.com  | Karate123 | #(randomUsername)            | {"errors":{"email":["has already been taken"]}}                                      |
                | gustavo.teo              | Karate123 | #(randomUsername)            | {"errors":{"email":["is invalid"]}}                                                  |
                | #(randomEmail)           | Karate123 | KarateUser1234567890123      | {"errors":{"username":["is too long (maximum is 20 characters)"]}}                   |
                | #(randomEmail)           | Kar       | #(randomUsername)            | {"errors":{"password":["is too short (minimum is 8 characters)"]}}                   |
                |                          | Karate123 | #(randomUsername)            | {"errors":{"email":["can't be blank"]}}                                              |
                | #(randomEmail)           |           | #(randomUsername)            | {"errors":{"password":["can't be blank"]}}                                           |
                | #(randomEmail)           | Karate123 |                              | {"errors":{"username":["can't be blank. is too short (minimum is 1 character)"]}}    |