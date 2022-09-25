These four contracts represent a major part of the project's ecosystem.

The Minter contract mints our native token NFTD (NFT Dollar), every time a user deposits/swaps/ USDT into the contract. The deposit itself happens, when the listed NFT gets bought by a user. 

The Swapper contract's purpose is to take the deposited USDT ,and to convert them to ETH via the Uniswap protocol. The contract also calls the Minter contract and sends NFTD token to the depositor on a 1:1 ration (USDT:NFTD).

TestUSDT and TestETH mimic the original ETH and USDT tokens. Created on purpose, as most faucets for Rinkeby dont work properly or drip very small amounts.

Notes for the developer:

- if redeploying  one of those contoracts, its important to redeploy all of them, as they are connected. Alternatively, setter functions could be implemented for each of them in the main (Swapper contract)

- Regardless of the chain on which they are deployed, it is crucial for the chain to be EVM comaptible and to have a DEX, on which to create a liquidity pool
- SwapExactTokensForTokens should be changed to SwapExactTokensForEth upon mainnet migration .
- The Swapper address must be manually approved to spend TestUSDT (from the TestUSDT contract).