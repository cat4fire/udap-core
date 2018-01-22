#!/usr/bin/env bash
basepath=$(cd `dirname $0`; pwd)
echo $basepath

projectpath=$(cd `dirname $0`;cd ../../java;pwd)
echo $projectpath

cd ${basepath}/contracts

#solcjs -o ${basepath}/build/binapi/ --abi --bin ${basepath}/contracts/Account.sol

#solcjs -o ${basepath}/build/binapi/ --abi --bin ${basepath}/contracts/AccountToken.sol

#solcjs -o ${basepath}/build/binapi/ --abi --bin ${basepath}/contracts/TicketManager.sol

#solcjs -o ${basepath}/build/binapi/ --abi --bin ${basepath}/contracts/TokenManager.sol

web3j solidity generate ${basepath}/build/binapi/Account.bin ${basepath}/build/binapi/Account.abi -o ${projectpath} -p cn.iclass.live2.sols

web3j solidity generate ${basepath}/build//binapi/AccountToken.bin ${basepath}/build/binapi/AccountToken.abi -o ${projectpath} -p cn.iclass.live2.sols

web3j solidity generate ${basepath}/build//binapi/TicketManager.bin ${basepath}/build/binapi/TicketManager.abi -o ${projectpath} -p cn.iclass.live2.sols

web3j solidity generate ${basepath}/build//binapi/TokenManager.bin ${basepath}/build/binapi/TokenManager.abi -o ${projectpath} -p cn.iclass.live2.sols

web3j solidity generate ${basepath}/build/binapi/IClassToken.bin ${basepath}/build/binapi/IClassToken.abi -o ${projectpath} -p cn.iclass.live2.sols