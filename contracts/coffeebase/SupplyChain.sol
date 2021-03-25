pragma solidity ^0.5.16;

import "../coffeeaccesscontrol/FarmerRole.sol";
import "../coffeeaccesscontrol/DistributorRole.sol";
import "../coffeeaccesscontrol/RetailerRole.sol";
import "../coffeeaccesscontrol/ConsumerRole.sol";
import "../coffeecore/Ownable.sol";

// Define a contract 'Supplychain'
contract SupplyChain is
    FarmerRole,
    DistributorRole,
    RetailerRole,
    ConsumerRole,
    Ownable
{
    // Define a variable called 'upc' for Universal Product Code (UPC)
    uint256 upc;

    // Define a variable called 'sku' for Stock Keeping Unit (SKU)
    uint256 sku;

    // Define a public mapping 'items' that maps the UPC to an Item.
    mapping(uint256 => Item) items;

    // Define a public mapping 'itemsHistory' that maps the UPC to an array of TxHash,
    // that track its journey through the supply chain -- to be sent from DApp.
    mapping(uint256 => string[]) itemsHistory;

    // Define enum 'State' with the following values:
    enum State {
        Harvested, // 0
        Processed, // 1
        Packed, // 2
        ForSale, // 3
        Sold, // 4
        Shipped, // 5
        Received, // 6
        Purchased // 7
    }

    State constant defaultState = State.Harvested;

    // Define a struct 'Item' with the following fields:
    struct Item {
        uint256 sku; // Stock Keeping Unit (SKU)
        uint256 upc; // Universal Product Code (UPC), generated by the Farmer, goes on the package, can be verified by the Consumer
        address ownerID; // Metamask-Ethereum address of the current owner as the product moves through 8 stages
        address payable originFarmerID; // Metamask-Ethereum address of the Farmer
        string originFarmName; // Farmer Name
        string originFarmInformation; // Farmer Information
        string originFarmLatitude; // Farm Latitude
        string originFarmLongitude; // Farm Longitude
        uint256 productID; // Product ID potentially a combination of upc + sku
        string productNotes; // Product Notes
        uint256 productPrice; // Product Price
        State itemState; // Product State as represented in the enum above
        address distributorID; // Metamask-Ethereum address of the Distributor
        address retailerID; // Metamask-Ethereum address of the Retailer
        address payable consumerID; // Metamask-Ethereum address of the Consumer
    }

    // Define 8 events with the same 8 state values and accept 'upc' as input argument
    event Harvested(uint256 upc);
    event Processed(uint256 upc);
    event Packed(uint256 upc);
    event ForSale(uint256 upc);
    event Sold(uint256 upc);
    event Shipped(uint256 upc);
    event Received(uint256 upc);
    event Purchased(uint256 upc);

    // Define a modifer that verifies the Caller
    modifier verifyCaller(address _address) {
        require(msg.sender == _address, "Caller doesn't match expected caller");
        _;
    }

    // Define a modifier that checks if the paid amount is sufficient to cover the price
    modifier paidEnough(uint256 _price) {
        require(msg.value >= _price, "Not enough ether to purchase");
        _;
    }

    // Define a modifier that checks the price and refunds the remaining balance
    modifier checkValue(uint256 _upc) {
        uint256 _price = items[_upc].productPrice;
        uint256 amountToReturn = msg.value - _price;
        msg.sender.transfer(amountToReturn);
        _;
    }

    // Define a modifier that checks if an item.state of a upc is Harvested
    modifier harvested(uint256 _upc) {
        require(
            items[_upc].itemState == State.Harvested,
            "Item should be in harvested state"
        );
        _;
    }

    // Define a modifier that checks if an item.state of a upc is Processed
    modifier processed(uint256 _upc) {
        require(
            items[_upc].itemState == State.Processed,
            "Should be in processed state"
        );
        _;
    }

    // Define a modifier that checks if an item.state of a upc is Packed
    modifier packed(uint256 _upc) {
        require(
            items[_upc].itemState == State.Packed,
            "Should be in packed state"
        );
        _;
    }

    // Define a modifier that checks if an item.state of a upc is ForSale
    modifier forSale(uint256 _upc) {
        require(
            items[_upc].itemState == State.ForSale,
            "Should be in for-sale state"
        );
        _;
    }

    // Define a modifier that checks if an item.state of a upc is Sold
    modifier sold(uint256 _upc) {
        require(items[_upc].itemState == State.Sold, "Should be in Sold state");
        _;
    }

    // Define a modifier that checks if an item.state of a upc is Shipped
    modifier shipped(uint256 _upc) {
        require(
            items[_upc].itemState == State.Shipped,
            "Should be in shipped state"
        );
        _;
    }

    // Define a modifier that checks if an item.state of a upc is Received
    modifier received(uint256 _upc) {
        require(
            items[_upc].itemState == State.Received,
            "Should be in received state"
        );
        _;
    }

    // Define a modifier that checks if an item.state of a upc is Purchased
    modifier purchased(uint256 _upc) {
        require(
            items[_upc].itemState == State.Purchased,
            "Should be in purchased state"
        );
        _;
    }

    // In the constructor set 'owner' to the address that instantiated the contract
    // and set 'sku' to 1
    // and set 'upc' to 1
    constructor() public payable {
        sku = 1;
        upc = 1;
    }

    // Define a function 'kill' if required
    function kill() public onlyOwner {
        selfdestruct(msg.sender);
    }

    // Define a function 'harvestItem' that allows a farmer to mark an item 'Harvested'
    function harvestItem(
        uint256 _upc,
        address payable _originFarmerID,
        string memory _originFarmName,
        string memory _originFarmInformation,
        string memory _originFarmLatitude,
        string memory _originFarmLongitude,
        string memory _productNotes
    ) public onlyFarmer {
        require(
            isFarmer(_originFarmerID),
            "Farmer address is not a valid farmer"
        );

        // Add the new item as part of Harvest

        items[_upc] = Item({
            sku: sku,
            upc: _upc,
            ownerID: _originFarmerID,
            originFarmerID: _originFarmerID,
            originFarmName: _originFarmName,
            originFarmInformation: _originFarmInformation,
            originFarmLatitude: _originFarmLatitude,
            originFarmLongitude: _originFarmLongitude,
            productID: _upc + sku,
            productNotes: _productNotes,
            productPrice: 0,
            itemState: State.Harvested,
            distributorID: address(0),
            retailerID: address(0),
            consumerID: address(0)
        });

        // Increment sku
        sku = sku + 1;
        // Emit the appropriate event
        emit Harvested(_upc);
    }

    // Define a function 'processtItem' that allows a farmer to mark an item 'Processed'
    function processItem(uint256 _upc)
        public
        harvested(_upc)
        onlyFarmer
        verifyCaller(items[_upc].originFarmerID)
    {
        // Update the appropriate fields
        items[_upc].itemState = State.Processed;
        // Emit the appropriate event
        emit Processed(_upc);
    }

    // Define a function 'packItem' that allows a farmer to mark an item 'Packed'
    function packItem(uint256 _upc)
        public
        processed(_upc)
        onlyFarmer
        verifyCaller(items[_upc].originFarmerID)
    {
        // Update the appropriate fields
        items[_upc].itemState = State.Packed;
        // Emit the appropriate event
        emit Packed(_upc);
    }

    // Define a function 'sellItem' that allows a farmer to mark an item 'ForSale'
    function sellItem(uint256 _upc, uint256 _price)
        public
        packed(_upc)
        onlyFarmer
        verifyCaller(items[_upc].originFarmerID)
    {
        items[_upc].productPrice = _price;
        items[_upc].itemState = State.ForSale;
        emit ForSale(_upc);
    }

    // Define a function 'buyItem' that allows the disributor to mark an item 'Sold'
    // Use the above defined modifiers to check if the item is available for sale, if the buyer has paid enough,
    // and any excess ether sent is refunded back to the buyer
    function buyItem(uint256 _upc)
        public
        payable
        forSale(_upc)
        onlyDistributor
        paidEnough(items[_upc].productPrice)
        checkValue(_upc)
    {
        // Update the appropriate fields - ownerID, distributorID, itemState
        items[_upc].ownerID = msg.sender;
        items[_upc].distributorID = msg.sender;
        items[_upc].itemState = State.Sold;

        // Transfer money to farmer
        items[_upc].originFarmerID.transfer(items[_upc].productPrice);

        // emit the appropriate event
        emit Sold(_upc);
    }

    // Define a function 'shipItem' that allows the distributor to mark an item 'Shipped'
    // Use the above modifers to check if the item is sold
    function shipItem(uint256 _upc, address retailerID)
        public
        sold(_upc)
        onlyDistributor
        verifyCaller(items[_upc].distributorID)
    {
        items[_upc].retailerID = retailerID;
        items[_upc].itemState = State.Shipped;
        emit Shipped(_upc);
    }

    // Define a function 'receiveItem' that allows the retailer to mark an item 'Received'
    // Use the above modifiers to check if the item is shipped
    function receiveItem(uint256 _upc)
        public
        shipped(_upc)
        onlyRetailer
        verifyCaller(items[_upc].retailerID)
    {
        // Update the appropriate fields - ownerID, retailerID, itemState
        items[_upc].ownerID = msg.sender;
        items[_upc].retailerID = msg.sender;
        items[_upc].itemState = State.Received;

        // Emit the appropriate event
        emit Received(_upc);
    }

    // Define a function 'purchaseItem' that allows the consumer to mark an item 'Purchased'
    // Use the above modifiers to check if the item is received
    function purchaseItem(uint256 _upc) public received(_upc) onlyConsumer {
        // Update the appropriate fields - ownerID, consumerID, itemState
        items[_upc].ownerID = msg.sender;
        items[_upc].consumerID = msg.sender;
        items[_upc].itemState = State.Purchased;
        // Emit the appropriate event
        emit Purchased(_upc);
    }

    // Define a function 'fetchItemBufferOne' that fetches the data
    function fetchItemBufferOne(uint256 _upc)
        public
        view
        returns (
            uint256 itemSKU,
            uint256 itemUPC,
            address ownerID,
            address originFarmerID,
            string memory originFarmName,
            string memory originFarmInformation,
            string memory originFarmLatitude,
            string memory originFarmLongitude
        )
    {
        // Assign values to the 8 parameters
        Item memory item = items[_upc];

        return (
            item.sku,
            item.upc,
            item.ownerID,
            item.originFarmerID,
            item.originFarmName,
            item.originFarmInformation,
            item.originFarmLatitude,
            item.originFarmLongitude
        );
    }

    // Define a function 'fetchItemBufferTwo' that fetches the data
    function fetchItemBufferTwo(uint256 _upc)
        public
        view
        returns (
            uint256 itemSKU,
            uint256 itemUPC,
            uint256 productID,
            string memory productNotes,
            uint256 productPrice,
            uint256 itemState,
            address distributorID,
            address retailerID,
            address consumerID
        )
    {
        // Assign values to the 9 parameters
        Item memory item = items[_upc];

        return (
            item.sku,
            item.upc,
            item.productID,
            item.productNotes,
            item.productPrice,
            uint256(item.itemState),
            item.distributorID,
            item.retailerID,
            item.consumerID
        );
    }
}
