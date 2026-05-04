*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource     bearer_token.robot

Suite Setup    Get Bearer Token

*** Test Cases ***
Shopper_login
    [Documentation]    Test case to verify shopper login functionality
    Create Session    shopper_session    ${BASE_URL}  verify=False

    ${payload}=     Create Dictionary
    ...     email=${USER_EMAIL}
    ...     password=${USER_PASSWORD}
    ...     role=${USER_ROLE}

    ${response}=    POST On Session     shopper_session    /users/login    json=${payload}

    SHould Be Equal As Integers    ${response.status_code}    200

    ${body}=    Set Variable    ${response.json()}
    ${user_id}=   Get From Dictionary    ${body}[data]    userId

    ${fetched_email}=    Get From Dictionary    ${body}[data]    email
    Should Be Equal    ${fetched_email}    ${USER_EMAIL}

Find Shopper data by shopperId
    [Documentation]  Test case to verify fetching shopper data by shopperId.
    Create Session  shopper_session  ${BASE_URL}  verify=False

    ${header}=  Create Dictionary  Authorization=Bearer ${token}

    ${response}=  GET On Session  shopper_session  /shoppers/${user_id}  headers=${header}

    Should Be Equal As Integers  ${response.status_code}  200

    ${body}=  Set Variable  ${response.json()}
    Log To Console    ${body}


Update the shopper Details
    [Documentation]  Test case to verify updating shopper details.
    Create Session  shopper_session  ${BASE_URL}  verify=False

    ${header}=  Create Dictionary  Authorization=Bearer ${token}

    ${payload}=  Create Dictionary
    ...  city=Bengaluru
    ...  country=India
    ...  email=${USER_EMAIL}
    ...  firstName=Yadav
    ...  gender=MALE
    ...  lastName=Seth
    ...  password=string
    ...  phone=9890004532
    ...  state=HR
    ...  zoneId=ALPHA

    ${response}=  PATCH On Session  shopper_session  /shoppers/${user_id}  headers=${header}  json=${payload}

    Should Be Equal As Integers  ${response.status_code}  200

    ${body}=  Set Variable  ${response.json()}
    Log To Console    ${body}

