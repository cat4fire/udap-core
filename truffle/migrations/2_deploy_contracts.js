var IClassToken = artifacts.require("./IClassToken");
module.exports = function(deployer,network,accounts) {
  deployer.deploy(IClassToken);
 // deployer.link(A, B);
 // deployer.deploy(A,"0x2e582a718a8f77652e9a026feb005db9fa898b11");
    // deployer.deploy(A,B.address);
};
