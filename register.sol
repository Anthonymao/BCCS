pragma solidity ^0.4.17; 

contract Register{
    uint[] public ID;//可以查询工人的ID 即公钥
    struct Requester{
        uint IDr;
        address account; //用户地址
        address[] tasks;  
        address[] donetasks;//需要考虑一个requester发布多个任务吗？
    }
    mapping(address => Requester) accountToRequester;
    mapping(address => bool) public registered;//给一个映射判断一个地址是否已经注册 registered[一个ID]=注册过or no

    modifier registeredRequester(address _account){
        require(registered[_account]);
        _;
    }//修饰符判断是否为注册成员

    struct Worker{
        uint IDw;
        address account; //用户地址
    }
    mapping(address => Worker) accountToWorker;

    modifier registeredWorker(address _account){
        require(registered[_account]);
        _;
    }//修饰符判断是否为注册成员

    function r_register(uint _ID) public{
        require(!registered[msg.sender]);//调用合约者未注册  
        Requester memory newRequester = Requester({
           IDr: _ID,
           account: msg.sender,
           tasks: new address[](0),
           donetasks: new address[](0)
        });//记录一个新成员
        
        accountToRequester[msg.sender] = newRequester;//映射 当前地址-》新成员结构
        registered[msg.sender] = true;//记录成已注册
    }

    function w_register(uint _ID) public{
        require(!registered[msg.sender]);//调用合约者未注册  
        Worker memory newWorker = Worker({
           IDw: _ID,
           account: msg.sender
        });//记录一个新成员
        
        accountToWorker[msg.sender] = newWorker;//映射 当前地址-》新成员结构
        registered[msg.sender] = true;//记录成已注册
        ID.push(_ID);//把ID存在查询列表中
    }

    function getRequester(address _account) 
    public registeredRequester(_account) view returns(
        uint, address[], address[]
    )
    {//查询一个成员 需求是已经注册的成员 
        Requester memory requester = accountToRequester[_account];//结构体类型Member 为当前地址对应 复制到定义的r
        
        return (
            requester.IDr,
            requester.tasks,
            requester.donetasks
        );//返回ID、任务
    }
}