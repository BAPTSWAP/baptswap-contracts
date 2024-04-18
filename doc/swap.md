
<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap"></a>

# Module `0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f::swap`

Uniswap v2 like token swap program


-  [Resource `LPToken`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_LPToken)
-  [Resource `TokenPairMetadata`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_TokenPairMetadata)
-  [Resource `TokenPairReserve`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_TokenPairReserve)
-  [Resource `TokenPairRewardsPool`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_TokenPairRewardsPool)
-  [Resource `RewardsPoolUserInfo`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_RewardsPoolUserInfo)
-  [Resource `SwapInfo`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_SwapInfo)
-  [Struct `PairCreatedEvent`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_PairCreatedEvent)
-  [Resource `PairEventHolder`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_PairEventHolder)
-  [Struct `AddLiquidityEvent`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_AddLiquidityEvent)
-  [Struct `RemoveLiquidityEvent`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_RemoveLiquidityEvent)
-  [Struct `SwapEvent`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_SwapEvent)
-  [Struct `FeeChangeEvent`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_FeeChangeEvent)
-  [Constants](#@Constants_0)
-  [Function `init_rewards_pool`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_init_rewards_pool)
-  [Function `stake_tokens`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_stake_tokens)
-  [Function `withdraw_tokens`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_withdraw_tokens)
-  [Function `claim_rewards`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_claim_rewards)
-  [Function `create_pair`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_create_pair)
-  [Function `register_lp`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_register_lp)
-  [Function `is_pair_created`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_is_pair_created)
-  [Function `is_pool_created`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_is_pool_created)
-  [Function `lp_balance`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_lp_balance)
-  [Function `total_lp_supply`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_total_lp_supply)
-  [Function `token_fees`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_token_fees)
-  [Function `token_fees_accumulated`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_token_fees_accumulated)
-  [Function `token_rewards_pool_info`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_token_rewards_pool_info)
-  [Function `token_reserves`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_token_reserves)
-  [Function `token_balances`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_token_balances)
-  [Function `check_or_register_coin_store`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_check_or_register_coin_store)
-  [Function `admin`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_admin)
-  [Function `fee_to`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_fee_to)
-  [Function `add_liquidity`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_add_liquidity)
-  [Function `add_swap_event`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_add_swap_event)
-  [Function `add_swap_event_with_address`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_add_swap_event_with_address)
-  [Function `remove_liquidity`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_remove_liquidity)
-  [Function `swap_exact_x_to_y`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_exact_x_to_y)
-  [Function `swap_exact_x_to_y_direct`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_exact_x_to_y_direct)
-  [Function `swap_x_to_exact_y`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_x_to_exact_y)
-  [Function `swap_x_to_exact_y_direct`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_x_to_exact_y_direct)
-  [Function `swap_exact_y_to_x`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_exact_y_to_x)
-  [Function `swap_y_to_exact_x`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_y_to_exact_x)
-  [Function `swap_y_to_exact_x_direct`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_y_to_exact_x_direct)
-  [Function `swap_exact_y_to_x_direct`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_exact_y_to_x_direct)
-  [Function `set_admin`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_set_admin)
-  [Function `set_fee_to`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_set_fee_to)
-  [Function `set_token_pair_owner`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_set_token_pair_owner)
-  [Function `set_treasury_fee`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_set_treasury_fee)
-  [Function `set_token_fees`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_set_token_fees)
-  [Function `withdraw_team_fee`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_withdraw_team_fee)
-  [Function `withdraw_fee`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_withdraw_fee)
-  [Function `upgrade_swap`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_upgrade_swap)


<pre><code><b>use</b> <a href="">0x1::account</a>;
<b>use</b> <a href="">0x1::code</a>;
<b>use</b> <a href="">0x1::coin</a>;
<b>use</b> <a href="">0x1::event</a>;
<b>use</b> <a href="">0x1::option</a>;
<b>use</b> <a href="">0x1::resource_account</a>;
<b>use</b> <a href="">0x1::signer</a>;
<b>use</b> <a href="">0x1::string</a>;
<b>use</b> <a href="">0x1::timestamp</a>;
<b>use</b> <a href="">0x1::type_info</a>;
<b>use</b> <a href="Math.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_math">0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f::math</a>;
<b>use</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils">0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f::swap_utils</a>;
<b>use</b> <a href="u256.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_u256">0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f::u256</a>;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_LPToken"></a>

## Resource `LPToken`

The LP Token type


<pre><code><b>struct</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_LPToken">LPToken</a>&lt;X, Y&gt; <b>has</b> key
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_TokenPairMetadata"></a>

## Resource `TokenPairMetadata`

Stores the metadata required for the token pairs


<pre><code><b>struct</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_TokenPairMetadata">TokenPairMetadata</a>&lt;X, Y&gt; <b>has</b> key
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_TokenPairReserve"></a>

## Resource `TokenPairReserve`

Stores the reservation info required for the token pairs


<pre><code><b>struct</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_TokenPairReserve">TokenPairReserve</a>&lt;X, Y&gt; <b>has</b> key
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_TokenPairRewardsPool"></a>

## Resource `TokenPairRewardsPool`

Stores the rewards pool info for token pairs


<pre><code><b>struct</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_TokenPairRewardsPool">TokenPairRewardsPool</a>&lt;X, Y&gt; <b>has</b> key
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_RewardsPoolUserInfo"></a>

## Resource `RewardsPoolUserInfo`



<pre><code><b>struct</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_RewardsPoolUserInfo">RewardsPoolUserInfo</a>&lt;X, Y, StakeToken&gt; <b>has</b> store, key
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_SwapInfo"></a>

## Resource `SwapInfo`



<pre><code><b>struct</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_SwapInfo">SwapInfo</a> <b>has</b> key
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_PairCreatedEvent"></a>

## Struct `PairCreatedEvent`



<pre><code><b>struct</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_PairCreatedEvent">PairCreatedEvent</a> <b>has</b> drop, store
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_PairEventHolder"></a>

## Resource `PairEventHolder`



<pre><code><b>struct</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_PairEventHolder">PairEventHolder</a>&lt;X, Y&gt; <b>has</b> key
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_AddLiquidityEvent"></a>

## Struct `AddLiquidityEvent`



<pre><code><b>struct</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_AddLiquidityEvent">AddLiquidityEvent</a>&lt;X, Y&gt; <b>has</b> drop, store
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_RemoveLiquidityEvent"></a>

## Struct `RemoveLiquidityEvent`



<pre><code><b>struct</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_RemoveLiquidityEvent">RemoveLiquidityEvent</a>&lt;X, Y&gt; <b>has</b> drop, store
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_SwapEvent"></a>

## Struct `SwapEvent`



<pre><code><b>struct</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_SwapEvent">SwapEvent</a>&lt;X, Y&gt; <b>has</b> drop, store
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_FeeChangeEvent"></a>

## Struct `FeeChangeEvent`



<pre><code><b>struct</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_FeeChangeEvent">FeeChangeEvent</a>&lt;X, Y&gt; <b>has</b> drop, store
</code></pre>



<a id="@Constants_0"></a>

## Constants


<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_MAX_U128"></a>

Max <code>u128</code> value.


<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_MAX_U128">MAX_U128</a>: u128 = 340282366920938463463374607431768211455;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_MAX_COIN_NAME_LENGTH"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_MAX_COIN_NAME_LENGTH">MAX_COIN_NAME_LENGTH</a>: u64 = 32;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INSUFFICIENT_AMOUNT"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INSUFFICIENT_AMOUNT">ERROR_INSUFFICIENT_AMOUNT</a>: u64 = 6;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INSUFFICIENT_INPUT_AMOUNT"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INSUFFICIENT_INPUT_AMOUNT">ERROR_INSUFFICIENT_INPUT_AMOUNT</a>: u64 = 14;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INSUFFICIENT_LIQUIDITY"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INSUFFICIENT_LIQUIDITY">ERROR_INSUFFICIENT_LIQUIDITY</a>: u64 = 7;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_BASE_LIQUIDITY_FEE"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_BASE_LIQUIDITY_FEE">BASE_LIQUIDITY_FEE</a>: u128 = 20;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_DEFAULT_ADMIN"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_DEFAULT_ADMIN">DEFAULT_ADMIN</a>: <b>address</b> = 0xefb4da60354e5b2f419ee71fb277677a7c1b8cb1a3d4bbf0455d561ebf199eef;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_DEV"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_DEV">DEV</a>: <b>address</b> = 0x4dfbdb89ec2e6f9cf082df0fc8b4b95b0d9b4406a686b8f39bfd39ef1bb030e6;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_ALREADY_INITIALIZED"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_ALREADY_INITIALIZED">ERROR_ALREADY_INITIALIZED</a>: u64 = 1;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_EXCESSIVE_FEE"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_EXCESSIVE_FEE">ERROR_EXCESSIVE_FEE</a>: u64 = 22;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INSUFFICIENT_BALANCE"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INSUFFICIENT_BALANCE">ERROR_INSUFFICIENT_BALANCE</a>: u64 = 27;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INSUFFICIENT_LIQUIDITY_BURNED"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INSUFFICIENT_LIQUIDITY_BURNED">ERROR_INSUFFICIENT_LIQUIDITY_BURNED</a>: u64 = 10;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INSUFFICIENT_LIQUIDITY_MINTED"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INSUFFICIENT_LIQUIDITY_MINTED">ERROR_INSUFFICIENT_LIQUIDITY_MINTED</a>: u64 = 4;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INSUFFICIENT_OUTPUT_AMOUNT"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INSUFFICIENT_OUTPUT_AMOUNT">ERROR_INSUFFICIENT_OUTPUT_AMOUNT</a>: u64 = 13;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INVALID_AMOUNT"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_INVALID_AMOUNT">ERROR_INVALID_AMOUNT</a>: u64 = 8;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_K"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_K">ERROR_K</a>: u64 = 15;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_MUST_BE_INFERIOR_TO_TWENTY"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_MUST_BE_INFERIOR_TO_TWENTY">ERROR_MUST_BE_INFERIOR_TO_TWENTY</a>: u64 = 24;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NOT_ADMIN"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NOT_ADMIN">ERROR_NOT_ADMIN</a>: u64 = 17;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NOT_CREATOR"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NOT_CREATOR">ERROR_NOT_CREATOR</a>: u64 = 2;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NOT_EQUAL_EXACT_AMOUNT"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NOT_EQUAL_EXACT_AMOUNT">ERROR_NOT_EQUAL_EXACT_AMOUNT</a>: u64 = 19;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NOT_FEE_TO"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NOT_FEE_TO">ERROR_NOT_FEE_TO</a>: u64 = 18;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NOT_OWNER"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NOT_OWNER">ERROR_NOT_OWNER</a>: u64 = 29;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NOT_RESOURCE_ACCOUNT"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NOT_RESOURCE_ACCOUNT">ERROR_NOT_RESOURCE_ACCOUNT</a>: u64 = 20;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NO_FEE_WITHDRAW"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NO_FEE_WITHDRAW">ERROR_NO_FEE_WITHDRAW</a>: u64 = 21;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NO_REWARDS"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NO_REWARDS">ERROR_NO_REWARDS</a>: u64 = 28;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NO_STAKE"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_NO_STAKE">ERROR_NO_STAKE</a>: u64 = 26;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_ONLY_ADMIN"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_ONLY_ADMIN">ERROR_ONLY_ADMIN</a>: u64 = 0;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_PAIR_NOT_CREATED"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_PAIR_NOT_CREATED">ERROR_PAIR_NOT_CREATED</a>: u64 = 23;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_POOL_NOT_CREATED"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_POOL_NOT_CREATED">ERROR_POOL_NOT_CREATED</a>: u64 = 25;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_TOKENS_NOT_SORTED"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_TOKENS_NOT_SORTED">ERROR_TOKENS_NOT_SORTED</a>: u64 = 9;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_X_NOT_REGISTERED"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_X_NOT_REGISTERED">ERROR_X_NOT_REGISTERED</a>: u64 = 16;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_Y_NOT_REGISTERED"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ERROR_Y_NOT_REGISTERED">ERROR_Y_NOT_REGISTERED</a>: u64 = 16;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_MINIMUM_LIQUIDITY"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_MINIMUM_LIQUIDITY">MINIMUM_LIQUIDITY</a>: u128 = 1000;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_PRECISION"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_PRECISION">PRECISION</a>: u64 = 10000;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_RESOURCE_ACCOUNT"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_RESOURCE_ACCOUNT">RESOURCE_ACCOUNT</a>: <b>address</b> = 0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ZERO_ACCOUNT"></a>



<pre><code><b>const</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_ZERO_ACCOUNT">ZERO_ACCOUNT</a>: <b>address</b> = 0x0;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_init_rewards_pool"></a>

## Function `init_rewards_pool`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_init_rewards_pool">init_rewards_pool</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, is_x_staked: bool)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_stake_tokens"></a>

## Function `stake_tokens`



<pre><code><b>public</b> entry <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_stake_tokens">stake_tokens</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, amount: u64)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_withdraw_tokens"></a>

## Function `withdraw_tokens`



<pre><code><b>public</b> entry <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_withdraw_tokens">withdraw_tokens</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, amount: u64)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_claim_rewards"></a>

## Function `claim_rewards`



<pre><code><b>public</b> entry <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_claim_rewards">claim_rewards</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_create_pair"></a>

## Function `create_pair`

Create the specified coin pair


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_create_pair">create_pair</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_register_lp"></a>

## Function `register_lp`



<pre><code><b>public</b> <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_register_lp">register_lp</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_is_pair_created"></a>

## Function `is_pair_created`



<pre><code><b>public</b> <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_is_pair_created">is_pair_created</a>&lt;X, Y&gt;(): bool
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_is_pool_created"></a>

## Function `is_pool_created`



<pre><code><b>public</b> <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_is_pool_created">is_pool_created</a>&lt;X, Y&gt;(): bool
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_lp_balance"></a>

## Function `lp_balance`

Obtain the LP token balance of <code>addr</code>.
This method can only be used to check other users' balance.


<pre><code><b>public</b> <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_lp_balance">lp_balance</a>&lt;X, Y&gt;(addr: <b>address</b>): u64
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_total_lp_supply"></a>

## Function `total_lp_supply`

Get the total supply of LP Tokens


<pre><code><b>public</b> <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_total_lp_supply">total_lp_supply</a>&lt;X, Y&gt;(): u128
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_token_fees"></a>

## Function `token_fees`

Get the current fees for a token pair


<pre><code><b>public</b> <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_token_fees">token_fees</a>&lt;X, Y&gt;(): u128
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_token_fees_accumulated"></a>

## Function `token_fees_accumulated`



<pre><code><b>public</b> <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_token_fees_accumulated">token_fees_accumulated</a>&lt;X, Y&gt;(): (u64, u64, u64, u64, u64, u64)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_token_rewards_pool_info"></a>

## Function `token_rewards_pool_info`



<pre><code><b>public</b> <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_token_rewards_pool_info">token_rewards_pool_info</a>&lt;X, Y&gt;(): (u64, u64, u64, u128, u128, u128, bool)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_token_reserves"></a>

## Function `token_reserves`

Get the current reserves of T0 and T1 with the latest updated timestamp


<pre><code><b>public</b> <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_token_reserves">token_reserves</a>&lt;X, Y&gt;(): (u64, u64, u64)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_token_balances"></a>

## Function `token_balances`

The amount of balance currently in pools of the liquidity pair


<pre><code><b>public</b> <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_token_balances">token_balances</a>&lt;X, Y&gt;(): (u64, u64)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_check_or_register_coin_store"></a>

## Function `check_or_register_coin_store`



<pre><code><b>public</b> <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_check_or_register_coin_store">check_or_register_coin_store</a>&lt;X&gt;(sender: &<a href="">signer</a>)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_admin"></a>

## Function `admin`



<pre><code><b>public</b> <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_admin">admin</a>(): <b>address</b>
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_fee_to"></a>

## Function `fee_to`



<pre><code><b>public</b> <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_fee_to">fee_to</a>(): <b>address</b>
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_add_liquidity"></a>

## Function `add_liquidity`

Add more liquidity to token types. This method explicitly assumes the
min of both tokens are 0.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_add_liquidity">add_liquidity</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, amount_x: u64, amount_y: u64): (u64, u64, u64)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_add_swap_event"></a>

## Function `add_swap_event`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_add_swap_event">add_swap_event</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, amount_x_in: u64, amount_y_in: u64, amount_x_out: u64, amount_y_out: u64)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_add_swap_event_with_address"></a>

## Function `add_swap_event_with_address`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_add_swap_event_with_address">add_swap_event_with_address</a>&lt;X, Y&gt;(sender_addr: <b>address</b>, amount_x_in: u64, amount_y_in: u64, amount_x_out: u64, amount_y_out: u64)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_remove_liquidity"></a>

## Function `remove_liquidity`

Remove liquidity to token types.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_remove_liquidity">remove_liquidity</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, liquidity: u64): (u64, u64)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_exact_x_to_y"></a>

## Function `swap_exact_x_to_y`

Swap X to Y, X is in and Y is out. This method assumes amount_out_min is 0


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_exact_x_to_y">swap_exact_x_to_y</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, amount_in: u64, <b>to</b>: <b>address</b>): u64
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_exact_x_to_y_direct"></a>

## Function `swap_exact_x_to_y_direct`

Swap X to Y, X is in and Y is out. This method assumes amount_out_min is 0


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_exact_x_to_y_direct">swap_exact_x_to_y_direct</a>&lt;X, Y&gt;(coins_in: <a href="_Coin">coin::Coin</a>&lt;X&gt;): (<a href="_Coin">coin::Coin</a>&lt;X&gt;, <a href="_Coin">coin::Coin</a>&lt;Y&gt;)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_x_to_exact_y"></a>

## Function `swap_x_to_exact_y`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_x_to_exact_y">swap_x_to_exact_y</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, amount_in: u64, amount_out: u64, <b>to</b>: <b>address</b>): u64
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_x_to_exact_y_direct"></a>

## Function `swap_x_to_exact_y_direct`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_x_to_exact_y_direct">swap_x_to_exact_y_direct</a>&lt;X, Y&gt;(coins_in: <a href="_Coin">coin::Coin</a>&lt;X&gt;, amount_out: u64): (<a href="_Coin">coin::Coin</a>&lt;X&gt;, <a href="_Coin">coin::Coin</a>&lt;Y&gt;)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_exact_y_to_x"></a>

## Function `swap_exact_y_to_x`

Swap Y to X, Y is in and X is out. This method assumes amount_out_min is 0


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_exact_y_to_x">swap_exact_y_to_x</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, amount_in: u64, <b>to</b>: <b>address</b>): u64
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_y_to_exact_x"></a>

## Function `swap_y_to_exact_x`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_y_to_exact_x">swap_y_to_exact_x</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, amount_in: u64, amount_out: u64, <b>to</b>: <b>address</b>): u64
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_y_to_exact_x_direct"></a>

## Function `swap_y_to_exact_x_direct`



<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_y_to_exact_x_direct">swap_y_to_exact_x_direct</a>&lt;X, Y&gt;(coins_in: <a href="_Coin">coin::Coin</a>&lt;Y&gt;, amount_out: u64): (<a href="_Coin">coin::Coin</a>&lt;X&gt;, <a href="_Coin">coin::Coin</a>&lt;Y&gt;)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_exact_y_to_x_direct"></a>

## Function `swap_exact_y_to_x_direct`

Swap Y to X, Y is in and X is out. This method assumes amount_out_min is 0


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_swap_exact_y_to_x_direct">swap_exact_y_to_x_direct</a>&lt;X, Y&gt;(coins_in: <a href="_Coin">coin::Coin</a>&lt;Y&gt;): (<a href="_Coin">coin::Coin</a>&lt;X&gt;, <a href="_Coin">coin::Coin</a>&lt;Y&gt;)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_set_admin"></a>

## Function `set_admin`



<pre><code><b>public</b> entry <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_set_admin">set_admin</a>(sender: &<a href="">signer</a>, new_admin: <b>address</b>)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_set_fee_to"></a>

## Function `set_fee_to`



<pre><code><b>public</b> entry <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_set_fee_to">set_fee_to</a>(sender: &<a href="">signer</a>, new_fee_to: <b>address</b>)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_set_token_pair_owner"></a>

## Function `set_token_pair_owner`



<pre><code><b>public</b> entry <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_set_token_pair_owner">set_token_pair_owner</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, owner: <b>address</b>)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_set_treasury_fee"></a>

## Function `set_treasury_fee`



<pre><code><b>public</b> entry <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_set_treasury_fee">set_treasury_fee</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, new_treasury_fee: u128)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_set_token_fees"></a>

## Function `set_token_fees`



<pre><code><b>public</b> entry <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_set_token_fees">set_token_fees</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, new_liquidity_fee: u128, new_team_fee: u128, new_rewards_fee: u128)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_withdraw_team_fee"></a>

## Function `withdraw_team_fee`



<pre><code><b>public</b> entry <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_withdraw_team_fee">withdraw_team_fee</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_withdraw_fee"></a>

## Function `withdraw_fee`



<pre><code><b>public</b> entry <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_withdraw_fee">withdraw_fee</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_upgrade_swap"></a>

## Function `upgrade_swap`



<pre><code><b>public</b> entry <b>fun</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_upgrade_swap">upgrade_swap</a>(sender: &<a href="">signer</a>, metadata_serialized: <a href="">vector</a>&lt;u8&gt;, <a href="">code</a>: <a href="">vector</a>&lt;<a href="">vector</a>&lt;u8&gt;&gt;)
</code></pre>
