PRIVATE_KEY=sk_test_O27a7bcKqDZTPbjn4MuSJUvq

CUSTOMER=$(curl https://api.stripe.com/v1/customers \
   -u $PRIVATE_KEY: \
   -d description="Magic customer" \
   -d "metadata[my_database_id]=my_database_id")

#show id 
CUSTOMER_ID=$(Echo "$CUSTOMER" | jq -r '.id' )

#create card - normally it should be done by frontend/elements.js
TOKEN=$(curl https://api.stripe.com/v1/tokens \
   -u $PRIVATE_KEY: \
   -d card[number]=4000000000003063 \
   -d card[exp_month]=12 \
   -d card[exp_year]=2019 \
   -d card[cvc]=123)

#retrieve token id and card id
CARD_ID=$(Echo "$TOKEN" | jq -r '.card.id' )
TOKEN_ID=$(Echo "$TOKEN" | jq -r '.id' )


read -p "Give me a source token created via frontend(3dSecureTestFlow.html in first field): " CARD_SRC

#create card source
SRC=$(curl https://api.stripe.com/v1/sources \
   -u sk_test_O27a7bcKqDZTPbjn4MuSJUvq: \
   -d amount=1099 \
   -d currency=usd \
   -d type=three_d_secure \
   -d redirect[return_url]="http://www.funcage.com/?" \
   -d three_d_secure[card]=$CARD_SRC)

   
SRC_ID=$(Echo "$SRC" | jq -r '.id' )
THREE_DS_URL=$(Echo "$SRC" | jq -r '.redirect.url' )

# #attach card to customer 1st way
curl https://api.stripe.com/v1/customers/$CUSTOMER_ID/sources \
   -u $PRIVATE_KEY: \
   -d source=$SRC_ID

read -r -p "Go to: $THREE_DS_URL and confirm your payment and wait few seconds :)..." -n 1

curl https://api.stripe.com/v1/charges \
   -u $PRIVATE_KEY: \
   -d amount=1099 \
   -d currency=usd \
   -d customer=$CUSTOMER_ID \
   -d source=$SRC_ID
