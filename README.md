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

You can leave he top section blank if you want to just use the contract owner to run through the states. Otherwise, you can assign accounts here for each of the roles (do this using the contract owner account). Just make sure to import and switch to the right account before clicking the buttons that require that account. If you add accounts here you will see the transactions at the bottom showing the additions happening.

## Code Notes

I wasn't really sure what to do with `Ownable`. The rubric says to make sure it's filled out, but it already was. I made the supply chain inherit from it at least and use the onlyOwner as needed.

I put in extra checks to ensure that, for example, the farmer ID passed in when harvesting MUST be the farmer that also processes, packs, etc.

I also changed shipItem() to take the address of the desired Retailer. This helps us validate that that receiver is the ONLY entity that can take receipt of the goods.

I changed adding a role to not require that the address not exist. That was a little too extreme, and I can't think of any reason why it would be bad to add the same account to the same role twice.

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

## IPFS

I put this onto IPFS (where everything is forever) here: http://gateway.ipfs.io//ipfs/k51qzi5uqu5dju1ixq48p13sovzgu8sn8ltwqh1kpnyjff5uelrt6kqw327spx
(However, the gateway was telling me "unrecognized object type: 114" but I wanted to submit anyway.)

## Rinkeby Deployment

Contract can be seen here: https://rinkeby.etherscan.io/address/0x56e9ED1D31c2e57C66e3097a0E40F3FF8BDC61be

```
Compiling your contracts...
===========================
> Everything is up to date, there is nothing to compile.



Migrations dry-run (simulation)
===============================
> Network name:    'rinkeby-fork'
> Network id:      4
> Block gas limit: 10000000 (0x989680)


1_initial_migration.js
======================

   Replacing 'Migrations'
   ----------------------
   > block number:        8300378
   > block timestamp:     1616739074
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.575257244
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
   > block number:        8300380
   > block timestamp:     1616739080
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.571929114
   > gas used:            305450 (0x4a92a)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.0030545 ETH


   Replacing 'DistributorRole'
   ---------------------------
   > block number:        8300381
   > block timestamp:     1616739085
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.568859434
   > gas used:            306968 (0x4af18)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00306968 ETH


   Replacing 'RetailerRole'
   ------------------------
   > block number:        8300382
   > block timestamp:     1616739089
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.565796114
   > gas used:            306332 (0x4ac9c)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00306332 ETH


   Replacing 'ConsumerRole'
   ------------------------
   > block number:        8300383
   > block timestamp:     1616739094
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.562732794
   > gas used:            306332 (0x4ac9c)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00306332 ETH


   Replacing 'SupplyChain'
   -----------------------
   > block number:        8300384
   > block timestamp:     1616739108
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.527779694
   > gas used:            3495310 (0x35558e)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.0349531 ETH

   -------------------------------------
   > Total cost:          0.04720392 ETH


Summary
=======
> Total deployments:   6
> Final cost:          0.04930629 ETH





Starting migrations...
======================
> Network name:    'rinkeby'
> Network id:      4
> Block gas limit: 10000000 (0x989680)


1_initial_migration.js
======================

   Replacing 'Migrations'
   ----------------------
   > transaction hash:    0xba7688ce41752bed3a10988dd6aeef16428bb0019427040bbe47cfce06315f39
   > Blocks: 1            Seconds: 16
   > contract address:    0xdD451d66F36F64243a3A793075473596c2C21D0d
   > block number:        8300381
   > block timestamp:     1616739133
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.575094244
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
   > transaction hash:    0x4425e1432b7cd59bac6d34b6e729d4c603df10a3e9c520baa862398b39ba7e42
   > Blocks: 1            Seconds: 12
   > contract address:    0x3d8f593890ab0c858D2cc22AC084433E2E4b7bAD
   > block number:        8300383
   > block timestamp:     1616739163
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.571419114
   > gas used:            321750 (0x4e8d6)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.0032175 ETH


   Replacing 'DistributorRole'
   ---------------------------
   > transaction hash:    0x24ac5005a24dd0e10c96067aad4ebb448333972a408e0c79110e9e023f33dbe2
   > Blocks: 1            Seconds: 12
   > contract address:    0x29209348C534480eB3D9517dCb9556Cab3A0B045
   > block number:        8300384
   > block timestamp:     1616739178
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.568186434
   > gas used:            323268 (0x4eec4)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00323268 ETH


   Replacing 'RetailerRole'
   ------------------------
   > transaction hash:    0xcc2c91b1e325676f8f9d565f7e2eb5ad96905a50063bdd5e8d69426fd1a7aa97
   > Blocks: 1            Seconds: 12
   > contract address:    0x9a700845De9CE219b7F47955eb8074A43C932158
   > block number:        8300385
   > block timestamp:     1616739193
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.564960114
   > gas used:            322632 (0x4ec48)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00322632 ETH


   Replacing 'ConsumerRole'
   ------------------------
   > transaction hash:    0x3219609d2246887e8bb3385b1febb40e6a064d4bd309379fdcd38b82865665a3
   > Blocks: 1            Seconds: 12
   > contract address:    0xf6BafAC595266474C871c0c509BD756cb1bb5e04
   > block number:        8300386
   > block timestamp:     1616739208
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.561733794
   > gas used:            322632 (0x4ec48)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00322632 ETH


   Replacing 'SupplyChain'
   -----------------------
   > transaction hash:    0x890cca3fa1f25ce4b0a684067b699afb211d5ae3090990b215f3189e626ddfb4
   > Blocks: 0            Seconds: 12
   > contract address:    0x56e9ED1D31c2e57C66e3097a0E40F3FF8BDC61be
   > block number:        8300387
   > block timestamp:     1616739223
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.525630694
   > gas used:            3610310 (0x3716c6)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.0361031 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.04900592 ETH


Summary
=======
> Total deployments:   6
> Final cost:          0.05127129 ETH
```