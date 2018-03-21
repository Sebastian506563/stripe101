PRIVATE_KEY=sk_test_O27a7bcKqDZTPbjn4MuSJUvq

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
Echo $SKU

SKUs=$(curl https://api.stripe.com/v1/skus?limit=3 \
    -u $PRIVATE_KEY: \
    -G )

SKU_ID=$(Echo "$SKUs" | jq -r '.data[0].id' )

Echo $SKU_ID

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
   -d email="emma.moore@example.com")


ORDER_ID=$(Echo "$ORDER" | jq -r '.id' )

curl https://api.stripe.com/v1/orders/$ORDER_ID \
   -u $PRIVATE_KEY:

curl https://api.stripe.com/v1/orders/$ORDER_ID/pay \
   -u $PRIVATE_KEY: \
   -d source=tok_visa