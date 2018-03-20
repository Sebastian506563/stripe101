PRIVATE_KEY=sk_test_O27a7bcKqDZTPbjn4MuSJUvq

CUSTOMER=$(curl https://api.stripe.com/v1/customers \
   -u $PRIVATE_KEY: \
   -d description="Magic customer" \
   -d "metadata[my_database_id]=my_database_id")

#show id 
CUSTOMER_ID=$(Echo "$CUSTOMER" | jq -r '.id' )

#create card - normally it should be done by frontend/elements.js
TOKEN=$(curl https://api.stripe.com/v1/tokens \
   -u sk_test_O27a7bcKqDZTPbjn4MuSJUvq: \
   -d card[number]=4242424242424242 \
   -d card[exp_month]=12 \
   -d card[exp_year]=2019 \
   -d card[cvc]=123)

#retrieve token id and card id
CARD_ID=$(Echo "$TOKEN" | jq -r '.card.id' )
TOKEN_ID=$(Echo "$TOKEN" | jq -r '.id' )

#attach card to customer 1st way
curl https://api.stripe.com/v1/customers/$CUSTOMER_ID/sources \
   -u $PRIVATE_KEY: \
   -d source=$TOKEN_ID

read -r -p "Press any key to continue" -n 1

curl https://api.stripe.com/v1/charges \
   -u $PRIVATE_KEY: \
   -d amount=1100 \
   -d currency=usd \
   -d customer=$CUSTOMER_ID \
   -d source=$CARD_ID
