#[test_only]
module baptswap::swap_test {
    use std::signer;
    use test_coin::test_coins::{Self, TestCAKE, TestBUSD, TestUSDC, TestBNB, TestAPT};
    use aptos_framework::account;
    use aptos_framework::coin;
    use aptos_framework::genesis;
    use aptos_framework::resource_account;
    use baptswap::swap::{Self, LPToken, initialize};
    use baptswap::router;
    use baptswap::math;
    use aptos_std::math64::pow;
    use baptswap::swap_utils;

    const MAX_U64: u64 = 18446744073709551615;
    const MINIMUM_LIQUIDITY: u128 = 1000;

    public fun setup_test_with_genesis(dev: &signer, admin: &signer, treasury: &signer, resource_account: &signer) {
        genesis::setup();
        setup_test(dev, admin, treasury, resource_account);
    }

    public fun setup_test(dev: &signer, admin: &signer, treasury: &signer, resource_account: &signer) {
        account::create_account_for_test(signer::address_of(dev));
        account::create_account_for_test(signer::address_of(admin));
        account::create_account_for_test(signer::address_of(treasury));
        resource_account::create_resource_account(dev, b"baptswap-v1", x"");
        initialize(resource_account);
        swap::set_fee_to(admin, signer::address_of(treasury))
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    fun test_create_and_staked_tokens(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, alice, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, alice, 10 * pow(10, 8));

        let bob_liquidity_x = 10 * pow(10, 8);
        let bob_liquidity_y = 10 * pow(10, 8);
        let alice_liquidity_x = 2 * pow(10, 8);
        let alice_liquidity_y = 4 * pow(10, 8);

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, bob_liquidity_x, bob_liquidity_y, 0, 0);

        swap::set_token_pair_owner<TestCAKE, TestBUSD>(admin, signer::address_of(bob));

        // Initialize rewards pool
        router::create_rewards_pool<TestBUSD, TestCAKE>(bob, false); 

        // Enable rewards fee
        swap::set_token_fees<TestCAKE, TestBUSD>(bob, 100, 200, 200);

        let input_x = 1 * pow(10, 8);

        router::stake_tokens_in_pool<TestCAKE, TestBUSD>(alice, 5 * pow(10, 8));
        router::stake_tokens_in_pool<TestBUSD, TestCAKE>(bob, 5 * pow(10, 8));

        let (staked_tokens, balance_x, balance_y, magnified_dividends_per_share_x, magnified_dividends_per_share_y, precision_factor, is_x_staked) = swap::token_rewards_pool_info<TestBUSD, TestCAKE>();

        assert!(staked_tokens == 10 * pow(10, 8), 130);

        router::swap_exact_input<TestCAKE, TestBUSD>(alice, input_x, 0);
        router::swap_exact_input<TestBUSD, TestCAKE>(alice, input_x, 0);

        let (treasury_balance_x, treasury_balance_y, team_balance_x, team_balance_y, pool_balance_x, pool_balance_y) = swap::token_fees_accumulated<TestBUSD, TestCAKE>();

        assert!(treasury_balance_y == 1 * pow(10, 5), 125);
        assert!(pool_balance_y == 2 * pow(10, 6), 126);
        assert!(pool_balance_x == 2 * pow(10, 6), 126);

        let (staked_tokens, balance_x, balance_y, magnified_dividends_per_share_x, magnified_dividends_per_share_y, precision_factor, is_x_staked) = swap::token_rewards_pool_info<TestBUSD, TestCAKE>();

        assert!(precision_factor == (1 * pow(10, 12) as u128), 127);
        assert!(!is_x_staked, 128);
        assert!(balance_y == 2 * pow(10, 6), 131);
        assert!(magnified_dividends_per_share_y > 0, 132);
        assert!(magnified_dividends_per_share_x == magnified_dividends_per_share_y, 133);

        router::withdraw_tokens_from_pool<TestBUSD, TestCAKE>(alice, 3 * pow(10, 8));
        router::claim_rewards_from_pool<TestCAKE, TestBUSD>(bob);

        router::stake_tokens_in_pool<TestBUSD, TestCAKE>(bob, 1 * pow(10, 8));

        let (staked_tokens, balance_x, balance_y, magnified_dividends_per_share_x, magnified_dividends_per_share_y, precision_factor, is_x_staked) = swap::token_rewards_pool_info<TestBUSD, TestCAKE>();

        assert!(balance_y == 0 * pow(10, 6), 134);
        assert!(balance_x == 0 * pow(10, 6), 135);
        assert!(staked_tokens == 8 * pow(10, 8), 136);

        router::swap_exact_input<TestBUSD, TestCAKE>(alice, input_x, 0);

        let (staked_tokens, balance_x, balance_y, magnified_dividends_per_share_x, magnified_dividends_per_share_y, precision_factor, is_x_staked) = swap::token_rewards_pool_info<TestBUSD, TestCAKE>();

        assert!(balance_x == 2 * pow(10, 6), 134);

        router::claim_rewards_from_pool<TestCAKE, TestBUSD>(alice);

        let (staked_tokens, balance_x, balance_y, magnified_dividends_per_share_x, magnified_dividends_per_share_y, precision_factor, is_x_staked) = swap::token_rewards_pool_info<TestBUSD, TestCAKE>();

        assert!(balance_x == 15 * pow(10, 5), 135);

        router::withdraw_tokens_from_pool<TestCAKE, TestBUSD>(bob, 6 * pow(10, 8));

        let (staked_tokens, balance_x, balance_y, magnified_dividends_per_share_x, magnified_dividends_per_share_y, precision_factor, is_x_staked) = swap::token_rewards_pool_info<TestBUSD, TestCAKE>();

        assert!(staked_tokens == 2 * pow(10, 8), 136);

    }
    

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    fun test_add_liquidity(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, alice, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, alice, 100 * pow(10, 8));

        let bob_liquidity_x = 5 * pow(10, 8);
        let bob_liquidity_y = 10 * pow(10, 8);
        let alice_liquidity_x = 2 * pow(10, 8);
        let alice_liquidity_y = 4 * pow(10, 8);

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, bob_liquidity_x, bob_liquidity_y, 0, 0);
        router::add_liquidity<TestCAKE, TestBUSD>(alice, alice_liquidity_x, alice_liquidity_y, 0, 0);

        let (balance_y, balance_x) = swap::token_balances<TestBUSD, TestCAKE>();
        let (reserve_y, reserve_x, _) = swap::token_reserves<TestBUSD, TestCAKE>();
        let resource_account_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(resource_account));
        let bob_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(bob));
        let alice_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(alice));

        let resource_account_suppose_lp_balance = MINIMUM_LIQUIDITY;
        let bob_suppose_lp_balance = math::sqrt(((bob_liquidity_x as u128) * (bob_liquidity_y as u128))) - MINIMUM_LIQUIDITY;
        let total_supply = bob_suppose_lp_balance + MINIMUM_LIQUIDITY;
        let alice_suppose_lp_balance = math::min((alice_liquidity_x as u128) * total_supply / (bob_liquidity_x as u128), (alice_liquidity_y as u128) * total_supply / (bob_liquidity_y as u128));

        assert!(balance_x == bob_liquidity_x + alice_liquidity_x, 99);
        assert!(reserve_x == bob_liquidity_x + alice_liquidity_x, 98);
        assert!(balance_y == bob_liquidity_y + alice_liquidity_y, 97);
        assert!(reserve_y == bob_liquidity_y + alice_liquidity_y, 96);

        assert!(bob_lp_balance == (bob_suppose_lp_balance as u64), 95);
        assert!(alice_lp_balance == (alice_suppose_lp_balance as u64), 94);
        assert!(resource_account_lp_balance == (resource_account_suppose_lp_balance as u64), 93);
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    fun test_add_liquidity_with_less_x_ratio(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 200 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 200 * pow(10, 8));

        let bob_liquidity_x = 5 * pow(10, 8);
        let bob_liquidity_y = 10 * pow(10, 8);

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, bob_liquidity_x, bob_liquidity_y, 0, 0);

        let bob_token_x_before_balance = coin::balance<TestCAKE>(signer::address_of(bob));
        let bob_token_y_before_balance = coin::balance<TestBUSD>(signer::address_of(bob));

        let bob_add_liquidity_x = 1 * pow(10, 8);
        let bob_add_liquidity_y = 5 * pow(10, 8);
        router::add_liquidity<TestCAKE, TestBUSD>(bob, bob_add_liquidity_x, bob_add_liquidity_y, 0, 0);

        let bob_added_liquidity_x = bob_add_liquidity_x;
        let bob_added_liquidity_y = (bob_add_liquidity_x as u128) * (bob_liquidity_y as u128) / (bob_liquidity_x as u128);

        let bob_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(bob));
        let bob_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(bob));
        let bob_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(bob));
        let resource_account_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(resource_account));

        let resource_account_suppose_lp_balance = MINIMUM_LIQUIDITY;
        let bob_suppose_lp_balance = math::sqrt(((bob_liquidity_x as u128) * (bob_liquidity_y as u128))) - MINIMUM_LIQUIDITY;
        let total_supply = bob_suppose_lp_balance + MINIMUM_LIQUIDITY;
        bob_suppose_lp_balance = bob_suppose_lp_balance + math::min((bob_add_liquidity_x as u128) * total_supply / (bob_liquidity_x as u128), (bob_add_liquidity_y as u128) * total_supply / (bob_liquidity_y as u128));

        assert!((bob_token_x_before_balance - bob_token_x_after_balance) == (bob_added_liquidity_x as u64), 99);
        assert!((bob_token_y_before_balance - bob_token_y_after_balance) == (bob_added_liquidity_y as u64), 98);
        assert!(bob_lp_balance == (bob_suppose_lp_balance as u64), 97);
        assert!(resource_account_lp_balance == (resource_account_suppose_lp_balance as u64), 96);
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    #[expected_failure(abort_code = 3)]
    fun test_add_liquidity_with_less_x_ratio_and_less_than_y_min(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 200 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 200 * pow(10, 8));

        let initial_reserve_x = 5 * pow(10, 8);
        let initial_reserve_y = 10 * pow(10, 8);

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, initial_reserve_x, initial_reserve_y, 0, 0);

        let bob_add_liquidity_x = 1 * pow(10, 8);
        let bob_add_liquidity_y = 5 * pow(10, 8);
        router::add_liquidity<TestCAKE, TestBUSD>(bob, bob_add_liquidity_x, bob_add_liquidity_y, 0, 4 * pow(10, 8));
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    fun test_add_liquidity_with_less_y_ratio(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 200 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 200 * pow(10, 8));

        let bob_liquidity_x = 5 * pow(10, 8);
        let bob_liquidity_y = 10 * pow(10, 8);

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, bob_liquidity_x, bob_liquidity_y, 0, 0);

        let bob_token_x_before_balance = coin::balance<TestCAKE>(signer::address_of(bob));
        let bob_token_y_before_balance = coin::balance<TestBUSD>(signer::address_of(bob));

        let bob_add_liquidity_x = 5 * pow(10, 8);
        let bob_add_liquidity_y = 4 * pow(10, 8);
        router::add_liquidity<TestCAKE, TestBUSD>(bob, bob_add_liquidity_x, bob_add_liquidity_y, 0, 0);

        let bob_added_liquidity_x = (bob_add_liquidity_y as u128) * (bob_liquidity_x as u128) / (bob_liquidity_y as u128);
        let bob_added_liquidity_y = bob_add_liquidity_y;

        let bob_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(bob));
        let bob_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(bob));
        let bob_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(bob));
        let resource_account_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(resource_account));

        let resource_account_suppose_lp_balance = MINIMUM_LIQUIDITY;
        let bob_suppose_lp_balance = math::sqrt(((bob_liquidity_x as u128) * (bob_liquidity_y as u128))) - MINIMUM_LIQUIDITY;
        let total_supply = bob_suppose_lp_balance + MINIMUM_LIQUIDITY;
        bob_suppose_lp_balance = bob_suppose_lp_balance + math::min((bob_add_liquidity_x as u128) * total_supply / (bob_liquidity_x as u128), (bob_add_liquidity_y as u128) * total_supply / (bob_liquidity_y as u128));


        assert!((bob_token_x_before_balance - bob_token_x_after_balance) == (bob_added_liquidity_x as u64), 99);
        assert!((bob_token_y_before_balance - bob_token_y_after_balance) == (bob_added_liquidity_y as u64), 98);
        assert!(bob_lp_balance == (bob_suppose_lp_balance as u64), 97);
        assert!(resource_account_lp_balance == (resource_account_suppose_lp_balance as u64), 96);
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    #[expected_failure(abort_code = 2)]
    fun test_add_liquidity_with_less_y_ratio_and_less_than_x_min(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 200 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 200 * pow(10, 8));

        let initial_reserve_x = 5 * pow(10, 8);
        let initial_reserve_y = 10 * pow(10, 8);

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, initial_reserve_x, initial_reserve_y, 0, 0);

        let bob_add_liquidity_x = 5 * pow(10, 8);
        let bob_add_liquidity_y = 4 * pow(10, 8);
        router::add_liquidity<TestCAKE, TestBUSD>(bob, bob_add_liquidity_x, bob_add_liquidity_y, 5 * pow(10, 8), 0);
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12341, alice = @0x12342)]
    fun test_remove_liquidity(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));
        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, alice, 100 * pow(10, 8));

        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, alice, 100 * pow(10, 8));

        let bob_add_liquidity_x = 5 * pow(10, 8);
        let bob_add_liquidity_y = 10 * pow(10, 8);

        let alice_add_liquidity_x = 2 * pow(10, 8);
        let alice_add_liquidity_y = 4 * pow(10, 8);

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, bob_add_liquidity_x, bob_add_liquidity_y, 0, 0);
        router::add_liquidity<TestCAKE, TestBUSD>(alice, alice_add_liquidity_x, alice_add_liquidity_y, 0, 0);

        let bob_suppose_lp_balance = math::sqrt(((bob_add_liquidity_x as u128) * (bob_add_liquidity_y as u128))) - MINIMUM_LIQUIDITY;
        let suppose_total_supply = bob_suppose_lp_balance + MINIMUM_LIQUIDITY;
        let alice_suppose_lp_balance = math::min((alice_add_liquidity_x as u128) * suppose_total_supply / (bob_add_liquidity_x as u128), (alice_add_liquidity_y as u128) * suppose_total_supply / (bob_add_liquidity_y as u128));
        suppose_total_supply = suppose_total_supply + alice_suppose_lp_balance;
        let suppose_reserve_x = bob_add_liquidity_x + alice_add_liquidity_x;
        let suppose_reserve_y = bob_add_liquidity_y + alice_add_liquidity_y;

        let bob_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(bob));
        let alice_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(alice));

        assert!((bob_suppose_lp_balance as u64) == bob_lp_balance, 99);
        assert!((alice_suppose_lp_balance as u64) == alice_lp_balance, 98);

        let alice_token_x_before_balance = coin::balance<TestCAKE>(signer::address_of(alice));
        let alice_token_y_before_balance = coin::balance<TestBUSD>(signer::address_of(alice));
        let bob_token_x_before_balance = coin::balance<TestCAKE>(signer::address_of(bob));
        let bob_token_y_before_balance = coin::balance<TestBUSD>(signer::address_of(bob));

        router::remove_liquidity<TestCAKE, TestBUSD>(bob, (bob_suppose_lp_balance as u64), 0, 0);
        let bob_remove_liquidity_x = ((suppose_reserve_x) as u128) * bob_suppose_lp_balance / suppose_total_supply;
        let bob_remove_liquidity_y = ((suppose_reserve_y) as u128) * bob_suppose_lp_balance / suppose_total_supply;
        suppose_total_supply = suppose_total_supply - bob_suppose_lp_balance;
        suppose_reserve_x = suppose_reserve_x - (bob_remove_liquidity_x as u64);
        suppose_reserve_y = suppose_reserve_y - (bob_remove_liquidity_y as u64);

        router::remove_liquidity<TestCAKE, TestBUSD>(alice, (alice_suppose_lp_balance as u64), 0, 0);
        let alice_remove_liquidity_x = ((suppose_reserve_x) as u128) * alice_suppose_lp_balance / suppose_total_supply;
        let alice_remove_liquidity_y = ((suppose_reserve_y) as u128) * alice_suppose_lp_balance / suppose_total_supply;
        suppose_reserve_x = suppose_reserve_x - (alice_remove_liquidity_x as u64);
        suppose_reserve_y = suppose_reserve_y - (alice_remove_liquidity_y as u64);

        let alice_lp_after_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(alice));
        let bob_lp_after_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(bob));
        let alice_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(alice));
        let alice_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(alice));
        let bob_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(bob));
        let bob_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(bob));
        let (balance_y, balance_x) = swap::token_balances<TestBUSD, TestCAKE>();
        let (reserve_y, reserve_x, _) = swap::token_reserves<TestBUSD, TestCAKE>();
        let total_supply = std::option::get_with_default(
            &coin::supply<LPToken<TestBUSD, TestCAKE>>(),
            0u128
        );

        assert!((alice_token_x_after_balance - alice_token_x_before_balance) == (alice_remove_liquidity_x as u64), 97);
        assert!((alice_token_y_after_balance - alice_token_y_before_balance) == (alice_remove_liquidity_y as u64), 96);
        assert!((bob_token_x_after_balance - bob_token_x_before_balance) == (bob_remove_liquidity_x as u64), 95);
        assert!((bob_token_y_after_balance - bob_token_y_before_balance) == (bob_remove_liquidity_y as u64), 94);
        assert!(alice_lp_after_balance == 0, 93);
        assert!(bob_lp_after_balance == 0, 92);
        assert!(balance_x == suppose_reserve_x, 91);
        assert!(balance_y == suppose_reserve_y, 90);
        assert!(reserve_x == suppose_reserve_x, 89);
        assert!(reserve_y == suppose_reserve_y, 88);
        assert!(total_supply == MINIMUM_LIQUIDITY, 87);
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, user1 = @0x12341, user2 = @0x12342, user3 = @0x12343, user4 = @0x12344)]
    fun test_remove_liquidity_with_more_user(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        user1: &signer,
        user2: &signer,
        user3: &signer,
        user4: &signer,
    ) {
        account::create_account_for_test(signer::address_of(user1));
        account::create_account_for_test(signer::address_of(user2));
        account::create_account_for_test(signer::address_of(user3));
        account::create_account_for_test(signer::address_of(user4));
        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, user1, 100 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, user2, 100 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, user3, 100 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, user4, 100 * pow(10, 8));

        test_coins::register_and_mint<TestBUSD>(&coin_owner, user1, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, user2, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, user3, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, user4, 100 * pow(10, 8));

        let user1_add_liquidity_x = 5 * pow(10, 8);
        let user1_add_liquidity_y = 10 * pow(10, 8);

        let user2_add_liquidity_x = 2 * pow(10, 8);
        let user2_add_liquidity_y = 4 * pow(10, 8);

        let user3_add_liquidity_x = 25 * pow(10, 8);
        let user3_add_liquidity_y = 50 * pow(10, 8);

        let user4_add_liquidity_x = 45 * pow(10, 8);
        let user4_add_liquidity_y = 90 * pow(10, 8);

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(user1, user1_add_liquidity_x, user1_add_liquidity_y, 0, 0);
        router::add_liquidity<TestCAKE, TestBUSD>(user2, user2_add_liquidity_x, user2_add_liquidity_y, 0, 0);
        router::add_liquidity<TestCAKE, TestBUSD>(user3, user3_add_liquidity_x, user3_add_liquidity_y, 0, 0);
        router::add_liquidity<TestCAKE, TestBUSD>(user4, user4_add_liquidity_x, user4_add_liquidity_y, 0, 0);

        let user1_suppose_lp_balance = math::sqrt(((user1_add_liquidity_x as u128) * (user1_add_liquidity_y as u128))) - MINIMUM_LIQUIDITY;
        let suppose_total_supply = user1_suppose_lp_balance + MINIMUM_LIQUIDITY;
        let suppose_reserve_x = user1_add_liquidity_x;
        let suppose_reserve_y = user1_add_liquidity_y;
        let user2_suppose_lp_balance = math::min((user2_add_liquidity_x as u128) * suppose_total_supply / (suppose_reserve_x as u128), (user2_add_liquidity_y as u128) * suppose_total_supply / (suppose_reserve_y as u128));
        suppose_total_supply = suppose_total_supply + user2_suppose_lp_balance;
        suppose_reserve_x = suppose_reserve_x + user2_add_liquidity_x;
        suppose_reserve_y = suppose_reserve_y + user2_add_liquidity_y;
        let user3_suppose_lp_balance = math::min((user3_add_liquidity_x as u128) * suppose_total_supply / (suppose_reserve_x as u128), (user3_add_liquidity_y as u128) * suppose_total_supply / (suppose_reserve_y as u128));
        suppose_total_supply = suppose_total_supply + user3_suppose_lp_balance;
        suppose_reserve_x = suppose_reserve_x + user3_add_liquidity_x;
        suppose_reserve_y = suppose_reserve_y + user3_add_liquidity_y;
        let user4_suppose_lp_balance = math::min((user4_add_liquidity_x as u128) * suppose_total_supply / (suppose_reserve_x as u128), (user4_add_liquidity_y as u128) * suppose_total_supply / (suppose_reserve_y as u128));
        suppose_total_supply = suppose_total_supply + user4_suppose_lp_balance;
        suppose_reserve_x = suppose_reserve_x + user4_add_liquidity_x;
        suppose_reserve_y = suppose_reserve_y + user4_add_liquidity_y;

        let user1_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(user1));
        let user2_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(user2));
        let user3_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(user3));
        let user4_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(user4));

        assert!((user1_suppose_lp_balance as u64) == user1_lp_balance, 99);
        assert!((user2_suppose_lp_balance as u64) == user2_lp_balance, 98);
        assert!((user3_suppose_lp_balance as u64) == user3_lp_balance, 97);
        assert!((user4_suppose_lp_balance as u64) == user4_lp_balance, 96);

        let user1_token_x_before_balance = coin::balance<TestCAKE>(signer::address_of(user1));
        let user1_token_y_before_balance = coin::balance<TestBUSD>(signer::address_of(user1));
        let user2_token_x_before_balance = coin::balance<TestCAKE>(signer::address_of(user2));
        let user2_token_y_before_balance = coin::balance<TestBUSD>(signer::address_of(user2));
        let user3_token_x_before_balance = coin::balance<TestCAKE>(signer::address_of(user3));
        let user3_token_y_before_balance = coin::balance<TestBUSD>(signer::address_of(user3));
        let user4_token_x_before_balance = coin::balance<TestCAKE>(signer::address_of(user4));
        let user4_token_y_before_balance = coin::balance<TestBUSD>(signer::address_of(user4));

        router::remove_liquidity<TestCAKE, TestBUSD>(user1, (user1_suppose_lp_balance as u64), 0, 0);
        let user1_remove_liquidity_x = ((suppose_reserve_x) as u128) * user1_suppose_lp_balance / suppose_total_supply;
        let user1_remove_liquidity_y = ((suppose_reserve_y) as u128) * user1_suppose_lp_balance / suppose_total_supply;
        suppose_total_supply = suppose_total_supply - user1_suppose_lp_balance;
        suppose_reserve_x = suppose_reserve_x - (user1_remove_liquidity_x as u64);
        suppose_reserve_y = suppose_reserve_y - (user1_remove_liquidity_y as u64);

        router::remove_liquidity<TestCAKE, TestBUSD>(user2, (user2_suppose_lp_balance as u64), 0, 0);
        let user2_remove_liquidity_x = ((suppose_reserve_x) as u128) * user2_suppose_lp_balance / suppose_total_supply;
        let user2_remove_liquidity_y = ((suppose_reserve_y) as u128) * user2_suppose_lp_balance / suppose_total_supply;
        suppose_total_supply = suppose_total_supply - user2_suppose_lp_balance;
        suppose_reserve_x = suppose_reserve_x - (user2_remove_liquidity_x as u64);
        suppose_reserve_y = suppose_reserve_y - (user2_remove_liquidity_y as u64);

        router::remove_liquidity<TestCAKE, TestBUSD>(user3, (user3_suppose_lp_balance as u64), 0, 0);
        let user3_remove_liquidity_x = ((suppose_reserve_x) as u128) * user3_suppose_lp_balance / suppose_total_supply;
        let user3_remove_liquidity_y = ((suppose_reserve_y) as u128) * user3_suppose_lp_balance / suppose_total_supply;
        suppose_total_supply = suppose_total_supply - user3_suppose_lp_balance;
        suppose_reserve_x = suppose_reserve_x - (user3_remove_liquidity_x as u64);
        suppose_reserve_y = suppose_reserve_y - (user3_remove_liquidity_y as u64);

        router::remove_liquidity<TestCAKE, TestBUSD>(user4, (user4_suppose_lp_balance as u64), 0, 0);
        let user4_remove_liquidity_x = ((suppose_reserve_x) as u128) * user4_suppose_lp_balance / suppose_total_supply;
        let user4_remove_liquidity_y = ((suppose_reserve_y) as u128) * user4_suppose_lp_balance / suppose_total_supply;
        suppose_reserve_x = suppose_reserve_x - (user4_remove_liquidity_x as u64);
        suppose_reserve_y = suppose_reserve_y - (user4_remove_liquidity_y as u64);

        let user1_lp_after_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(user1));
        let user2_lp_after_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(user2));
        let user3_lp_after_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(user3));
        let user4_lp_after_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(user4));

        let user1_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(user1));
        let user1_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(user1));
        let user2_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(user2));
        let user2_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(user2));
        let user3_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(user3));
        let user3_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(user3));
        let user4_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(user4));
        let user4_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(user4));

        let (balance_y, balance_x) = swap::token_balances<TestBUSD, TestCAKE>();
        let (reserve_y, reserve_x, _) = swap::token_reserves<TestBUSD, TestCAKE>();
        let total_supply = swap::total_lp_supply<TestBUSD, TestCAKE>();

        assert!((user1_token_x_after_balance - user1_token_x_before_balance) == (user1_remove_liquidity_x as u64), 95);
        assert!((user1_token_y_after_balance - user1_token_y_before_balance) == (user1_remove_liquidity_y as u64), 94);
        assert!((user2_token_x_after_balance - user2_token_x_before_balance) == (user2_remove_liquidity_x as u64), 93);
        assert!((user2_token_y_after_balance - user2_token_y_before_balance) == (user2_remove_liquidity_y as u64), 92);
        assert!((user3_token_x_after_balance - user3_token_x_before_balance) == (user3_remove_liquidity_x as u64), 91);
        assert!((user3_token_y_after_balance - user3_token_y_before_balance) == (user3_remove_liquidity_y as u64), 90);
        assert!((user4_token_x_after_balance - user4_token_x_before_balance) == (user4_remove_liquidity_x as u64), 89);
        assert!((user4_token_y_after_balance - user4_token_y_before_balance) == (user4_remove_liquidity_y as u64), 88);
        assert!(user1_lp_after_balance == 0, 87);
        assert!(user2_lp_after_balance == 0, 86);
        assert!(user3_lp_after_balance == 0, 85);
        assert!(user4_lp_after_balance == 0, 84);
        assert!(balance_x == suppose_reserve_x, 83);
        assert!(balance_y == suppose_reserve_y, 82);
        assert!(reserve_x == suppose_reserve_x, 81);
        assert!(reserve_y == suppose_reserve_y, 80);
        assert!(total_supply == MINIMUM_LIQUIDITY, 79);
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12341, alice = @0x12342)]
    #[expected_failure(abort_code = 10)]
    fun test_remove_liquidity_imbalance(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));
        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, alice, 100 * pow(10, 8));

        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, alice, 100 * pow(10, 8));

        let bob_liquidity_x = 5 * pow(10, 8);
        let bob_liquidity_y = 10 * pow(10, 8);

        let alice_liquidity_x = 1;
        let alice_liquidity_y = 2;

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, bob_liquidity_x, bob_liquidity_y, 0, 0);
        router::add_liquidity<TestCAKE, TestBUSD>(alice, alice_liquidity_x, alice_liquidity_y, 0, 0);

        let bob_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(bob));
        let alice_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(alice));

        router::remove_liquidity<TestCAKE, TestBUSD>(bob, bob_lp_balance, 0, 0);
        // expect the small amount will result one of the amount to be zero and unable to remove liquidity
        router::remove_liquidity<TestCAKE, TestBUSD>(alice, alice_lp_balance, 0, 0);
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    fun test_swap_exact_input(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, alice, 100 * pow(10, 8));

        let initial_reserve_x = 5 * pow(10, 8);
        let initial_reserve_y = 10 * pow(10, 8);
        let input_x = 2 * pow(10, 8);
        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, initial_reserve_x, initial_reserve_y, 0, 0);
        let bob_suppose_lp_balance = math::sqrt(((initial_reserve_x as u128) * (initial_reserve_y as u128))) - MINIMUM_LIQUIDITY;
        let suppose_total_supply = bob_suppose_lp_balance + MINIMUM_LIQUIDITY;

        // let bob_lp_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(bob));
        let alice_token_x_before_balance = coin::balance<TestCAKE>(signer::address_of(alice));

        router::swap_exact_input<TestCAKE, TestBUSD>(alice, input_x, 0);

        let (treasury_balance_x, treasury_balance_y, team_balance_x, team_balance_y, pool_balance_x, pool_balance_y) = swap::token_fees_accumulated<TestBUSD, TestCAKE>();

        assert!(treasury_balance_y == 2 * pow(10, 5), 125);
        // assert!(team_balance_y == 4 * pow(10, 6), 126);
        // assert!(pool_balance_y == 8 * pow(10, 6), 127);

        let alice_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(alice));
        let alice_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(alice));

        let total_fees = swap::token_fees<TestBUSD, TestCAKE>();

        let amount_x_in_with_fee = input_x - (((input_x as u128) * 10u128 / 10000u128) as u64);

        let output_y = calc_output_using_input(input_x, initial_reserve_x, initial_reserve_y, total_fees);
        let new_reserve_x = initial_reserve_x + amount_x_in_with_fee;
        let new_reserve_y = initial_reserve_y - (output_y as u64);

        let (reserve_y, reserve_x, _) = swap::token_reserves<TestBUSD, TestCAKE>();
        assert!((alice_token_x_before_balance - alice_token_x_after_balance) == input_x, 99);
        assert!(alice_token_y_after_balance == (output_y as u64), 98);
        assert!(reserve_x == new_reserve_x, 97);
        assert!(reserve_y == new_reserve_y, 96);

        let bob_token_x_before_balance = coin::balance<TestCAKE>(signer::address_of(bob));
        let bob_token_y_before_balance = coin::balance<TestBUSD>(signer::address_of(bob));

        router::remove_liquidity<TestCAKE, TestBUSD>(bob, (bob_suppose_lp_balance as u64), 0, 0);

        let bob_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(bob));
        let bob_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(bob));

        // let suppose_k_last = ((initial_reserve_x * initial_reserve_y) as u128);
        // let suppose_k = ((new_reserve_x * new_reserve_y) as u128);
        // let suppose_fee_amount = calc_fee_lp(suppose_total_supply, suppose_k, suppose_k_last);
        // suppose_total_supply = suppose_total_supply + suppose_fee_amount;

        let bob_remove_liquidity_x = ((new_reserve_x) as u128) * bob_suppose_lp_balance / suppose_total_supply;
        let bob_remove_liquidity_y = ((new_reserve_y) as u128) * bob_suppose_lp_balance / suppose_total_supply;
        new_reserve_x = new_reserve_x - (bob_remove_liquidity_x as u64);
        new_reserve_y = new_reserve_y - (bob_remove_liquidity_y as u64);
        suppose_total_supply = suppose_total_supply - bob_suppose_lp_balance;

        assert!((bob_token_x_after_balance - bob_token_x_before_balance) == (bob_remove_liquidity_x as u64), 95);
        assert!((bob_token_y_after_balance - bob_token_y_before_balance) == (bob_remove_liquidity_y as u64), 94);

        // swap::withdraw_fee<TestCAKE, TestBUSD>(treasury);
        // let treasury_lp_after_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(treasury));
        // router::remove_liquidity<TestCAKE, TestBUSD>(treasury, (suppose_fee_amount as u64), 0, 0);
        // let treasury_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(treasury));
        // let treasury_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(treasury));

        // let treasury_remove_liquidity_x = ((new_reserve_x) as u128) * suppose_fee_amount / suppose_total_supply;
        // let treasury_remove_liquidity_y = ((new_reserve_y) as u128) * suppose_fee_amount / suppose_total_supply;

        // assert!(treasury_lp_after_balance == (suppose_fee_amount as u64), 93);
        // assert!(treasury_token_x_after_balance == (treasury_remove_liquidity_x as u64), 92);
        // assert!(treasury_token_y_after_balance == (treasury_remove_liquidity_y as u64), 91);
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    fun test_swap_exact_input_overflow(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, MAX_U64);
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, MAX_U64);
        test_coins::register_and_mint<TestCAKE>(&coin_owner, alice, MAX_U64);

        let initial_reserve_x = MAX_U64 / pow(10, 4);
        let initial_reserve_y = MAX_U64 / pow(10, 4);
        let input_x = pow(10, 9) * pow(10, 8);
        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, initial_reserve_x, initial_reserve_y, 0, 0);

        router::swap_exact_input<TestCAKE, TestBUSD>(alice, input_x, 0);
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    #[expected_failure(abort_code = 65542)]
    fun test_swap_exact_input_with_not_enough_liquidity(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 1000 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 1000 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, alice, 1000 * pow(10, 8));

        let initial_reserve_x = 100 * pow(10, 8);
        let initial_reserve_y = 200 * pow(10, 8);
        let input_x = 10000 * pow(10, 8);
        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, initial_reserve_x, initial_reserve_y, 0, 0);


        router::swap_exact_input<TestCAKE, TestBUSD>(alice, input_x, 0);
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    #[expected_failure(abort_code = 0)]
    fun test_swap_exact_input_under_min_output(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, alice, 100 * pow(10, 8));

        let initial_reserve_x = 5 * pow(10, 8);
        let initial_reserve_y = 10 * pow(10, 8);
        let input_x = 2 * pow(10, 8);
        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, initial_reserve_x, initial_reserve_y, 0, 0);

        let total_fees = swap::token_fees<TestBUSD, TestCAKE>();

        let output_y = calc_output_using_input(input_x, initial_reserve_x, initial_reserve_y, total_fees);
        router::swap_exact_input<TestCAKE, TestBUSD>(alice, input_x, ((output_y + 1) as u64));
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    fun test_swap_exact_output(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, alice, 100 * pow(10, 8));

        let initial_reserve_x = 5 * pow(10, 8);
        let initial_reserve_y = 10 * pow(10, 8);
        let output_y = 166319299;
        let input_x_max = 15 * pow(10, 7);

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, initial_reserve_x, initial_reserve_y, 0, 0);
        let bob_suppose_lp_balance = math::sqrt(((initial_reserve_x as u128) * (initial_reserve_y as u128))) - MINIMUM_LIQUIDITY;
        let suppose_total_supply = bob_suppose_lp_balance + MINIMUM_LIQUIDITY;

        let alice_token_x_before_balance = coin::balance<TestCAKE>(signer::address_of(alice));

        router::swap_exact_output<TestCAKE, TestBUSD>(alice, output_y, input_x_max);

        let (treasury_balance_x, treasury_balance_y, team_balance_x, team_balance_y, pool_balance_x, pool_balance_y) = swap::token_fees_accumulated<TestBUSD, TestCAKE>();

        assert!(treasury_balance_y > 0, 125);
        // assert!(team_balance_x == 4 * pow(10, 6), 126);
        // assert!(pool_balance_x == 8 * pow(10, 6), 127);

        let alice_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(alice));
        let alice_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(alice));

        let total_fees = swap::token_fees<TestBUSD, TestCAKE>();

        let input_x = calc_input_using_output(output_y, initial_reserve_x, initial_reserve_y, total_fees);

        let amount_x_in_with_fee = input_x - (((input_x as u128) * 610u128 / 10000u128));

        let new_reserve_x = initial_reserve_x + (amount_x_in_with_fee as u64);
        let new_reserve_y = initial_reserve_y - output_y;

        let (reserve_y, reserve_x, _) = swap::token_reserves<TestBUSD, TestCAKE>();
        assert!((alice_token_x_before_balance - alice_token_x_after_balance) == (input_x as u64), 99);
        assert!(alice_token_y_after_balance == output_y, 98);
        assert!(reserve_x * reserve_y >= new_reserve_x * new_reserve_y, 97);
        // assert!(reserve_y == new_reserve_y, 96);

        let bob_token_x_before_balance = coin::balance<TestCAKE>(signer::address_of(bob));
        let bob_token_y_before_balance = coin::balance<TestBUSD>(signer::address_of(bob));

        router::remove_liquidity<TestCAKE, TestBUSD>(bob, (bob_suppose_lp_balance as u64), 0, 0);

        let bob_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(bob));
        let bob_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(bob));

        // let suppose_k_last = ((initial_reserve_x * initial_reserve_y) as u128);
        // let suppose_k = ((new_reserve_x * new_reserve_y) as u128);
        // let suppose_fee_amount = calc_fee_lp(suppose_total_supply, suppose_k, suppose_k_last);
        // suppose_total_supply = suppose_total_supply + suppose_fee_amount;

        let bob_remove_liquidity_x = ((new_reserve_x) as u128) * bob_suppose_lp_balance / suppose_total_supply;
        let bob_remove_liquidity_y = ((new_reserve_y) as u128) * bob_suppose_lp_balance / suppose_total_supply;
        new_reserve_x = new_reserve_x - (bob_remove_liquidity_x as u64);
        new_reserve_y = new_reserve_y - (bob_remove_liquidity_y as u64);
        suppose_total_supply = suppose_total_supply - bob_suppose_lp_balance;

        // assert!((bob_token_x_after_balance - bob_token_x_before_balance) == (bob_remove_liquidity_x as u64), 95);
        // assert!((bob_token_y_after_balance - bob_token_y_before_balance) == (bob_remove_liquidity_y as u64), 94);

        // swap::withdraw_fee<TestCAKE, TestBUSD>(treasury);
        // let treasury_lp_after_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(treasury));
        // router::remove_liquidity<TestCAKE, TestBUSD>(treasury, (suppose_fee_amount as u64), 0, 0);
        // let treasury_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(treasury));
        // let treasury_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(treasury));

        // let treasury_remove_liquidity_x = ((new_reserve_x) as u128) * suppose_fee_amount / suppose_total_supply;
        // let treasury_remove_liquidity_y = ((new_reserve_y) as u128) * suppose_fee_amount / suppose_total_supply;

        // assert!(treasury_lp_after_balance == (suppose_fee_amount as u64), 93);
        // assert!(treasury_token_x_after_balance == (treasury_remove_liquidity_x as u64), 92);
        // assert!(treasury_token_y_after_balance == (treasury_remove_liquidity_y as u64), 91);
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    #[expected_failure]
    fun test_swap_exact_output_with_not_enough_liquidity(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 1000 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 1000 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, alice, 1000 * pow(10, 8));

        let initial_reserve_x = 100 * pow(10, 8);
        let initial_reserve_y = 200 * pow(10, 8);
        let output_y = 1000 * pow(10, 8);
        let input_x_max = 1000 * pow(10, 8);

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, initial_reserve_x, initial_reserve_y, 0, 0);

        router::swap_exact_output<TestCAKE, TestBUSD>(alice, output_y, input_x_max);
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    #[expected_failure(abort_code = 1)]
    fun test_swap_exact_output_excceed_max_input(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 1000 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 1000 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, alice, 1000 * pow(10, 8));

        let initial_reserve_x = 50 * pow(10, 8);
        let initial_reserve_y = 100 * pow(10, 8);
        let output_y = 166319299;

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, initial_reserve_x, initial_reserve_y, 0, 0);

        let total_fees = swap::token_fees<TestBUSD, TestCAKE>();

        let input_x = calc_input_using_output(output_y, initial_reserve_x, initial_reserve_y, total_fees);
        router::swap_exact_output<TestCAKE, TestBUSD>(alice, output_y, ((input_x - 1) as u64));
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    fun test_swap_x_to_exact_y_direct_external(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, alice, 100 * pow(10, 8));

        let initial_reserve_x = 5 * pow(10, 8);
        let initial_reserve_y = 10 * pow(10, 8);
        let output_y = 166319299;
        // let input_x_max = 1 * pow(10, 8);

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, initial_reserve_x, initial_reserve_y, 0, 0);
        let bob_suppose_lp_balance = math::sqrt(((initial_reserve_x as u128) * (initial_reserve_y as u128))) - MINIMUM_LIQUIDITY;
        let suppose_total_supply = bob_suppose_lp_balance + MINIMUM_LIQUIDITY;

        let alice_addr = signer::address_of(alice);

        let alice_token_x_before_balance = coin::balance<TestCAKE>(alice_addr);

        let total_fees = swap::token_fees<TestBUSD, TestCAKE>();

        let input_x = calc_input_using_output(output_y, initial_reserve_x, initial_reserve_y, total_fees); 

        let x_in_amount = router::get_amount_in<TestCAKE, TestBUSD>(output_y);
        assert!(x_in_amount == (input_x as u64), 102);

        let input_x_coin = coin::withdraw(alice, (input_x as u64));

        let (x_out, y_out) =  router::swap_x_to_exact_y_direct_external<TestCAKE, TestBUSD>(input_x_coin, output_y);

        assert!(coin::value(&x_out) == 0, 101);
        assert!(coin::value(&y_out) == output_y, 100);
        coin::register<TestBUSD>(alice);
        coin::deposit<TestCAKE>(alice_addr, x_out);
        coin::deposit<TestBUSD>(alice_addr, y_out);

        let alice_token_x_after_balance = coin::balance<TestCAKE>(alice_addr);
        let alice_token_y_after_balance = coin::balance<TestBUSD>(alice_addr);

        let new_reserve_x = initial_reserve_x + (input_x as u64);
        let new_reserve_y = initial_reserve_y - output_y;

        let (reserve_y, reserve_x, _) = swap::token_reserves<TestBUSD, TestCAKE>();
        assert!((alice_token_x_before_balance - alice_token_x_after_balance) == (input_x as u64), 99);
        assert!(alice_token_y_after_balance == output_y, 98);
        // assert!(reserve_x * reserve_y >= new_reserve_x * new_reserve_y, 97);

        let bob_token_x_before_balance = coin::balance<TestCAKE>(signer::address_of(bob));
        let bob_token_y_before_balance = coin::balance<TestBUSD>(signer::address_of(bob));

        router::remove_liquidity<TestCAKE, TestBUSD>(bob, (bob_suppose_lp_balance as u64), 0, 0);

        let bob_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(bob));
        let bob_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(bob));

        // let suppose_k_last = ((initial_reserve_x * initial_reserve_y) as u128);
        // let suppose_k = ((new_reserve_x * new_reserve_y) as u128);
        // let suppose_fee_amount = calc_fee_lp(suppose_total_supply, suppose_k, suppose_k_last);
        // suppose_total_supply = suppose_total_supply + suppose_fee_amount;

        let bob_remove_liquidity_x = ((new_reserve_x) as u128) * bob_suppose_lp_balance / suppose_total_supply;
        let bob_remove_liquidity_y = ((new_reserve_y) as u128) * bob_suppose_lp_balance / suppose_total_supply;
        new_reserve_x = new_reserve_x - (bob_remove_liquidity_x as u64);
        new_reserve_y = new_reserve_y - (bob_remove_liquidity_y as u64);
        suppose_total_supply = suppose_total_supply - bob_suppose_lp_balance;

        // assert!((bob_token_x_after_balance - bob_token_x_before_balance) == (bob_remove_liquidity_x as u64), 95);
        // assert!((bob_token_y_after_balance - bob_token_y_before_balance) == (bob_remove_liquidity_y as u64), 94);

        // swap::withdraw_fee<TestCAKE, TestBUSD>(treasury);
        // let treasury_lp_after_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(treasury));
        // router::remove_liquidity<TestCAKE, TestBUSD>(treasury, (suppose_fee_amount as u64), 0, 0);
        // let treasury_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(treasury));
        // let treasury_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(treasury));

        // let treasury_remove_liquidity_x = ((new_reserve_x) as u128) * suppose_fee_amount / suppose_total_supply;
        // let treasury_remove_liquidity_y = ((new_reserve_y) as u128) * suppose_fee_amount / suppose_total_supply;

        // assert!(treasury_lp_after_balance == (suppose_fee_amount as u64), 93);
        // assert!(treasury_token_x_after_balance == (treasury_remove_liquidity_x as u64), 92);
        // assert!(treasury_token_y_after_balance == (treasury_remove_liquidity_y as u64), 91);
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    fun test_swap_x_to_exact_y_direct_external_with_more_x_in(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, alice, 100 * pow(10, 8));

        let initial_reserve_x = 5 * pow(10, 8);
        let initial_reserve_y = 10 * pow(10, 8);
        let output_y = 166319299;
        // let input_x_max = 1 * pow(10, 8);

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, initial_reserve_x, initial_reserve_y, 0, 0);
        let bob_suppose_lp_balance = math::sqrt(((initial_reserve_x as u128) * (initial_reserve_y as u128))) - MINIMUM_LIQUIDITY;
        let suppose_total_supply = bob_suppose_lp_balance + MINIMUM_LIQUIDITY;

        let alice_addr = signer::address_of(alice);

        let alice_token_x_before_balance = coin::balance<TestCAKE>(alice_addr);

        let total_fees = swap::token_fees<TestBUSD, TestCAKE>();

        let input_x = calc_input_using_output(output_y, initial_reserve_x, initial_reserve_y, total_fees); 

        let x_in_more = 666666;

        let input_x_coin = coin::withdraw(alice, (input_x as u64) + x_in_more);

        let (x_out, y_out) =  router::swap_x_to_exact_y_direct_external<TestCAKE, TestBUSD>(input_x_coin, output_y);

        assert!(coin::value(&x_out) == x_in_more, 101);
        assert!(coin::value(&y_out) == output_y, 100);
        coin::register<TestBUSD>(alice);
        coin::deposit<TestCAKE>(alice_addr, x_out);
        coin::deposit<TestBUSD>(alice_addr, y_out);

        let alice_token_x_after_balance = coin::balance<TestCAKE>(alice_addr);
        let alice_token_y_after_balance = coin::balance<TestBUSD>(alice_addr);

        let new_reserve_x = initial_reserve_x + (input_x as u64);
        let new_reserve_y = initial_reserve_y - output_y;

        let (reserve_y, reserve_x, _) = swap::token_reserves<TestBUSD, TestCAKE>();
        assert!((alice_token_x_before_balance - alice_token_x_after_balance) == (input_x as u64), 99);
        assert!(alice_token_y_after_balance == output_y, 98);
        // assert!(reserve_x * reserve_y >= new_reserve_x * new_reserve_y, 97);

        let bob_token_x_before_balance = coin::balance<TestCAKE>(signer::address_of(bob));
        let bob_token_y_before_balance = coin::balance<TestBUSD>(signer::address_of(bob));

        router::remove_liquidity<TestCAKE, TestBUSD>(bob, (bob_suppose_lp_balance as u64), 0, 0);

        let bob_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(bob));
        let bob_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(bob));

        // let suppose_k_last = ((initial_reserve_x * initial_reserve_y) as u128);
        // let suppose_k = ((new_reserve_x * new_reserve_y) as u128);
        // let suppose_fee_amount = calc_fee_lp(suppose_total_supply, suppose_k, suppose_k_last);
        // suppose_total_supply = suppose_total_supply + suppose_fee_amount;

        let bob_remove_liquidity_x = ((new_reserve_x) as u128) * bob_suppose_lp_balance / suppose_total_supply;
        let bob_remove_liquidity_y = ((new_reserve_y) as u128) * bob_suppose_lp_balance / suppose_total_supply;
        new_reserve_x = new_reserve_x - (bob_remove_liquidity_x as u64);
        new_reserve_y = new_reserve_y - (bob_remove_liquidity_y as u64);
        suppose_total_supply = suppose_total_supply - bob_suppose_lp_balance;

        // assert!((bob_token_x_after_balance - bob_token_x_before_balance) == (bob_remove_liquidity_x as u64), 95);
        // assert!((bob_token_y_after_balance - bob_token_y_before_balance) == (bob_remove_liquidity_y as u64), 94);

        // swap::withdraw_fee<TestCAKE, TestBUSD>(treasury);
        // let treasury_lp_after_balance = coin::balance<LPToken<TestBUSD, TestCAKE>>(signer::address_of(treasury));
        // router::remove_liquidity<TestCAKE, TestBUSD>(treasury, (suppose_fee_amount as u64), 0, 0);
        // let treasury_token_x_after_balance = coin::balance<TestCAKE>(signer::address_of(treasury));
        // let treasury_token_y_after_balance = coin::balance<TestBUSD>(signer::address_of(treasury));

        // let treasury_remove_liquidity_x = ((new_reserve_x) as u128) * suppose_fee_amount / suppose_total_supply;
        // let treasury_remove_liquidity_y = ((new_reserve_y) as u128) * suppose_fee_amount / suppose_total_supply;

        // assert!(treasury_lp_after_balance == (suppose_fee_amount as u64), 93);
        // assert!(treasury_token_x_after_balance == (treasury_remove_liquidity_x as u64), 92);
        // assert!(treasury_token_y_after_balance == (treasury_remove_liquidity_y as u64), 91);
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    #[expected_failure(abort_code = 2)]
    fun test_swap_x_to_exact_y_direct_external_with_less_x_in(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, alice, 100 * pow(10, 8));

        let initial_reserve_x = 5 * pow(10, 8);
        let initial_reserve_y = 10 * pow(10, 8);
        let output_y = 166319299;
        // let input_x_max = 1 * pow(10, 8);

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, initial_reserve_x, initial_reserve_y, 0, 0);

        let alice_addr = signer::address_of(alice);

        let total_fees = swap::token_fees<TestBUSD, TestCAKE>();

        let input_x = calc_input_using_output(output_y, initial_reserve_x, initial_reserve_y, total_fees); 

        let x_in_less = 66;

        let input_x_coin = coin::withdraw(alice, (input_x as u64) - x_in_less);

        let (x_out, y_out) =  router::swap_x_to_exact_y_direct_external<TestCAKE, TestBUSD>(input_x_coin, output_y);

        coin::register<TestBUSD>(alice);
        coin::deposit<TestCAKE>(alice_addr, x_out);
        coin::deposit<TestBUSD>(alice_addr, y_out);
    }

    #[test(dev = @dev, admin = @default_admin, resource_account = @baptswap, treasury = @0x23456, bob = @0x12345, alice = @0x12346)]
    fun test_get_amount_in(
        dev: &signer,
        admin: &signer,
        resource_account: &signer,
        treasury: &signer,
        bob: &signer,
        alice: &signer,
    ) {
        account::create_account_for_test(signer::address_of(bob));
        account::create_account_for_test(signer::address_of(alice));

        setup_test_with_genesis(dev, admin, treasury, resource_account);

        let coin_owner = test_coins::init_coins();

        test_coins::register_and_mint<TestCAKE>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestBUSD>(&coin_owner, bob, 100 * pow(10, 8));
        test_coins::register_and_mint<TestCAKE>(&coin_owner, alice, 100 * pow(10, 8));

        let initial_reserve_x = 5 * pow(10, 8);
        let initial_reserve_y = 10 * pow(10, 8);
        let output_y = 166319299;
        let output_x = 166319299;
        // let input_x_max = 1 * pow(10, 8);

        // bob provider liquidity for 5:10 CAKE-BUSD
        router::add_liquidity<TestCAKE, TestBUSD>(bob, initial_reserve_x, initial_reserve_y, 0, 0);

        let total_fees = swap::token_fees<TestBUSD, TestCAKE>();

        let input_x = calc_input_using_output(output_y, initial_reserve_x, initial_reserve_y, total_fees); 

        let x_in_amount = router::get_amount_in<TestCAKE, TestBUSD>(output_y);
        assert!(x_in_amount == (input_x as u64), 102);

        let input_y = calc_input_using_output(output_x, initial_reserve_y, initial_reserve_x, total_fees); 

        let y_in_amount = router::get_amount_in<TestBUSD, TestCAKE>(output_x);
        assert!(y_in_amount == (input_y as u64), 101);
    }


    public fun get_token_reserves<X, Y>(): (u64, u64) {

        let is_x_to_y = swap_utils::sort_token_type<X, Y>();
        let reserve_x;
        let reserve_y;
        if(is_x_to_y){
            (reserve_x, reserve_y, _) = swap::token_reserves<X, Y>();
        }else{
            (reserve_y, reserve_x, _) = swap::token_reserves<Y, X>();
        };
        (reserve_x, reserve_y)

    }

    public fun calc_output_using_input(
        input_x: u64,
        reserve_x: u64,
        reserve_y: u64,
        total_fees: u128
    ): u128 {
        let fee_denominator = 10000u128 - 20u128 - total_fees;

        ((input_x as u128) * fee_denominator * (reserve_y as u128)) / (((reserve_x as u128) * 10000u128) + ((input_x as u128) * fee_denominator))
    }

    public fun calc_input_using_output(
        output_y: u64,
        reserve_x: u64,
        reserve_y: u64,
        total_fees: u128
    ): u128 {
        let fee_denominator = 10000u128 - 20u128 - total_fees;

        ((output_y as u128) * 10000u128 * (reserve_x as u128)) / (fee_denominator * ((reserve_y as u128) - (output_y as u128))) + 1u128
    }

    public fun calc_fee_lp(
        total_lp_supply: u128,
        k: u128,
        k_last: u128,
    ): u128 {
        let root_k = math::sqrt(k);
        let root_k_last = math::sqrt(k_last);

        let numerator = total_lp_supply * (root_k - root_k_last) * 8u128;
        let denominator = root_k_last * 17u128 + (root_k * 8u128);
        let liquidity = numerator / denominator;
        liquidity
    }
}
