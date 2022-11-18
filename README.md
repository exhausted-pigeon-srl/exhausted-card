# exhausted-card
fully onchain NFT business card



# deploy 
source .env && forge script Deploy --rpc-url $GOERLI_RPC_PROVIDER_URL --broadcast --private-key $PK --verify --etherscan-api-key $ETHERSCAN_API_KEY -vvv
source .env && forge script Deploy --rpc-url $MAINNET_RPC_PROVIDER_URL --broadcast --private-key $PK --verify --etherscan-api-key $ETHERSCAN_API_KEY -vvv
etc