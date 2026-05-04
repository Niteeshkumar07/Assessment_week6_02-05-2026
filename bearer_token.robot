*** Settings ***
Library     RequestsLibrary
Library     Collections

*** Variables ***
${BASE_URL}     https://www.shoppersstack.com/shopping
${USER_EMAIL}   boom@gmail.com
${USER_PASSWORD}    string
${USER_ROLE}    SHOPPER

*** Keywords ***
Get Bearer Token
    Create Session    auth_session    ${BASE_URL}   verify=False
    
    ${payload}=     Create Dictionary
    ...     email=${USER_EMAIL}
    ...     password=${USER_PASSWORD}
    ...     role=${USER_ROLE}
    
    ${response}=    POST On Session     auth_session    /users/login    json=${payload}
    
    Should Be Equal As Integers    ${response.status_code}    200
    
    ${body}=    Set Variable    ${response.json()}
    ${token}=   Get From Dictionary    ${body}[data]    jwtToken
    
    Set Suite Variable    ${token}

    ${user_id}=  Get From Dictionary    ${body}[data]    userId    default
    Set Suite Variable    ${user_id}