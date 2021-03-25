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

## Diagrams
- [Activity Diagram](diagrams/activity.png)
- [State Diagram](diagrams/state.png)
- [Sequence Diagram](diagrams/sequence.png)
- [Class Diagram](diagrams/class.png)

```
Starting migrations...
======================
> Network name:    'rinkeby'
> Network id:      4
> Block gas limit: 10000000 (0x989680)


1_initial_migration.js
======================

   Deploying 'Migrations'
   ----------------------
   > transaction hash:    0x2f3841981b49d2dfe88f427f7eec647992fb419c9ab3a58a6f9fa17bbb65e849
   > Blocks: 1            Seconds: 16
   > contract address:    0x2180A0c01B4C24301d81a81C703B8E424A584e6d
   > block number:        8288867
   > block timestamp:     1616566399
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.677185968
   > gas used:            225237 (0x36fd5)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00225237 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.00225237 ETH


2_deploy_contracts.js
=====================

   Deploying 'FarmerRole'
   ----------------------
   > transaction hash:    0x225b7cbce9eba82cea4ff5a0a019aa19848bcc6b535375173d7b6636c8fea99c
   > Blocks: 1            Seconds: 12
   > contract address:    0x59fED1cab71094001Ed6b7B5A6616a0af2eCe971
   > block number:        8288869
   > block timestamp:     1616566429
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.673477878
   > gas used:            328446 (0x502fe)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00328446 ETH


   Deploying 'DistributorRole'
   ---------------------------
   > transaction hash:    0x18e150c73ce0c20a417f65c296407121928b451eaec8a6d57d75786716f81145
   > Blocks: 0            Seconds: 8
   > contract address:    0xf5D3025136dD0e6dD3B88ecc9182aD08B2e21865
   > block number:        8288870
   > block timestamp:     1616566444
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.670178298
   > gas used:            329958 (0x508e6)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00329958 ETH


   Deploying 'RetailerRole'
   ------------------------
   > transaction hash:    0xd0d9733ebb33305469d6fee98ab62736c18051b09996c3441546c8b6c7795b4a
   > Blocks: 1            Seconds: 12
   > contract address:    0xb469ab7AcC12806373147FEd83357D897a02Add5
   > block number:        8288871
   > block timestamp:     1616566459
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.666885078
   > gas used:            329322 (0x5066a)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00329322 ETH


   Deploying 'ConsumerRole'
   ------------------------
   > transaction hash:    0x3a02ecd5e3855e07e7b3e01589524c524d9d89ccfa4074878311b2a1aa06fef4
   > Blocks: 1            Seconds: 12
   > contract address:    0x0144e73501DE17af374D7c7A99d7E87702033e0e
   > block number:        8288872
   > block timestamp:     1616566474
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.663591858
   > gas used:            329322 (0x5066a)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.00329322 ETH


   Deploying 'SupplyChain'
   -----------------------
   > transaction hash:    0x3a2f692e8f29610721acac24d3ab2736e03ae07da61cadbf8763b601a2b17ce1
   > Blocks: 1            Seconds: 12
   > contract address:    0xfadA664A57d3d129c3592056afa233B13CE2d94A
   > block number:        8288873
   > block timestamp:     1616566489
   > account:             0x8b203EAfa190fFEbd47cb08504006f6ce4ADbBf7
   > balance:             18.630684968
   > gas used:            3290689 (0x323641)
   > gas price:           10 gwei
   > value sent:          0 ETH
   > total cost:          0.03290689 ETH


   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:          0.04607737 ETH


Summary
=======
> Total deployments:   6
> Final cost:          0.04832974 ETH


https://rinkeby.etherscan.io/address/0xfada664a57d3d129c3592056afa233b13ce2d94a
```