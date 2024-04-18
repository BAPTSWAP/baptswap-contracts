
<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils"></a>

# Module `0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f::swap_utils`

Uniswap v2 like token swap program


-  [Constants](#@Constants_0)
-  [Function `get_amount_out`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_amount_out)
-  [Function `get_amount_in`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_amount_in)
-  [Function `quote`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_quote)
-  [Function `get_token_info`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_token_info)
-  [Function `get_smaller_enum`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_smaller_enum)
-  [Function `get_greater_enum`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_greater_enum)
-  [Function `get_equal_enum`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_equal_enum)
-  [Function `sort_token_type`](#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_sort_token_type)


<pre><code><b>use</b> <a href="">0x1::comparator</a>;
<b>use</b> <a href="">0x1::string</a>;
<b>use</b> <a href="">0x1::type_info</a>;
</code></pre>



<a id="@Constants_0"></a>

## Constants


<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_EQUAL"></a>



<pre><code><b>const</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_EQUAL">EQUAL</a>: u8 = 0;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_GREATER"></a>



<pre><code><b>const</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_GREATER">GREATER</a>: u8 = 2;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_SMALLER"></a>



<pre><code><b>const</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_SMALLER">SMALLER</a>: u8 = 1;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_ERROR_INSUFFICIENT_AMOUNT"></a>



<pre><code><b>const</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_ERROR_INSUFFICIENT_AMOUNT">ERROR_INSUFFICIENT_AMOUNT</a>: u64 = 2;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_ERROR_INSUFFICIENT_INPUT_AMOUNT"></a>



<pre><code><b>const</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_ERROR_INSUFFICIENT_INPUT_AMOUNT">ERROR_INSUFFICIENT_INPUT_AMOUNT</a>: u64 = 0;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_ERROR_INSUFFICIENT_LIQUIDITY"></a>



<pre><code><b>const</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_ERROR_INSUFFICIENT_LIQUIDITY">ERROR_INSUFFICIENT_LIQUIDITY</a>: u64 = 1;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_ERROR_INSUFFICIENT_OUTPOT_AMOUNT"></a>



<pre><code><b>const</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_ERROR_INSUFFICIENT_OUTPOT_AMOUNT">ERROR_INSUFFICIENT_OUTPOT_AMOUNT</a>: u64 = 3;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_ERROR_SAME_COIN"></a>



<pre><code><b>const</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_ERROR_SAME_COIN">ERROR_SAME_COIN</a>: u64 = 4;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_amount_out"></a>

## Function `get_amount_out`



<pre><code><b>public</b> <b>fun</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_amount_out">get_amount_out</a>(amount_in: u64, reserve_in: u64, reserve_out: u64, total_fees: u128): u64
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_amount_in"></a>

## Function `get_amount_in`



<pre><code><b>public</b> <b>fun</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_amount_in">get_amount_in</a>(amount_out: u64, reserve_in: u64, reserve_out: u64, total_fees: u128): u64
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_quote"></a>

## Function `quote`



<pre><code><b>public</b> <b>fun</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_quote">quote</a>(amount_x: u64, reserve_x: u64, reserve_y: u64): u64
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_token_info"></a>

## Function `get_token_info`



<pre><code><b>public</b> <b>fun</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_token_info">get_token_info</a>&lt;T&gt;(): <a href="">vector</a>&lt;u8&gt;
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_smaller_enum"></a>

## Function `get_smaller_enum`



<pre><code><b>public</b> <b>fun</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_smaller_enum">get_smaller_enum</a>(): u8
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_greater_enum"></a>

## Function `get_greater_enum`



<pre><code><b>public</b> <b>fun</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_greater_enum">get_greater_enum</a>(): u8
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_equal_enum"></a>

## Function `get_equal_enum`



<pre><code><b>public</b> <b>fun</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_get_equal_enum">get_equal_enum</a>(): u8
</code></pre>



<a id="0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_sort_token_type"></a>

## Function `sort_token_type`



<pre><code><b>public</b> <b>fun</b> <a href="swap_utils.md#0x4c26798a23239e4758267ba86fce11a5c7039a28bf1a4ea1207b74e930012a6f_swap_utils_sort_token_type">sort_token_type</a>&lt;X, Y&gt;(): bool
</code></pre>
