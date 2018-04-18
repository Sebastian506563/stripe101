PRIVATE_KEY=#1. Enter your private key

CUSTOMER=#2. Create a customer


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

#3. Attach a card to customer 1st way use source object


read -r -p "Press any key to continue" -n 1

curl https://api.stripe.com/v1/charges \
   -u $PRIVATE_KEY: \
   -d amount=1100 \
   -d currency=usd \
   -d customer=#4. put customer id -slash on the left of this text line must stay \
   -d source=#5. put card id
