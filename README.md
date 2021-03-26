# Udacity Blockchain Project 3
*Submitted by Ed Voas, March 26, 2021*

## Summary
This is my version of the third project where we implement a supply chain contract. I stuck with the original Coffee starter.

I wanted to add more phases, but did not get the time. For example, I'd like to have had a phase where the qty and price could be adjusted, so the farmer sells to distributor at some price, and the distributor to the retailer at another and finally the consumer would also pay more. This would have made the state diagram enormous, however. :-)

This leaves a lot to be desired in terms of how we seem to use upc and sku. Ideally, each actor might have their own internal tracking numbers (even if they maybe all shared a lot number, say). Also, it seems we just use upc for everything and that does not seem right. I think it's OK to show overall flow like here, but it certainly wouldn't work in the real world. On top of that there's no concept of quantity anywhere. If a farmer harvests a metric ton of beans, the distributor would normally break that down into its own sort of resale packaging and pricing. So might a retailer.

## Running to Test Locally
To use the web page, you first need to run a local `ganache-cli` server with whatever mnemonics you want to ensure stable accounts.

```
ganache-cli -m <mnemonics>
```

You can then migrate the contract and then run the server...

```
truffle migrate
npm run dev
```

I've modified the scripts to build a `dist` directory to run the application out of. I did this mostly to make it easier to also deploy it to IPFS.

You can see any output in the inspector in Chrome, e.g. The easiest way to use it is to just create a metamask account using the contract owner's private key and you can then step through every stage of the supply chain process. This is because the contract owner is naturally a member of every role. 

I wanted to allow you to set the address of each actor along the way and assign them roles, but I felt that would be to complex to test.

## Code Notes

I wasn't really sure what to do with `Ownable`. The rubric says to make sure it's filled out, but it already was. I made the supply chain inherit from it at least and use the onlyOwner as needed.

I put in extra checks to ensure that, for example, the farmer ID passed in when harvesting MUST be the farmer that also processes, packs, etc.

I also changed shipItem() to take the address of the desired Retailer. This helps us validate that that receiver is the ONLY entity that can take receipt of the goods.

I replaced the version of truffle-contract.js with a more up-to-date one and one that matched my version of web3.

## Diagrams
- [Activity Diagram](diagrams/activity.png)
- [State Diagram](diagrams/state.png)
- [Sequence Diagram](diagrams/sequence.png)
- [Class Diagram](diagrams/class.png)

## Truffle Version

Truffle v5.1.65 (core: 5.1.65)
Solidity - 0.5.16 (solc-js)
Node v15.7.0
Web3.js v1.2.9

From `package.json`:

"@truffle/contract": "^4.3.11",
"glob": "^7.1.6",
"truffle-hdwallet-provider": "^1.0.17"

`glob` was used for my script to build the `dist` folder.

## Rinkeby Deployment

Contract can be seen here: https://rinkeby.etherscan.io/address/0x3B11d38754db7d0Cf1ef452b7D87258166906575

```
Compiling your contracts...
===========================
> Compiling ./contracts/coffeebase/SupplyChain.sol
> Artifacts written to /Users/voas/src/blockchain/nd1309-Project-6b-Example-Template-master/project-6/build/contracts
> Compiled successfully using:
   - solc: 0.5.16+commit.9c3226ce.Emscripten.clang



Migrations dry-run (simulation)
===============================
> Network name:    'rinkeby-fork'
> Network id:      4
> Block gas limit: 10000000 (0x989680)


1_initial_migration.js
======================

   Replacing 'Migrations'
   ----------------------
   > block number:        8299888
   > block timestamp:     1616731725
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.627648214
   > gas used:            210237 (0x3353d)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00210237 ETH

   -------------------------------------
   > Total cost:          0.00210237 ETH


2_deploy_contracts.js
=====================

   Replacing 'FarmerRole'
   ----------------------
   > block number:        8299890
   > block timestamp:     1616731731
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.624240124
   > gas used:            313446 (0x4c866)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00313446 ETH


   Replacing 'DistributorRole'
   ---------------------------
   > block number:        8299891
   > block timestamp:     1616731736
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.621090544
   > gas used:            314958 (0x4ce4e)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00314958 ETH


   Replacing 'RetailerRole'
   ------------------------
   > block number:        8299892
   > block timestamp:     1616731741
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.617947324
   > gas used:            314322 (0x4cbd2)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00314322 ETH


   Replacing 'ConsumerRole'
   ------------------------
   > block number:        8299893
   > block timestamp:     1616731746
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.614804104
   > gas used:            314322 (0x4cbd2)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00314322 ETH


   Replacing 'SupplyChain'
   -----------------------
   > block number:        8299894
   > block timestamp:     1616731760
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.579739244
   > gas used:            3506486 (0x358136)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.03506486 ETH

   -------------------------------------
   > Total cost:          0.04763534 ETH


Summary
=======
> Total deployments:   6
> Final cost:          0.04973771 ETH





Starting migrations...
======================
> Network name:    'rinkeby'
> Network id:      4
> Block gas limit: 10000000 (0x989680)


1_initial_migration.js
======================

   Replacing 'Migrations'
   ----------------------
   > transaction hash:    0xc2beadc4b54e62343b9cef3663604745a27876e41773f044ef5bfa3bf8e10c7d
   > Blocks: 1            Seconds: 12
   > contract address:    0x05bE1e5035c44CDf809949d16326212976Ba2488
   > block number:        8299891
   > block timestamp:     1616731781
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.627485214
   > gas used:            226537 (0x374e9)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00226537 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.00226537 ETH


2_deploy_contracts.js
=====================

   Replacing 'FarmerRole'
   ----------------------
   > transaction hash:    0x39411df158bd2f05815285bfc071f8217d96dd1dd0fdbb49a81667cedd52ff36
   > Blocks: 1            Seconds: 12
   > contract address:    0xf93fA572B464B753cCCffF0b88478C30FFdCFA0a
   > block number:        8299893
   > block timestamp:     1616731811
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.623737124
   > gas used:            329046 (0x50556)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00329046 ETH


   Replacing 'DistributorRole'
   ---------------------------
   > transaction hash:    0xca4e9b2cc037c2909e65af21e493e10220563a12fb9e7737e177e1cc00b8b972
   > Blocks: 1            Seconds: 12
   > contract address:    0x70267150540E1E4F697B035D10fe10F214a72211
   > block number:        8299894
   > block timestamp:     1616731826
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.620431544
   > gas used:            330558 (0x50b3e)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00330558 ETH


   Replacing 'RetailerRole'
   ------------------------
   > transaction hash:    0xbb1c465ae2a2b5abec39b556772ade2518fc1d3e053736fe860cd11a5be4f2af
   > Blocks: 1            Seconds: 12
   > contract address:    0xb99ca766db7a44f4B64a7356a29c1443E6AC0442
   > block number:        8299895
   > block timestamp:     1616731841
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.617132324
   > gas used:            329922 (0x508c2)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00329922 ETH


   Replacing 'ConsumerRole'
   ------------------------
   > transaction hash:    0x263de85c5750bf97bcda0ee30dcc88cb72cd560ad65f515f7101992e207872a6
   > Blocks: 1            Seconds: 12
   > contract address:    0x0CB2511cC0D454AE3b0c6B67dee554eeA8Bcf393
   > block number:        8299896
   > block timestamp:     1616731856
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.613833104
   > gas used:            329922 (0x508c2)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00329922 ETH


   Replacing 'SupplyChain'
   -----------------------
   > transaction hash:    0x4f115c396bf9a06762182243621ec7a7f0247d6f5c270ba26bbaa18ddb2f5eb7
   > Blocks: 1            Seconds: 12
   > contract address:    0x3B11d38754db7d0Cf1ef452b7D87258166906575
   > block number:        8299897
   > block timestamp:     1616731871
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.577646244
   > gas used:            3618686 (0x37377e)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.03618686 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.04938134 ETH


Summary
=======
> Total deployments:   6
> Final cost:          0.05164671 ETH```
```