*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource     bearer_token.robot

Suite Setup    Get Bearer Token

*** Test Cases ***
Get All Address
        [Documentation]  Test case to verify fetching all addresses of a shopper.
        Create Session  address_session  ${BASE_URL}  verify=False

        ${header}=  Create Dictionary  Authorization=Bearer ${token}

        ${response}=  GET On Session  address_session  /shoppers/${user_id}/address  headers=${header}

        Should Be Equal As Integers  ${response.status_code}  200

        ${body}=  Set Variable  ${response.json()}
        Log To Console    ${body}

        Set Suite Variable    ${address_id}   ${body}[data][0][addressId]

Add New Address
        [Documentation]  Test case to verify adding new address for a shopper.
        Create Session  address_session  ${BASE_URL}  verify=False

        ${header}=  Create Dictionary  Authorization=Bearer ${token}

        ${payload}=  Create Dictionary
        ...    addressId=787878
        ...    buildingInfo=Flat 201, Tower A
        ...    city=Gurugoan
        ...    country=India
        ...    landmark=Near Metro Station
        ...    name=Yadav Seth
        ...    phone=9890004532
        ...    pincode=560001
        ...    state=Haryana
        ...    streetInfo=Effco Chowk
        ...    type=HOME

        ${response}=  POST On Session  address_session  /shoppers/${user_id}/address  headers=${header}  json=${payload}

        Should Be Equal As Integers  ${response.status_code}  201

        ${body}=  Set Variable  ${response.json()}
        Log To Console    ${body}

        Set Suite Variable    ${added_address_id}   ${body}[data][addressId]

Get a praticular address by id
        [Documentation]  Get Address by addressId for a shopper.
        Create Session  address_session  ${BASE_URL}  verify=False

        ${header}=  Create Dictionary  Authorization=Bearer ${token}

        ${response}=  GET On Session  address_session  /shoppers/${user_id}/address/${address_id}  headers=${header}

        Should Be Equal As Integers  ${response.status_code}  200

        ${body}=  Set Variable  ${response.json()}
        Log To Console    ${body}

Update an added Address
        [Documentation]  Update an added address for a shopper.
        Create Session  address_session  ${BASE_URL}  verify=False

        ${header}=  Create Dictionary  Authorization=Bearer ${token}

        ${payload}=  Create Dictionary
        ...    addressId=${added_address_id}
        ...    buildingInfo=Flat 202, Tower B
        ...    city=Gurugoan
        ...    country=India
        ...    landmark=Near Metro Station
        ...    name=Yadav Seth
        ...    phone=9890004532
        ...    pincode=560001
        ...    state=Haryana
        ...    streetInfo=Effco Chowk
        ...    type=HOME

        ${response}=  PUT On Session  address_session  /shoppers/${user_id}/address/${added_address_id}  headers=${header}  json=${payload}

        Should Be Equal As Integers  ${response.status_code}  200

        ${body}=  Set Variable  ${response.json()}
        Log To Console    ${body}


Delete an address
        [Documentation]  Delete an added address for a shopper.
        Create Session  address_session  ${BASE_URL}  verify=False

        ${header}=  Create Dictionary  Authorization=Bearer ${token}

        ${response}=  DELETE On Session  address_session  /shoppers/${user_id}/address/${added_address_id}  headers=${header}

        Should Be Equal As Integers  ${response.status_code}  204

