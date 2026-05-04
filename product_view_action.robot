*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    bearer_token.robot

Suite Setup    Get Bearer Token

*** Test Cases ***
Return All Default Products
    [Documentation]  Test case to verify fetching all default products.
    Create Session  product_session  ${BASE_URL}  verify=False

    ${header}=  Create Dictionary  Authorization=Bearer ${token}

    ${response}=  GET On Session  product_session  /products/alpha  headers=${header}

    Should Be Equal As Integers  ${response.status_code}  200

    ${body}=  Set Variable  ${response.json()}
    Log To Console    ${body}