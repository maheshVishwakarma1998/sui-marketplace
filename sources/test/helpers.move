#[test_only]
module shoe_store::helpers {
    use sui::test_scenario::{Self as ts, next_tx, Scenario};
 
    use std::string::{Self};
    use std::vector;

    use shoe_store::store::{Shoe, test_init};

    const ADMIN: address = @0xA;
    const TEST_ADDRESS1: address = @0xB;
    const TEST_ADDRESS2: address = @0xC;

    public fun init_test_helper() : ts::Scenario{
       let owner: address = @0xA;
       let scenario_val = ts::begin(owner);
       let scenario = &mut scenario_val;
 
       {
            test_init(ts::ctx(scenario));
       };
       scenario_val
    }

}