Steps:

1. Clone the repository
2. Open the terminal and in the root folder , run $ python3 -m http.server. The website would be accessible via chrome , by typing "localhost:8000" in the address bar.
3. Get Goerli ether on https://faucets.chain.link/ or https://goerlifaucet.com/
4. The contract uses a dummy variant of the USDT token, deployed on Goerli. This was decided , as faucets for "real" tUSDT are basically non-existent
5. Copy all the contracts from ContractsV2 folder into a new workspace in Remix
   6.You should mint yourself some TestUSDT tokens at address: 0xe00D656db10587363c6106D003d08fBE2F0EaC81. Compile the TestUSDT and the go to the deploy and run tab. Paste this address in the "At address" box, and the UI with the callable contract functions should pop up. Then call the mint function with "999999999999999999999999999999" as an amount.
6. from the TestUSDT contract's interface that was just loaded, click the approve function. Enter this address (to allow it to handle the tokens on your behalf ) 0xad1a76ffbf12d45c23fd9d1f1e073d05ce9bde39 and type "999999999999999999999999999999" as an amount.
7. Go back to the localhost:8000 tab in your internet browser and enter an amount to be swapped (NOTE: Do not enter amount, higher than 50, as the liquidity is not much)
8. Check you address on Opensea(Goerli) - it would have the NFT minted. Regarding the NFTD stablecoin, check your last transaction over on https://goerli.etherscan.io/. it will be minted at 1:1 ratio to the amount that you types as an input.
