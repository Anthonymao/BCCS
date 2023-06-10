pragma solidity ^0.4.17;
import "./register.sol";
contract TaskPublish is Register{
    struct Task{
        uint pks;//加密的公钥
        uint IDr;
        string description;
        address recipient;//任务写定的接受sol地址
        uint t;//写成截止日期好还是写成发布日期好呢
        uint t_published;
        uint n;//该任务的拟接受的最大提交数量
        bool finished;
    }
    
    uint pks;
    uint IDr;
    string description;
    address recipient;
    uint t;
    uint t_published;
    uint n;
    bool active;//判断一个任务是否为可提交状态
    address public req;//requester地址
    
    address[] public workers;//记录提交的工人addr
    uint workernumber;
    mapping(address => bool) public isWorker;//isWorker[addr]=is or not 判断是否为这个任务的worker
    Task[] public tasks;
    mapping(address => string) private answers;//提交

    constructor(
        address _req, uint _pks, uint _IDr, string _description, address _recipient, uint _t, uint _t_published
    ) public
    {//constr 需要指出函数名称吗
        req = _req;
        pks = _pks;
        IDr = _IDr;
        description = _description;
        recipient = _recipient;
        t = _t;
        t_published=_t_published;
        active = true;
        workernumber = 0;
    }


    function submittedworker(string _ans) public{
        require(!isWorker[msg.sender]);
        answers[msg.sender] = _ans;
        workers.push(msg.sender);
        require(req != msg.sender);
        isWorker[msg.sender] = true;
        workernumber++;
    }//提交任务worker

    modifier onlyRequester(address _address){
        require(_address == req);//指的是发布任务的requester
        _;
    }

    function createTask(
        uint _pks, uint _IDr, string _description, address _recipient, uint _t, uint _n
    ) public onlyRequester(msg.sender) 
    {
        Task memory newTask = Task({
            pks: _pks,
            IDr: _IDr,
            description: _description,
            recipient: _recipient,
            t: _t,
            t_published: now,
            n: _n,
            finished: false
        });
        
        tasks.push(newTask);
    }

    function getTask(uint _index) public view returns(
        uint, uint, string, address, uint, uint 
    )
    {
        Task memory task = tasks[_index];
        return (
            task.pks, task.IDr, task.description, task.recipient,
            task.t, task.t_published
        );
    }

    function getAnswers(address _addr) public view returns (string memory) {
        require (msg.sender == req);
        return answers[_addr];
    }

    function pay(uint _n) public payable{
        require(msg.value >= 0.0001 ether);
        workers[_n].transfer(msg.value);
    }
    
}
