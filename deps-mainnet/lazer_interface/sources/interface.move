// ABI stub for the `pyth_lazer` TYPES that alphafi_oracle consumes — `abort` bodies that NEVER run: the
// consumer links Pyth's real on-chain Lazer package via `published-at` in Move.toml (publish with
// --skip-dependency-verification). This supplies only type identities (no Wormhole dep).
//
// Verification is NOT here: per Pyth's "verify in PTBs, not contracts" guidance, the PTB calls the real
// on-chain `pyth_lazer::parse_and_verify_le_ecdsa_update_v2` and passes the verified `Update` into
// `alphafi_oracle::oracle::ingest_lazer_update`. So this stub needs no `pyth_lazer`/`state` module and the
// oracle never links the verifier fn — it survives Pyth verifier upgrades without a republish.
// Mirrors pyth-network/pyth-crosschain @ lazer/contracts/sui — re-sync only if these consumed types change.

module pyth_lazer::i64 {
    public struct I64 has copy, drop, store {
        negative: bool,
        magnitude: u64,
    }
    public fun get_is_negative(_i: &I64): bool { abort 0 }
    public fun get_magnitude_if_positive(_i: &I64): u64 { abort 0 }
}

module pyth_lazer::i16 {
    public struct I16 has copy, drop, store {
        negative: bool,
        magnitude: u16,
    }
    public fun get_is_negative(_i: &I16): bool { abort 0 }
    public fun get_magnitude_if_positive(_i: &I16): u16 { abort 0 }
    public fun get_magnitude_if_negative(_i: &I16): u16 { abort 0 }
}

module pyth_lazer::feed {
    use pyth_lazer::i64::I64;
    use pyth_lazer::i16::I16;
    public struct Feed has copy, drop {}
    public fun feed_id(_feed: &Feed): u32 { abort 0 }
    public fun price(_feed: &Feed): Option<Option<I64>> { abort 0 }
    public fun exponent(_feed: &Feed): Option<I16> { abort 0 }
    public fun ema_price(_feed: &Feed): Option<Option<I64>> { abort 0 }
    public fun confidence(_feed: &Feed): Option<Option<I64>> { abort 0 }
    public fun ema_confidence(_feed: &Feed): Option<Option<u64>> { abort 0 }
    public fun feed_update_timestamp(_feed: &Feed): Option<Option<u64>> { abort 0 }
}

module pyth_lazer::update_v2 {
    use pyth_lazer::feed::Feed;
    public struct Update has copy, drop {}
    public fun timestamp(_update: &Update): u64 { abort 0 }
    public fun feeds(_update: &Update): vector<Feed> { abort 0 }
}
