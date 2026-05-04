*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    bearer_token.robot

Suite Setup    Get Bearer Token

*** Variables ***
${Product_Id}   59

*** Test Cases ***
Get All Products in Cart
    [Documentation]  Test case to verify fetching all products in shopper cart.
    Create Session  cart_session  ${BASE_URL}  verify=False

    ${header}=  Create Dictionary  Authorization=Bearer ${token}

    ${response}=  GET On Session  cart_session  /shoppers/${user_id}/carts  headers=${header}

    Should Be Equal As Integers  ${response.status_code}  200

    ${body}=  Set Variable  ${response.json()}
    Log To Console    ${body}

    Set Suite Variable    ${cart_item_id}   ${body}[data][0][itemId]
    Set Suite Variable    ${cart_product_id}   ${body}[data][0][productId]
Add Product to Cart
    [Documentation]  Test case to verify adding product to shopper cart.
    Create Session  cart_session  ${BASE_URL}  verify=False
    ${header}=  Create Dictionary  Authorization=Bearer ${token}
    ${payload}=  Create Dictionary
    ...  productId=${Product_Id}
    ...  quantity=1
    ${response}=  POST On Session  cart_session  /shoppers/${user_id}/carts  headers=${header}  json=${payload}
    Should Be Equal As Integers  ${response.status_code}  201
    ${body}=  Set Variable  ${response.json()}
    Log To Console    ${body}


Update a product in cart
    [Documentation]  Test case to verify updating a product in shopper cart.
    Create Session  cart_session  ${BASE_URL}  verify=False
    ${header}=  Create Dictionary  Authorization=Bearer ${token}
    ${payload}=  Create Dictionary
    ...  quantity=2
    ${response}=  Put On Session  cart_session  /shoppers/${user_id}/carts/${cart_item_id}  headers=${header}  json=${payload}
    Should Be Equal As Integers  ${response.status_code}  200
    ${body}=  Set Variable  ${response.json()}
    Log To Console    ${body}


Delete a product from cart
    [Documentation]  Test case to verify deleting a product from shopper cart.
    Create Session  cart_session  ${BASE_URL}  verify=False
    ${header}=  Create Dictionary  Authorization=Bearer ${token}
    ${response}=  DELETE On Session  cart_session  /shoppers/${user_id}/carts/${cart_product_id}  headers=${header}
    Should Be Equal As Integers  ${response.status_code}  200


