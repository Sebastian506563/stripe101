PRIVATE_KEY=#1. private key

PLAN_NAME=PREMIUM
PRODUCT_NAME=PREMIUM_SUB

PRODUCT=$(curl https://api.stripe.com/v1/products \
   -u $PRIVATE_KEY: \
   -d name=$PRODUCT_NAME\
   -d type=service)

Echo $PRODUCT

PROD_ID=$(Echo "$PRODUCT" | jq -r '.id' )

PLAN=#2. create a plan

PLAN_ID=$(Echo "$PLAN" | jq -r '.id' )

Echo "Plan and product created"

CUSTOMER=$(curl https://api.stripe.com/v1/customers \
   -u $PRIVATE_KEY: \
   -d description="Magic customer" \
   -d "metadata[my_database_id]=my_database_id")

#show id 
CUSTOMER_ID=$(Echo "$CUSTOMER" | jq -r '.id' )

#create card - normally it should be done by frontend/elements.js
TOKEN=$(curl https://api.stripe.com/v1/tokens \
   -u $PRIVATE_KEY: \
   -d card[number]=4242424242424242 \
   -d card[exp_month]=12 \
   -d card[exp_year]=2019 \
   -d card[cvc]=123)

#retrieve token id and card id
CARD_ID=$(Echo "$TOKEN" | jq -r '.card.id' )
TOKEN_ID=$(Echo "$TOKEN" | jq -r '.id' )

#attach card to customer 1st way
curl https://api.stripe.com/v1/customers/$CUSTOMER_ID \
   -u $PRIVATE_KEY: \
   -d source=$TOKEN_ID

Echo "Customer created"

#3. Subscribe user/custoemr to plan with trial


read -r -p "Enter to delete: " -n 1

curl https://api.stripe.com/v1/plans/$PLAN_NAME\
   -u $PRIVATE_KEY: \
   -X DELETE

curl https://api.stripe.com/v1/products/$PROD_ID\
   -u $PRIVATE_KEY: \
   -X DELETE