PRIVATE_KEY=#1. private key

PRODUCT=#2. create a product

PROD_ID=$(Echo "$PRODUCT" | jq -r '.id' )

SKU=#3. create a SKU
Echo $SKU

#gets skus
SKUs=$(curl https://api.stripe.com/v1/skus?limit=3 \
    -u $PRIVATE_KEY: \
    -G )

SKU_ID=$(Echo "$SKUs" | jq -r '.data[0].id' )

Echo $SKU_ID

ORDER=#4. create an order


ORDER_ID=$(Echo "$ORDER" | jq -r '.id' )

#displays order
curl https://api.stripe.com/v1/orders/$ORDER_ID \
   -u $PRIVATE_KEY:

#5. pay for product with `tok_visa` :)
