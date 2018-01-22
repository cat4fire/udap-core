module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            network_id: "1234",
            from: '0xe901e19886daee0a8cd5a54128a87f4ef6f0f2ae'
        }
    },
    solc: {
        optimizer: {
            enabled: false
            //  runs: 200
        }
    }
};
