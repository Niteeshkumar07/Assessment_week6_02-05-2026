*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    bearer_token.robot
Resource     shoppers_address.robot
Resource     shopper_cart.robot

Suite Setup    Get Bearer Token


*** Test Cases ***
Display Order History
    [Documentation]  Test case to verify fetching order history of a shopper.
    Create Session  order_session  ${BASE_URL}  verify=False

    ${header}=  Create Dictionary  Authorization=Bearer ${token}

    ${response}=  GET On Session  order_session  /shoppers/${user_id}/orders  headers=${header}

    Should Be Equal As Integers  ${response.status_code}  200

    ${body}=  Set Variable  ${response.json()}
    Log To Console    ${body}

    Set Suite Variable    ${address_id}   ${body}[data][0][address][addressId]
    Set Suite Variable    ${order_id}   ${body}[data][0][orderId]

Place Order form Cart
    [Documentation]  Test case to verify placing order from cart for a shopper.
    Create Session  order_session  ${BASE_URL}  verify=False

    ${header}=  Create Dictionary  Authorization=Bearer ${token}

    ${address}=  Create Dictionary
    ...  addressId=${address_id}
    ...  buildingInfo=string
    ...  city=string
    ...  country=string
    ...  landmark=string
    ...  name=string
    ...  phone=string
    ...  pincode=string
    ...  state=string
    ...  streetInfo=string
    ...  type=string

    ${payload}=  Create Dictionary
    ...  address=${address}
    ...  paymentMode=COD

    ${response}=  POST On Session  order_session  /shoppers/${user_id}/orders  headers=${header}  json=${payload}

    Should Be Equal As Integers  ${response.status_code}  201

    ${body}=  Set Variable  ${response.json()}
    Log To Console    ${body}

Update Order Status
    [Documentation]  Test case to verify updating order status for a shopper.
    Create Session  order_session  ${BASE_URL}  verify=False

    ${header}=  Create Dictionary  Authorization=Bearer ${token}

    ${params}=  Create Dictionary   status=DELIVERED

    ${response}=  Patch On Session  order_session  /shoppers/${user_id}/orders/${order_id}  headers=${header}  params=${params}

    Should Be Equal As Integers  ${response.status_code}  200

    ${body}=  Set Variable  ${response.json()}
    Log To Console    ${body}


Generate Invoice for an Order
    [Documentation]  Test case to verify generating invoice for an order of a shopper.
    Create Session  order_session  ${BASE_URL}  verify=False

    ${header}=  Create Dictionary  Authorization=Bearer ${token}

    ${response}=  GET On Session  order_session  /shoppers/${user_id}/orders/${order_id}/invoice  headers=${header}

    Should Be Equal As Integers  ${response.status_code}  200

    ${body}=  Set Variable  ${response.json()}
    Log To Console    ${body}

