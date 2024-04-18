
<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router"></a>

# Module `0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f::router`



-  [Constants](#@Constants_0)
-  [Function `create_pair`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_create_pair)
-  [Function `create_rewards_pool`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_create_rewards_pool)
-  [Function `stake_tokens_in_pool`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_stake_tokens_in_pool)
-  [Function `withdraw_tokens_from_pool`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_withdraw_tokens_from_pool)
-  [Function `claim_rewards_from_pool`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_claim_rewards_from_pool)
-  [Function `add_liquidity`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_add_liquidity)
-  [Function `remove_liquidity`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_remove_liquidity)
-  [Function `swap_exact_input`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_swap_exact_input)
-  [Function `swap_exact_output`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_swap_exact_output)
-  [Function `swap_exact_x_to_y_direct_external`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_swap_exact_x_to_y_direct_external)
-  [Function `get_amount_in`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_get_amount_in)
-  [Function `swap_x_to_exact_y_direct_external`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_swap_x_to_exact_y_direct_external)
-  [Function `register_lp`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_register_lp)
-  [Function `register_token`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_register_token)


<pre><code><b>use</b> <a href="">0x1::coin</a>;
<b>use</b> <a href="">0x1::signer</a>;
<b>use</b> <a href="swap.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap">0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f::swap</a>;
<b>use</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils">0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f::swap_utils</a>;
</code></pre>



<a id="@Constants_0"></a>

## Constants


<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_E_INPUT_MORE_THAN_MAX"></a>

Require Input amount is more than max limit


<pre><code><b>const</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_E_INPUT_MORE_THAN_MAX">E_INPUT_MORE_THAN_MAX</a>: u64 = 1;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_E_INSUFFICIENT_X_AMOUNT"></a>

Insufficient X


<pre><code><b>const</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_E_INSUFFICIENT_X_AMOUNT">E_INSUFFICIENT_X_AMOUNT</a>: u64 = 2;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_E_INSUFFICIENT_Y_AMOUNT"></a>

Insufficient Y


<pre><code><b>const</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_E_INSUFFICIENT_Y_AMOUNT">E_INSUFFICIENT_Y_AMOUNT</a>: u64 = 3;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_E_OUTPUT_LESS_THAN_MIN"></a>

Output amount is less than required


<pre><code><b>const</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_E_OUTPUT_LESS_THAN_MIN">E_OUTPUT_LESS_THAN_MIN</a>: u64 = 0;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_E_PAIR_NOT_CREATED"></a>

Pair is not created


<pre><code><b>const</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_E_PAIR_NOT_CREATED">E_PAIR_NOT_CREATED</a>: u64 = 4;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_E_POOL_EXISTS"></a>



<pre><code><b>const</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_E_POOL_EXISTS">E_POOL_EXISTS</a>: u64 = 5;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_E_POOL_NOT_CREATED"></a>



<pre><code><b>const</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_E_POOL_NOT_CREATED">E_POOL_NOT_CREATED</a>: u64 = 6;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_create_pair"></a>

## Function `create_pair`

Create a Pair from 2 Coins
Should revert if the pair is already created


<pre><code><b>public</b> entry <b>fun</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_create_pair">create_pair</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_create_rewards_pool"></a>

## Function `create_rewards_pool`



<pre><code><b>public</b> entry <b>fun</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_create_rewards_pool">create_rewards_pool</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, is_x_staked: bool)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_stake_tokens_in_pool"></a>

## Function `stake_tokens_in_pool`



<pre><code><b>public</b> entry <b>fun</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_stake_tokens_in_pool">stake_tokens_in_pool</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, amount: u64)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_withdraw_tokens_from_pool"></a>

## Function `withdraw_tokens_from_pool`



<pre><code><b>public</b> entry <b>fun</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_withdraw_tokens_from_pool">withdraw_tokens_from_pool</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, amount: u64)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_claim_rewards_from_pool"></a>

## Function `claim_rewards_from_pool`



<pre><code><b>public</b> entry <b>fun</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_claim_rewards_from_pool">claim_rewards_from_pool</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_add_liquidity"></a>

## Function `add_liquidity`

Add Liquidity, create pair if it's needed


<pre><code><b>public</b> entry <b>fun</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_add_liquidity">add_liquidity</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, amount_x_desired: u64, amount_y_desired: u64, amount_x_min: u64, amount_y_min: u64)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_remove_liquidity"></a>

## Function `remove_liquidity`

Remove Liquidity


<pre><code><b>public</b> entry <b>fun</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_remove_liquidity">remove_liquidity</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, liquidity: u64, amount_x_min: u64, amount_y_min: u64)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_swap_exact_input"></a>

## Function `swap_exact_input`

Swap exact input amount of X to maxiumin possible amount of Y


<pre><code><b>public</b> entry <b>fun</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_swap_exact_input">swap_exact_input</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, x_in: u64, y_min_out: u64)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_swap_exact_output"></a>

## Function `swap_exact_output`

Swap miniumn possible amount of X to exact output amount of Y


<pre><code><b>public</b> entry <b>fun</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_swap_exact_output">swap_exact_output</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>, y_out: u64, x_max_in: u64)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_swap_exact_x_to_y_direct_external"></a>

## Function `swap_exact_x_to_y_direct_external`



<pre><code><b>public</b> <b>fun</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_swap_exact_x_to_y_direct_external">swap_exact_x_to_y_direct_external</a>&lt;X, Y&gt;(x_in: <a href="_Coin">coin::Coin</a>&lt;X&gt;): <a href="_Coin">coin::Coin</a>&lt;Y&gt;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_get_amount_in"></a>

## Function `get_amount_in`



<pre><code><b>public</b> <b>fun</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_get_amount_in">get_amount_in</a>&lt;X, Y&gt;(y_out_amount: u64): u64
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_swap_x_to_exact_y_direct_external"></a>

## Function `swap_x_to_exact_y_direct_external`



<pre><code><b>public</b> <b>fun</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_swap_x_to_exact_y_direct_external">swap_x_to_exact_y_direct_external</a>&lt;X, Y&gt;(x_in: <a href="_Coin">coin::Coin</a>&lt;X&gt;, y_out_amount: u64): (<a href="_Coin">coin::Coin</a>&lt;X&gt;, <a href="_Coin">coin::Coin</a>&lt;Y&gt;)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_register_lp"></a>

## Function `register_lp`



<pre><code><b>public</b> entry <b>fun</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_register_lp">register_lp</a>&lt;X, Y&gt;(sender: &<a href="">signer</a>)
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_register_token"></a>

## Function `register_token`



<pre><code><b>public</b> entry <b>fun</b> <a href="router.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_router_register_token">register_token</a>&lt;X&gt;(sender: &<a href="">signer</a>)
</code></pre>
