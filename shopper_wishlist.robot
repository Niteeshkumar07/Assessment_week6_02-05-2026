*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    bearer_token.robot

Suite Setup    Get Bearer Token

*** Test Cases ***
Get Shopper Wishlist
    [Documentation]  Test case to verify fetching shopper wishlist.
    Create Session  wishlist_session  ${BASE_URL}  verify=False
    ${header}=  Create Dictionary  Authorization=Bearer ${token}
    ${response}=  GET On Session  wishlist_session  /shoppers/${user_id}/wishlist  headers=${header}
    Should Be Equal As Integers  ${response.status_code}  200
    ${body}=  Set Variable  ${response.json()}
    Log To Console    ${body}

    Set Suite Variable    ${wishlist_item_id}   ${body}[data][0][productId]


Add Product to Wishlist
    [Documentation]  Test case to verify adding product to shopper wishlist.
    Create Session  wishlist_session  ${BASE_URL}  verify=False
    ${header}=  Create Dictionary  Authorization=Bearer ${token}
    ${payload}=  Create Dictionary
    ...  productId=85
    ...  quantity=1
    ${response}=  POST On Session  wishlist_session  /shoppers/${user_id}/wishlist  headers=${header}  json=${payload}
    Should Be Equal As Integers  ${response.status_code}  201
    ${body}=  Set Variable  ${response.json()}
    Log To Console    ${body}


Delete Product from Wishlist
    [Documentation]  Test case to verify deleting product from shopper wishlist.
    Create Session  wishlist_session  ${BASE_URL}  verify=False
    ${header}=  Create Dictionary  Authorization=Bearer ${token}
    ${response}=  DELETE On Session  wishlist_session  /shoppers/${user_id}/wishlist/${wishlist_item_id}  headers=${header}
    Should Be Equal As Integers  ${response.status_code}  204