module alphafi_oracle::oracle {
    use std::type_name::{Self,TypeName};
    use sui::clock::Clock;
    use pyth::price_info;
    use pyth::price_identifier::{Self,PriceIdentifier};
    use pyth::price::{Self,Price};
    use pyth::price_feed;
    use pyth::pyth;
    use pyth::price_info::PriceInfoObject;
    use sui::vec_map::{Self,VecMap};
    use sui::table::{Self,Table};
    use pyth::i64::{Self,I64};
    use sui::event::{Self};
    use sui::sui::SUI;
    use alphafi_stdlib::math::{Self,Number};
    use sui::math as sui_math;
    use sui::dynamic_field;
   

    #[error]
    const ErrIdentifierAlreadyPresent :u64 = 0;
    const ErrCoinTypeAlreadyPresent :u64 = 1;
    const ErrCoinTypeNotPresent :u64 = 2;
    const ErrParentPriceIdentifierNotPresent: u64 = 3;
    const ErrEmaSpotDiffThresholdExceeded: u64 = 4;
    const ErrInvalidCircuitBreakerThreshold: u64 = 5;
    const ErrAlternatePriceIdentifierNotPresent: u64 = 6;

    const PYTH :u64 = 0;
    const SUPRA: u8 = 1;

    const COIN_TYPE_STABLE: u8 = 0;
    const COIN_TYPE_NORMAL: u8 = 1;

    const MAX_CONF_DEVIATION_PERCENTAGE :u8 = 10;


    public struct PythPriceUpdationEvent  has copy , drop{
        coin_type: TypeName,
        pyth_price_id: PriceIdentifier,
        price: Number,
        ema_price: Number,
        conf: Number,
        last_updated: u64
    }

    public struct AdminCap has store, key {
        id: UID
    }

    public struct AlternatePriceIdentifier has drop,copy,store {}

    public struct Oracle has store, key {
        id: UID,
        
        //Hold the priceInfo object for all the supported Cointypes.
        price_infos: Table<TypeName,PriceInfo>,
        //Max acceptable age of the price update.
        max_age: u64,
    }

    public struct PriceInfo has store,copy,drop {
        coin_type: TypeName,
        price: Number,
        ema_price: Number,
        conf: Number,
        coin_kind: u8,
        active: bool,
        circuit_breaker_threshold_bps: u16,
        last_updated: u64,
    }

    public fun get_price_info (
        self: &Oracle,
        coin_type: TypeName
    ) : PriceInfo{
        abort 0
    }

    public fun get_price(
        self: &PriceInfo,
    ) : Number{
        self.price
    }

    public fun get_ema_price(
        self: &PriceInfo,
    ) : Number{
        self.ema_price
    }

    
    public fun coin_type(
        self: &PriceInfo,
    ) : TypeName{
        self.coin_type
    }
    

    public fun get_updated_time(
        self: &PriceInfo,
    ) : u64{
        self.last_updated
    }

    
    public fun update_price_from_pyth(
        self: &mut Oracle,
        price_info_object: &PriceInfoObject,
        clock: &Clock,
    ) {
       abort 0
    }
    
    
}
