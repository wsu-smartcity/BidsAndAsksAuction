
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
      for (uint i = 0; i < length; i++) {
        uint j = i+1;
        uint temp = a[i];
        while (j > 0 && a[j] > a[j-1]) {
          a[j] = a[j-1];
          j--;
          a[j-1] = temp;
        }
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
    
    function addBid(uint _bidId,address _owner,uint _price, uint _amount){
        Bidstructure record = bid[_bidId];
        record.bidId=_bidId;
        record.owner.length++;
        record.owner[record.owner.length-1]=_owner;
        record.price.length++;
        record.price[record.price.length-1]=_price;
        record.amount.length++;
        record.amount[record.amount.length-1]=_amount;
        record.price= insertionSortAscending(record.price,record.price.length);
        record.amount= insertionSortAscending(record.price,record.amount.length);
        
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
    
    mapping(uint => Askstructure) ask; 
    
    function addAsk(uint _askId,address _owner,uint _price, uint _amount){
        Askstructure record = ask[_askId];
        record.askId=_askId;
        record.owner.length++;
        record.owner[record.owner.length-1]=_owner;
        record.price.length++;
        record.price[record.price.length-1]=_price;
        record.amount.length++;
        record.amount[record.amount.length-1]=_amount;
        record.price= insertionSortDescending(record.price,record.price.length);
        record.price= insertionSortDescending(record.price,record.price.length);
    }
    
    function getAsks(uint _askId)public constant returns (uint,address[],uint[],uint[]){
        return (ask[_askId].askId,ask[_askId].owner,ask[_askId].price,ask[_askId].amount);
    }
}