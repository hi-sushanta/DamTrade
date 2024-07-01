//
//  Generated code. Do not modify.
//  source: lib/proto/market_data.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use marketDataDescriptor instead')
const MarketData$json = {
  '1': 'MarketData',
  '2': [
    {'1': 'instrument_key', '3': 1, '4': 1, '5': 9, '10': 'instrumentKey'},
    {'1': 'last_trade_price', '3': 2, '4': 1, '5': 1, '10': 'lastTradePrice'},
  ],
};

/// Descriptor for `MarketData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List marketDataDescriptor = $convert.base64Decode(
    'CgpNYXJrZXREYXRhEiUKDmluc3RydW1lbnRfa2V5GAEgASgJUg1pbnN0cnVtZW50S2V5EigKEG'
    'xhc3RfdHJhZGVfcHJpY2UYAiABKAFSDmxhc3RUcmFkZVByaWNl');

