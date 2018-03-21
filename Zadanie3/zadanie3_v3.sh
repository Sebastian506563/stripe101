PRIVATE_KEY=sk_test_O27a7bcKqDZTPbjn4MuSJUvq

COUPON_ID="OFF_OFF"
#create a coupon
COUPON=$(curl https://api.stripe.com/v1/coupons \
   -u $PRIVATE_KEY: \
   -d percent_off=25 \
   -d duration=once \
   -d id=$COUPON_ID)

Echo $COUPON

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

PRODUCT=$(curl https://api.stripe.com/v1/products \
   -u $PRIVATE_KEY: \
   -d name=T-shirt \
   -d type=good \
   -d description="Comfortable cotton t-shirt" \
   -d attributes[]=size \
   -d attributes[]=gender)

PROD_ID=$(Echo "$PRODUCT" | jq -r '.id' )

SKU=$(curl https://api.stripe.com/v1/skus \
   -u $PRIVATE_KEY: \
   -d attributes[size]=Medium \
   -d attributes[gender]=Unisex \
   -d price=1500 \
   -d currency=usd \
   -d inventory[type]=finite \
   -d inventory[quantity]=500 \
   -d product=$PROD_ID)

Echo "SKU and product created"

SKUs=$(curl https://api.stripe.com/v1/skus?limit=3 \
    -u $PRIVATE_KEY: \
    -G )

SKU_ID=$(Echo "$SKUs" | jq -r '.data[0].id' )

#USER BEGINS HIS PATH HERE :)

ORDER=$(curl https://api.stripe.com/v1/orders \
   -u $PRIVATE_KEY: \
   -d items[][type]=sku \
   -d items[][parent]=$SKU_ID \
   -d currency=usd \
   -d shipping[name]="Emma Moore" \
   -d shipping[address][line1]="1234 Main Street" \
   -d shipping[address][city]="San Francisco" \
   -d shipping[address][state]=CA \
   -d shipping[address][country]=US \
   -d shipping[address][postal_code]=94111 \
   -d email="emma.moore@example.com" \
   -d customer=$CUSTOMER_ID \
   -d coupon=$COUPON_ID)
Echo $ORDER

Echo "Order Created"

ORDER_ID=$(Echo "$ORDER" | jq -r '.id' )

curl https://api.stripe.com/v1/orders/$ORDER_ID/pay \
   -u $PRIVATE_KEY: \
   -d customer=$CUSTOMER_ID
