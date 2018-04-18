PRIVATE_KEY=#1. private key#

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


SRC=#2, Create payment source - remember about currency :)

   
SRC_ID=$(Echo "$SRC" | jq -r '.id' )
THREE_DS_URL=$(Echo "$SRC" | jq -r '.redirect.url' )

# #attach card to customer 1st way
curl https://api.stripe.com/v1/customers/$CUSTOMER_ID/sources \
   -u $PRIVATE_KEY: \
   -d source=$SRC_ID

read -r -p "Go to: $THREE_DS_URL and confirm your payment and wait few seconds :)..." -n 1

#3. Create a charge with capture - false and true and check dashboard
