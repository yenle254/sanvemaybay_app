Case 1: outbound: params:
domain: android.company.xyz
ob_aircode: VU
ob_base_price: 748000
adt_count: 2
chd_count: 1
inf_count: 0
dep_code: VU
outbound_date: 2026-01-22

response case 1 như sau:
{
    "error": false,
    "message": "Successfully calculated flight fare",
    "data": {
        "delivery_fee": 25000,
        "adt_base_price": 1496000,
        "chd_base_price": 748000,
        "inf_base_price": 0,
        "total_tax_fee": 2332720,
        "total_amount": 4576720,
        "outbound": {
            "adt_base_price": 1496000,
            "adt_tax_fee": 1594480,
            "chd_base_price": 748000,
            "chd_tax_fee": 738240,
            "inf_base_price": 0,
            "inf_tax_fee": 0,
            "total_base_price": 2244000,
            "total_tax_fee": 2332720,
            "total_amount": 4576720
        }
    }
}


case 2: outbound và inbound: 
params:
domain: android.company.xyz
ob_aircode: VU
ob_base_price: 748000
adt_count: 2
chd_count: 1
inf_count: 0
ib_aircode: VJ
ib_base_price: 690000
dep_code: VU
arv_code: VJ
outbound_date: 2026-01-22
inbound_date: 2026-01-25

response như sau:
{
    "error": false,
    "message": "Successfully calculated flight fare",
    "data": {
        "delivery_fee": 25000,
        "adt_base_price": 2876000,
        "chd_base_price": 1438000,
        "inf_base_price": 0,
        "total_tax_fee": 4489520,
        "total_amount": 8803520,
        "outbound": {
            "adt_base_price": 1496000,
            "adt_tax_fee": 1594480,
            "chd_base_price": 748000,
            "chd_tax_fee": 738240,
            "inf_base_price": 0,
            "inf_tax_fee": 0,
            "total_base_price": 2244000,
            "total_tax_fee": 2332720,
            "total_amount": 4576720
        },
        "inbound": {
            "adt_base_price": 1380000,
            "adt_tax_fee": 1477200,
            "chd_base_price": 690000,
            "chd_tax_fee": 679600,
            "inf_base_price": 0,
            "inf_tax_fee": 0,
            "total_base_price": 2070000,
            "total_tax_fee": 2156800,
            "total_amount": 4226800
        }
    }
}