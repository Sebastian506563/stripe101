PRIVATE_KEY=#1 private key


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

PRODUCT=#2. create a product

PROD_ID=$(Echo "$PRODUCT" | jq -r '.id' )

SKU=#3. create sku for product

Echo "SKU and product created"

SKUs=$(curl https://api.stripe.com/v1/skus?limit=3 \
    -u $PRIVATE_KEY: \
    -G )

#gets first SKU ID
SKU_ID=$(Echo "$SKUs" | jq -r '.data[0].id' )

#USER BEGINS HIS PATH HERE :)

ORDER=#4. Create an order with created SKU and producy

Echo "Order Created"


ORDER_ID=$(Echo "$ORDER" | jq -r '.id' )

#5. pay for order

#6. Create a coupon and use it :)