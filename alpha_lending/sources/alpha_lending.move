/// Interface for the Alpha Lending protocol that handles lending, borrowing, and liquidation operations
/// This module provides the core functionality for a decentralized lending protocol on Sui
/// It allows users to:
/// - Create lending positions
/// - Add/remove collateral
/// - Borrow and repay assets
/// - Liquidate undercollateralized positions
/// - Handle rewards and fees
module alpha_lending::alpha_lending {
    use sui::coin::{Coin};
    use sui::clock::{Clock};
    use sui::balance::Balance;
    use alpha_lending::market::{Market, MarketCap, XToken, LiquidityPromise};
    use alpha_lending::position::{Position, PositionCap};
    use alpha_lending::oracle::{Oracle, PriceIdentifier};
    use alpha_lending::rewards::{ClaimableReward};
    use bluefin_spot::position::Position as BFPosition;
    use bluefin_spot::pool::Pool as BFPool;
    use bluefin_spot::config::GlobalConfig as BFConfig;
    use sui::object::{ID, UID};
    use std::type_name::{TypeName};
    use sui::table::{Table};
    use sui::sui::SUI;
    use sui_system::sui_system::{SuiSystemState};

    // Error codes for alpha lending
    // When user tries to remove collateral more than the position has or allowed by the protocol   
    const ErrNotEnoughCollateral: u64 = 0;
    // When user tries to borrow more than the permitted value
    const ErrTooMuchBorrow: u64 = 1;
    // When user tries to borrow from isolated market with other collateral
    const ErrIsolatedMarketBorrowWithOther: u64 = 2;
    // When user tries to liquidate a position not eligible for liquidation
    const ErrNotEligbleForLiquidation: u64 = 4;
    // When protocol version is invalid. Can be fixed by upgrading to latest contract.
    const ErrInvalidProtocolVersion: u64 = 8;
    // When hot potato position mismatch. Can be fixed by upgrading to latest contract.
    const ErrHotPotatoPositionMismatch: u64 = 9;
    // Occurs when depositing to or borrowing from an inactive market
    const ErrMarketNotActive: u64 = 23; 
    // When market id provided for the transaction is invalid
    const ErrInvalidMarketID: u64 = 25;
    // When trying to deposit to a market from which the position had borrowed
    const ErrCannotDepositToBorrowedMarket: u64 = 29;
    // When trying to borrow from an market that the position had deposited into
    const ErrCannotBorrowFromDepositedMarket: u64 = 30;
    // When trying to add collateral with zero value.
    const ErrInvalidCollateralAmount: u64 = 31;
    // When tring to borrow zero amount
    const ErrInvalidBorrowAmount: u64 = 32;
    // When trying to repay zero amount
    const ErrInvalidRepayAmount: u64 = 33;
    // When promise function called for the promise coin type
    const ErrInvalidPromiseCoinType: u64 = 34;
    // When SUI market is not found
    const ErrSuiMarketNotFound: u64 = 36;
    // When deposit limit is exceeded   
    const ErrDepositLimitExceeded: u64 = 37;

    /// Main protocol state that manages all lending operations
    /// Contains:
    /// - Positions table mapping position IDs to Position objects
    /// - Markets table mapping market IDs to Market objects
    /// - Oracle for price feeds
    /// - Protocol fee address
    /// - Version tracking
    /// - Protocol configuration
    /// - Admin capabilities
    public struct LendingProtocol has key, store {
        id: UID,
        lending_protocol_cap_id: ID,
        positions: Table<ID, Position>,
        markets: Table<u64, Market>,
        oracle: Oracle,
        protocol_fee_address: address,
        version: u64,
        config: LendingProtocolConfig,
        admin_cap_id: ID
    }

    /// Configuration parameters for the lending protocol
    /// Defines various thresholds and limits for:
    /// - Collateral ratios
    /// - Liquidation parameters
    /// - LP position parameters
    public struct LendingProtocolConfig has store {
        max_safe_collateral_ratio: u8,
        max_liquidation_threshold: u8,
        max_liquidation_bonus_bps: u64,
        max_liquidation_fee_bps: u64,
        lp_position_safe_collateral_ratio: u8,
        lp_position_liquidation_threshold: u8,
        reward_autocompounding: bool,
        pegged_position_config: vector<PeggedPostionPair>,
        multiplier_position_config: vector<MultiplierPositionConfig>,
        sui_staking_enabled: bool
    }

    public struct PeggedPostionPair has store {
        borrow_coin_type: TypeName,
        deposit_coin_type: TypeName,
        pegged_position_safe_collateral_ratio: u8,
        pegged_position_liquidation_threshold: u8,
    }

    public struct MultiplierPositionConfig has store {
        coin_type: TypeName,
        multiplier_position_safe_collateral_ratio: u8,
        multiplier_position_liquidation_threshold: u8,
    }



    /// Hot potato struct for handling LP position borrow operations
    public struct LpPositionBorrowHotPotato has drop {
        position_id: ID,
        lp_position_id: ID
    }

    /// Creates a new lending position
    /// Returns a PositionCap that can be used to manage the position
    public fun create_position(
        protocol: &mut LendingProtocol,
        ctx: &mut TxContext
    ): PositionCap {
        abort 0
    }

    /// Adds collateral to a position
    /// @param protocol - The lending protocol instance
    /// @param position_cap - Capability for the position
    /// @param market_id - ID of the market for the collateral
    /// @param coin - The collateral coin to add
    /// @param clock - Current time reference
    /// @param ctx - Transaction context
    public fun add_collateral<C>(
        protocol: &mut LendingProtocol,
        position_cap: &PositionCap,
        market_id: u64,
        coin: Coin<C>,
        clock: &Clock,
        ctx: &mut TxContext
    ){
        abort 0
    }

    /// Removes collateral from a position
    /// @param protocol - The lending protocol instance
    /// @param position_cap - Capability for the position
    /// @param market_id - ID of the market for the collateral
    /// @param amount - Amount of collateral to remove
    /// @param clock - Current time reference
    /// @param ctx - Transaction context
    /// @return Returns a LiquidityPromise for the removed collateral. Need to call fulfill_promise to receive the collateral back.
    public fun remove_collateral<C>(
        protocol: &mut LendingProtocol,
        position_cap: &PositionCap,
        market_id: u64,
        amount: u64,
        clock: &Clock,
    ): LiquidityPromise<C> {
        abort 0
    }

    /// Borrows assets from a position
    /// @param protocol - The lending protocol instance
    /// @param position_cap - Capability for the position
    /// @param market_id - ID of the market to borrow from
    /// @param amount - Amount to borrow
    /// @param clock - Current time reference
    /// @param ctx - Transaction context
    /// @return Returns a LiquidityPromise for the borrowed coin. Need to call fulfill_promise to receive the borrowed coin.
    public fun borrow<C>(
        protocol: &mut LendingProtocol,
        position_cap: &PositionCap,
        market_id: u64,
        amount: u64,
        clock: &Clock,
        ctx: &mut TxContext
    ): LiquidityPromise<C> {
        abort 0
    }

    /// Repays borrowed assets to a position
    /// @param protocol - The lending protocol instance
    /// @param position_cap - Capability for the position
    /// @param market_id - ID of the market to repay to
    /// @param coin - The coin to repay
    /// @param clock - Current time reference
    /// @param ctx - Transaction context
    /// @return Any remaining coin after repayment
    public fun repay<C>(
        protocol: &mut LendingProtocol,
        position_cap: &PositionCap,
        market_id: u64,
        coin: Coin<C>,
        clock: &Clock,
        ctx: &mut TxContext
    ): Coin<C> {
        abort 0
    }

    /// Liquidates an undercollateralized position
    /// @param protocol - The lending protocol instance
    /// @param liquidate_position_id - ID of the position to liquidate
    /// @param borrow_market_id - ID of the market with the borrowed asset
    /// @param withdraw_market_id - ID of the market to withdraw collateral from
    /// @param repay_coin - Coin used to repay the borrowed amount
    /// @param clock - Current time reference
    /// @param ctx - Transaction context
    /// @return Tuple of (liquidity promise for collateral, remaining repay coin). The liquidity promise needs to be fulfilled to receive the collateral.
    public fun liquidate<B,D>(
        protocol: &mut LendingProtocol,
        liquidate_position_id: ID,
        borrow_market_id: u64,
        withdraw_market_id: u64,
        repay_coin: Coin<B>,
        clock: &Clock,
        ctx: &mut TxContext
    ): (LiquidityPromise<D>, Coin<B>) {
        abort 0
    }


    /// Collects rewards from a position
    /// @param protocol - The lending protocol instance
    /// @param market_id - ID of the market to collect rewards from
    /// @param position_cap - Capability for the position
    /// @param clock - Current time reference
    /// @param ctx - Transaction context
    /// @return Tuple of (reward coin, liquidity promise). The liquidity promise needs to be fulfilled to receive the full reward.
    public fun collect_reward<C>(
        protocol: &mut LendingProtocol,
        market_id: u64,
        position_cap: &PositionCap,
        clock: &Clock,
        ctx: &mut TxContext
    ): (Coin<C>, LiquidityPromise<C>) {
        abort 0
    }

    /// Collects rewards and deposits them back into the position
    /// @param protocol - The lending protocol instance
    /// @param market_id - ID of the market to collect rewards from
    /// @param position_cap - Capability for the position
    /// @param clock - Current time reference
    /// @param ctx - Transaction context
    /// @return Tuple of (remaining reward coin, liquidity promise). The liquidity promise needs to be fulfilled to receive the full reward.
    public fun collect_reward_and_deposit<C>(
        protocol: &mut LendingProtocol,
        market_id: u64,
        position_cap: &PositionCap,
        clock: &Clock,
        ctx: &mut TxContext
    ): (Coin<C>, LiquidityPromise<C>) {
        abort 0
    }

 

    /// Performs a loan bailout operation
    /// @param protocol - The lending protocol instance
    /// @param market_id - ID of the market
    /// @param position_id - ID of the position to bailout
    /// @param coin - Coin used for bailout
    /// @param clock - Current time reference
    /// @param ctx - Transaction context
    /// @return Any remaining bailout coin
    public fun loan_bailout<C>(
        protocol: &mut LendingProtocol,
        market_id: u64,
        position_id: ID,
        coin: Coin<C>,
        clock: &Clock,
        ctx: &mut TxContext
    ): Coin<C> {
        abort 0
    }

    /// Returns the claimable rewards for a position
    /// @param protocol - The lending protocol instance
    /// @param position_cap - Capability for the position
    /// @param clock - Current time reference
    /// @return The claimable rewards for the position
    public fun get_claimable_rewards(
        protocol: &mut LendingProtocol,
        position_cap: &PositionCap,
        clock: &Clock
    ): vector<ClaimableReward> {
        abort 0
    }

    /// Fulfill a liquidity promise (For non-SUI assets)
    /// @param protocol - The lending protocol instance
    /// @param market_id - ID of the market
    /// @param position_cap - Capability for the position
    /// @param promise - The liquidity promise to fulfill
    /// @param clock - Current time reference
    /// @param ctx - Transaction context
    /// @return The fulfilled coin
    public fun fulfill_promise<C>(
        protocol: &mut LendingProtocol,
        promise: LiquidityPromise<C>,
        clock: &Clock,
        ctx: &mut TxContext
    ): Coin<C> {
        abort 0
    }

    /// Fulfill a liquidity promise for SUI
    /// @param protocol - The lending protocol instance
    /// @param market_id - ID of the market
    /// @param position_cap - Capability for the position
    /// @param promise - The liquidity promise to fulfill
    /// @param clock - Current time reference
    /// @param ctx - Transaction context
    /// @return The fulfilled SUI coin
    public fun fulfill_promise_SUI(
        protocol: &mut LendingProtocol,
        promise: LiquidityPromise<SUI>,
        system_state: &mut SuiSystemState,
        clock: &Clock,
        ctx: &mut TxContext
    ): Coin<SUI> {
        abort 0
    }

    /// Get the safe collateral ratio for a market
    /// @param market_id - ID of the market
    /// @return The safe collateral ratio for the market in terms of percentage
    public fun get_safe_collateral_ratio(
        self: &LendingProtocol,
        market_id: u64,
    ) : u8 {
        abort 0
    }

    /// Get the borrow amount for a position in a market
    /// @param market_id - ID of the market
    /// @param position_id - ID of the position
    /// @param clock - Current time reference
    /// @return The borrow amount for the position in the market
    public fun get_borrow_amount(
        self: &mut LendingProtocol,
        market_id: u64,
        position_id: ID,
        clock: &Clock,
    ) : u64 {
        abort 0
    }

    /// Get the collateral amount for a position in a market
    /// @param market_id - ID of the market
    /// @param position_id - ID of the position
    /// @param clock - Current time reference
    /// @return The collateral amount for the position in the market
    public fun get_collateral_amount(
        self: &mut LendingProtocol,
        market_id: u64,
        position_id: ID,
        clock: &Clock,
    ) : u64 {
        abort 0
    }

    /// Get the price of an asset in the market
    /// @param market_id - ID of the market
    /// @return The price of the asset in the market
    public fun get_asset_price (
        self: &mut LendingProtocol,
        market_id: u64,
    ) : u64 {
        abort 0
    }
} 
