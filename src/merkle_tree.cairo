use super::utils::double_sha256;

pub fn merkle_root(ref txids: Array<u256>) -> u256 {
    let len = txids.len();
    if len % 2 == 1 {
        txids.append(*txids.at(len - 1));
    } else {
        // CVE-2012-2459 bug fix
        assert!(
            txids.at(len - 1) != txids.at(len - 2), "unexpected node duplication in merkle tree"
        );
    }

    let mut next_txids = ArrayTrait::new();
    let mut i = 0;
    while i < len {
        next_txids.append(double_sha256(*txids.at(i), *txids.at(i + 1)));
        i += 2;
    };

    merkle_root(ref next_txids)
}

#[cfg(test)]
mod tests {
    use super::{merkle_root};
    use starknet::core::types::FieldElement;

    #[test]
    fn test_merkle_root() {

        let txids = array![
            FieldElement::from_hex_be(
                "50ba87bdd484f07c8c55f76a22982f987c0465fdc345381b4634a70dc0ea0b38"
            )
                .unwrap(),
            FieldElement::from_hex_be(
                "96b8787b1e3abed802cff132c891c2e511edd200b08baa9eb7d8942d7c5423c6"
            )
                .unwrap(),
            FieldElement::from_hex_be(
                "65e5a4862b807c83b588e0f4122d4ca2d46691d17a1ec1ebce4485dccc3380d4"
            )
                .unwrap(),
            FieldElement::from_hex_be(
                "1ee9441ddde02f8ffb910613cd509adbc21282c6e34728599f3ae75e972fb815"
            )
                .unwrap(),
            FieldElement::from_hex_be(
                "ec950fc02f71fc06ed71afa4d2c49fcba04777f353a001b0bba9924c63cfe712"
            )
                .unwrap(),
            FieldElement::from_hex_be(
                "5d874040a77de7182f7a68bf47c02898f519cb3b58092b79fa2cff614a0f4d50"
            )
                .unwrap(),
            FieldElement::from_hex_be(
                "0a1c958af3e30ad07f659f44f708f8648452d1427463637b9039e5b721699615"
            )
                .unwrap(),
            FieldElement::from_hex_be(
                "d94d24d2dcaac111f5f638983122b0e55a91aeb999e0e4d58e0952fa346a1711"
            )
                .unwrap(),
            FieldElement::from_hex_be(
                "c4709bc9f860e5dff01b5fc7b53fb9deecc622214aba710d495bccc7f860af4a"
            )
                .unwrap(),
            FieldElement::from_hex_be(
                "d4ed5f5e4334c0a4ccce6f706f3c9139ac0f6d2af3343ad3fae5a02fee8df542"
            )
                .unwrap(),
            FieldElement::from_hex_be(
                "b5aed07505677c8b1c6703742f4558e993d7984dc03d2121d3712d81ee067351"
            )
                .unwrap(),
            FieldElement::from_hex_be(
                "f9a14bf211c857f61ff9a1de95fc902faebff67c5d4898da8f48c9d306f1f80f"
            )
                .unwrap(),
        ];
        let expected_merkle_root = FieldElement::from_hex_be(
            "0x50ba87bdd484f07c8c55f76a22982f987c0465fdc345381b4634a70dc0ea0b38_u256"
        )
            .unwrap();
        assert_eq!(merkle_root(txids), expected_merkle_root);
    }
}

