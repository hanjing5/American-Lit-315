# Product Show (Get)
curl http://0.0.0.0:3000/api/v1/product.json -d token=12345
#curl http://0.0.0.0:3000/api/v1/product.json -d token=12345 -d productid[]=1 -d productid[]=2
#curl http://0.0.0.0:3000/api/v1/product.json -d token=12345 -d productid=1
#curl http://0.0.0.0:3000/api/v1/product.json -d url=www.facebook.com -d token=1
#curl http://0.0.0.0:3000/api/v1/product.json -d productid=1
#curl http://0.0.0.0:3000/api/v1/coupon.json -d token=skladjfklajf

# Product Purchase (Get)
#curl http://0.0.0.0:3000/api/v1/product.json -d token=12345
#curl http://0.0.0.0:3000/api/v1/product/buy.json -d usertoken=12345 -d productid=1 -d user[email]=hanqijing@gmail.com -d user[name]=han -d user[username]=coke12 -d card[number]=4242424242424242 -d card[ccv]=123 -d card[expmon]=02 -d card[expyear]=2015 -d ip=1234567890 -d url=http://google.com 

