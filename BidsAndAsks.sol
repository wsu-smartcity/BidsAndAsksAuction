
contract BidsAndAsks{

    function insertionSortAscending(uint[] a, uint length) internal returns (uint[]) {
      for (uint i = 0; i < length; i++) {
        uint j = i;
        while (j > 0 && a[j] < a[j-1]) {
          uint temp = a[j];
          a[j] = a[j-1];
          a[j-1] = temp;
          j--;
        }
      }
      return a;
    }
    function insertionSortDescending(uint[] a, uint length) internal returns (uint[]) {
      for (uint i = 1; i < length; i++) {
        uint temp = a[i];
        uint j = i-1;
        while (j >= 0 && a[j] > temp) {
          a[j+1] = a[j];
          j--;
        }
        a[j+1] = temp;
      }
      return a;
    }
    
    /* This is the bidding section*/
    struct Bidstructure{
        uint bidId;
        address[] owner;
        uint[] price;
        uint[] amount;
    }
    
   mapping(uint => Bidstructure) bid; 
   mapping(uint => Askstructure) ask; 
   
    modifier bidInMarket(uint _bidId,uint _price) {
        Askstructure records_asks = ask[_bidId];
        if (records_asks.owner.length > 0) {
            if (_price < records_asks.price[records_asks.price.length-1]) throw;
        }
        _;
    }
    
    modifier askInMarket(uint _askId,uint _price) {
        Bidstructure records_bids = bid[_askId];
        if (records_bids.owner.length > 0) {
            if (_price > records_bids.price[records_bids.price.length-1]) throw;
        }
        _;
    }
    
    function addBid(uint _bidId,address _owner,uint _price, uint _amount)bidInMarket(_bidId,_price) external returns(bool){
        Bidstructure record = bid[_bidId];
        record.bidId=_bidId;
        record.owner.length++;
        record.owner[record.owner.length-1]=_owner;
        record.price.length++;
        record.price[record.price.length-1]=_price;
        record.amount.length++;
        record.amount[record.amount.length-1]=_amount;
        record.price= insertionSortAscending(record.price,record.price.length);
        record.amount= insertionSortAscending(record.amount,record.amount.length);
        return true;
        
    }
    
    function getBids(uint _bidId)public constant returns (uint,address[],uint[],uint[]){
        return (bid[_bidId].bidId,bid[_bidId].owner,bid[_bidId].price,bid[_bidId].amount);
    }
    
    /* This is the asking section*/
    struct Askstructure{
        uint askId;
        address[] owner;
        uint[] price;
        uint[] amount;
    }
    
    
    function addAsk(uint _askId,address _owner,uint _price, uint _amount)askInMarket(_askId,_price) external returns(bool){
        Askstructure record = ask[_askId];
        record.askId=_askId;
        record.owner.length++;
        record.owner[record.owner.length-1]=_owner;
        record.price.length++;
        record.price[record.price.length-1]=_price;
        record.amount.length++;
        record.amount[record.amount.length-1]=_amount;
        record.price= insertionSortDescending(record.price,record.price.length);
        record.amount= insertionSortDescending(record.amount,record.amount.length);
        return true;
    }
    
    function getAsks(uint _askId)public constant returns (uint,address[],uint[],uint[]){
        return (ask[_askId].askId,ask[_askId].owner,ask[_askId].price,ask[_askId].amount);
    }
    
    function matchBid(uint _bidId,uint _askId) returns (bool){
        
    }
}