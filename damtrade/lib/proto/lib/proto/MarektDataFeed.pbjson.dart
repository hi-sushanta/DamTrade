//
//  Generated code. Do not modify.
//  source: lib/proto/MarektDataFeed.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use lTPCDescriptor instead')
const LTPC$json = {
  '1': 'LTPC',
  '2': [
    {'1': 'ltp', '3': 1, '4': 1, '5': 1, '10': 'ltp'},
    {'1': 'ltt', '3': 2, '4': 1, '5': 3, '10': 'ltt'},
    {'1': 'ltq', '3': 3, '4': 1, '5': 3, '10': 'ltq'},
    {'1': 'cp', '3': 4, '4': 1, '5': 1, '10': 'cp'},
  ],
};

/// Descriptor for `LTPC`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lTPCDescriptor = $convert.base64Decode(
    'CgRMVFBDEhAKA2x0cBgBIAEoAVIDbHRwEhAKA2x0dBgCIAEoA1IDbHR0EhAKA2x0cRgDIAEoA1'
    'IDbHRxEg4KAmNwGAQgASgBUgJjcA==');

@$core.Deprecated('Use marketLevelDescriptor instead')
const MarketLevel$json = {
  '1': 'MarketLevel',
  '2': [
    {'1': 'bidAskQuote', '3': 1, '4': 3, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.Quote', '10': 'bidAskQuote'},
  ],
};

/// Descriptor for `MarketLevel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List marketLevelDescriptor = $convert.base64Decode(
    'CgtNYXJrZXRMZXZlbBJOCgtiaWRBc2tRdW90ZRgBIAMoCzIsLmNvbS51cHN0b3gubWFya2V0ZG'
    'F0YWZlZWRlci5ycGMucHJvdG8uUXVvdGVSC2JpZEFza1F1b3Rl');

@$core.Deprecated('Use marketOHLCDescriptor instead')
const MarketOHLC$json = {
  '1': 'MarketOHLC',
  '2': [
    {'1': 'ohlc', '3': 1, '4': 3, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.OHLC', '10': 'ohlc'},
  ],
};

/// Descriptor for `MarketOHLC`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List marketOHLCDescriptor = $convert.base64Decode(
    'CgpNYXJrZXRPSExDEj8KBG9obGMYASADKAsyKy5jb20udXBzdG94Lm1hcmtldGRhdGFmZWVkZX'
    'IucnBjLnByb3RvLk9ITENSBG9obGM=');

@$core.Deprecated('Use quoteDescriptor instead')
const Quote$json = {
  '1': 'Quote',
  '2': [
    {'1': 'bq', '3': 1, '4': 1, '5': 5, '10': 'bq'},
    {'1': 'bp', '3': 2, '4': 1, '5': 1, '10': 'bp'},
    {'1': 'bno', '3': 3, '4': 1, '5': 5, '10': 'bno'},
    {'1': 'aq', '3': 4, '4': 1, '5': 5, '10': 'aq'},
    {'1': 'ap', '3': 5, '4': 1, '5': 1, '10': 'ap'},
    {'1': 'ano', '3': 6, '4': 1, '5': 5, '10': 'ano'},
  ],
};

/// Descriptor for `Quote`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quoteDescriptor = $convert.base64Decode(
    'CgVRdW90ZRIOCgJicRgBIAEoBVICYnESDgoCYnAYAiABKAFSAmJwEhAKA2JubxgDIAEoBVIDYm'
    '5vEg4KAmFxGAQgASgFUgJhcRIOCgJhcBgFIAEoAVICYXASEAoDYW5vGAYgASgFUgNhbm8=');

@$core.Deprecated('Use optionGreeksDescriptor instead')
const OptionGreeks$json = {
  '1': 'OptionGreeks',
  '2': [
    {'1': 'op', '3': 1, '4': 1, '5': 1, '10': 'op'},
    {'1': 'up', '3': 2, '4': 1, '5': 1, '10': 'up'},
    {'1': 'iv', '3': 3, '4': 1, '5': 1, '10': 'iv'},
    {'1': 'delta', '3': 4, '4': 1, '5': 1, '10': 'delta'},
    {'1': 'theta', '3': 5, '4': 1, '5': 1, '10': 'theta'},
    {'1': 'gamma', '3': 6, '4': 1, '5': 1, '10': 'gamma'},
    {'1': 'vega', '3': 7, '4': 1, '5': 1, '10': 'vega'},
    {'1': 'rho', '3': 8, '4': 1, '5': 1, '10': 'rho'},
  ],
};

/// Descriptor for `OptionGreeks`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List optionGreeksDescriptor = $convert.base64Decode(
    'CgxPcHRpb25HcmVla3MSDgoCb3AYASABKAFSAm9wEg4KAnVwGAIgASgBUgJ1cBIOCgJpdhgDIA'
    'EoAVICaXYSFAoFZGVsdGEYBCABKAFSBWRlbHRhEhQKBXRoZXRhGAUgASgBUgV0aGV0YRIUCgVn'
    'YW1tYRgGIAEoAVIFZ2FtbWESEgoEdmVnYRgHIAEoAVIEdmVnYRIQCgNyaG8YCCABKAFSA3Jobw'
    '==');

@$core.Deprecated('Use extendedFeedDetailsDescriptor instead')
const ExtendedFeedDetails$json = {
  '1': 'ExtendedFeedDetails',
  '2': [
    {'1': 'atp', '3': 1, '4': 1, '5': 1, '10': 'atp'},
    {'1': 'cp', '3': 2, '4': 1, '5': 1, '10': 'cp'},
    {'1': 'vtt', '3': 3, '4': 1, '5': 3, '10': 'vtt'},
    {'1': 'oi', '3': 4, '4': 1, '5': 1, '10': 'oi'},
    {'1': 'changeOi', '3': 5, '4': 1, '5': 1, '10': 'changeOi'},
    {'1': 'lastClose', '3': 6, '4': 1, '5': 1, '10': 'lastClose'},
    {'1': 'tbq', '3': 7, '4': 1, '5': 1, '10': 'tbq'},
    {'1': 'tsq', '3': 8, '4': 1, '5': 1, '10': 'tsq'},
    {'1': 'close', '3': 9, '4': 1, '5': 1, '10': 'close'},
    {'1': 'lc', '3': 10, '4': 1, '5': 1, '10': 'lc'},
    {'1': 'uc', '3': 11, '4': 1, '5': 1, '10': 'uc'},
    {'1': 'yh', '3': 12, '4': 1, '5': 1, '10': 'yh'},
    {'1': 'yl', '3': 13, '4': 1, '5': 1, '10': 'yl'},
    {'1': 'fp', '3': 14, '4': 1, '5': 1, '10': 'fp'},
    {'1': 'fv', '3': 15, '4': 1, '5': 5, '10': 'fv'},
    {'1': 'mbpBuy', '3': 16, '4': 1, '5': 3, '10': 'mbpBuy'},
    {'1': 'mbpSell', '3': 17, '4': 1, '5': 3, '10': 'mbpSell'},
    {'1': 'tv', '3': 18, '4': 1, '5': 3, '10': 'tv'},
    {'1': 'dhoi', '3': 19, '4': 1, '5': 1, '10': 'dhoi'},
    {'1': 'dloi', '3': 20, '4': 1, '5': 1, '10': 'dloi'},
    {'1': 'sp', '3': 21, '4': 1, '5': 1, '10': 'sp'},
    {'1': 'poi', '3': 22, '4': 1, '5': 1, '10': 'poi'},
  ],
};

/// Descriptor for `ExtendedFeedDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List extendedFeedDetailsDescriptor = $convert.base64Decode(
    'ChNFeHRlbmRlZEZlZWREZXRhaWxzEhAKA2F0cBgBIAEoAVIDYXRwEg4KAmNwGAIgASgBUgJjcB'
    'IQCgN2dHQYAyABKANSA3Z0dBIOCgJvaRgEIAEoAVICb2kSGgoIY2hhbmdlT2kYBSABKAFSCGNo'
    'YW5nZU9pEhwKCWxhc3RDbG9zZRgGIAEoAVIJbGFzdENsb3NlEhAKA3RicRgHIAEoAVIDdGJxEh'
    'AKA3RzcRgIIAEoAVIDdHNxEhQKBWNsb3NlGAkgASgBUgVjbG9zZRIOCgJsYxgKIAEoAVICbGMS'
    'DgoCdWMYCyABKAFSAnVjEg4KAnloGAwgASgBUgJ5aBIOCgJ5bBgNIAEoAVICeWwSDgoCZnAYDi'
    'ABKAFSAmZwEg4KAmZ2GA8gASgFUgJmdhIWCgZtYnBCdXkYECABKANSBm1icEJ1eRIYCgdtYnBT'
    'ZWxsGBEgASgDUgdtYnBTZWxsEg4KAnR2GBIgASgDUgJ0dhISCgRkaG9pGBMgASgBUgRkaG9pEh'
    'IKBGRsb2kYFCABKAFSBGRsb2kSDgoCc3AYFSABKAFSAnNwEhAKA3BvaRgWIAEoAVIDcG9p');

@$core.Deprecated('Use oHLCDescriptor instead')
const OHLC$json = {
  '1': 'OHLC',
  '2': [
    {'1': 'interval', '3': 1, '4': 1, '5': 9, '10': 'interval'},
    {'1': 'open', '3': 2, '4': 1, '5': 1, '10': 'open'},
    {'1': 'high', '3': 3, '4': 1, '5': 1, '10': 'high'},
    {'1': 'low', '3': 4, '4': 1, '5': 1, '10': 'low'},
    {'1': 'close', '3': 5, '4': 1, '5': 1, '10': 'close'},
    {'1': 'volume', '3': 6, '4': 1, '5': 5, '10': 'volume'},
    {'1': 'ts', '3': 7, '4': 1, '5': 3, '10': 'ts'},
  ],
};

/// Descriptor for `OHLC`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List oHLCDescriptor = $convert.base64Decode(
    'CgRPSExDEhoKCGludGVydmFsGAEgASgJUghpbnRlcnZhbBISCgRvcGVuGAIgASgBUgRvcGVuEh'
    'IKBGhpZ2gYAyABKAFSBGhpZ2gSEAoDbG93GAQgASgBUgNsb3cSFAoFY2xvc2UYBSABKAFSBWNs'
    'b3NlEhYKBnZvbHVtZRgGIAEoBVIGdm9sdW1lEg4KAnRzGAcgASgDUgJ0cw==');

@$core.Deprecated('Use marketFullFeedDescriptor instead')
const MarketFullFeed$json = {
  '1': 'MarketFullFeed',
  '2': [
    {'1': 'ltpc', '3': 1, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.LTPC', '10': 'ltpc'},
    {'1': 'marketLevel', '3': 2, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.MarketLevel', '10': 'marketLevel'},
    {'1': 'optionGreeks', '3': 3, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.OptionGreeks', '10': 'optionGreeks'},
    {'1': 'marketOHLC', '3': 4, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.MarketOHLC', '10': 'marketOHLC'},
    {'1': 'eFeedDetails', '3': 5, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.ExtendedFeedDetails', '10': 'eFeedDetails'},
  ],
};

/// Descriptor for `MarketFullFeed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List marketFullFeedDescriptor = $convert.base64Decode(
    'Cg5NYXJrZXRGdWxsRmVlZBI/CgRsdHBjGAEgASgLMisuY29tLnVwc3RveC5tYXJrZXRkYXRhZm'
    'VlZGVyLnJwYy5wcm90by5MVFBDUgRsdHBjElQKC21hcmtldExldmVsGAIgASgLMjIuY29tLnVw'
    'c3RveC5tYXJrZXRkYXRhZmVlZGVyLnJwYy5wcm90by5NYXJrZXRMZXZlbFILbWFya2V0TGV2ZW'
    'wSVwoMb3B0aW9uR3JlZWtzGAMgASgLMjMuY29tLnVwc3RveC5tYXJrZXRkYXRhZmVlZGVyLnJw'
    'Yy5wcm90by5PcHRpb25HcmVla3NSDG9wdGlvbkdyZWVrcxJRCgptYXJrZXRPSExDGAQgASgLMj'
    'EuY29tLnVwc3RveC5tYXJrZXRkYXRhZmVlZGVyLnJwYy5wcm90by5NYXJrZXRPSExDUgptYXJr'
    'ZXRPSExDEl4KDGVGZWVkRGV0YWlscxgFIAEoCzI6LmNvbS51cHN0b3gubWFya2V0ZGF0YWZlZW'
    'Rlci5ycGMucHJvdG8uRXh0ZW5kZWRGZWVkRGV0YWlsc1IMZUZlZWREZXRhaWxz');

@$core.Deprecated('Use indexFullFeedDescriptor instead')
const IndexFullFeed$json = {
  '1': 'IndexFullFeed',
  '2': [
    {'1': 'ltpc', '3': 1, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.LTPC', '10': 'ltpc'},
    {'1': 'marketOHLC', '3': 2, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.MarketOHLC', '10': 'marketOHLC'},
    {'1': 'lastClose', '3': 3, '4': 1, '5': 1, '10': 'lastClose'},
    {'1': 'yh', '3': 4, '4': 1, '5': 1, '10': 'yh'},
    {'1': 'yl', '3': 5, '4': 1, '5': 1, '10': 'yl'},
  ],
};

/// Descriptor for `IndexFullFeed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List indexFullFeedDescriptor = $convert.base64Decode(
    'Cg1JbmRleEZ1bGxGZWVkEj8KBGx0cGMYASABKAsyKy5jb20udXBzdG94Lm1hcmtldGRhdGFmZW'
    'VkZXIucnBjLnByb3RvLkxUUENSBGx0cGMSUQoKbWFya2V0T0hMQxgCIAEoCzIxLmNvbS51cHN0'
    'b3gubWFya2V0ZGF0YWZlZWRlci5ycGMucHJvdG8uTWFya2V0T0hMQ1IKbWFya2V0T0hMQxIcCg'
    'lsYXN0Q2xvc2UYAyABKAFSCWxhc3RDbG9zZRIOCgJ5aBgEIAEoAVICeWgSDgoCeWwYBSABKAFS'
    'Anls');

@$core.Deprecated('Use fullFeedDescriptor instead')
const FullFeed$json = {
  '1': 'FullFeed',
  '2': [
    {'1': 'marketFF', '3': 1, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.MarketFullFeed', '9': 0, '10': 'marketFF'},
    {'1': 'indexFF', '3': 2, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.IndexFullFeed', '9': 0, '10': 'indexFF'},
  ],
  '8': [
    {'1': 'FullFeedUnion'},
  ],
};

/// Descriptor for `FullFeed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fullFeedDescriptor = $convert.base64Decode(
    'CghGdWxsRmVlZBJTCghtYXJrZXRGRhgBIAEoCzI1LmNvbS51cHN0b3gubWFya2V0ZGF0YWZlZW'
    'Rlci5ycGMucHJvdG8uTWFya2V0RnVsbEZlZWRIAFIIbWFya2V0RkYSUAoHaW5kZXhGRhgCIAEo'
    'CzI0LmNvbS51cHN0b3gubWFya2V0ZGF0YWZlZWRlci5ycGMucHJvdG8uSW5kZXhGdWxsRmVlZE'
    'gAUgdpbmRleEZGQg8KDUZ1bGxGZWVkVW5pb24=');

@$core.Deprecated('Use optionChainDescriptor instead')
const OptionChain$json = {
  '1': 'OptionChain',
  '2': [
    {'1': 'ltpc', '3': 1, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.LTPC', '10': 'ltpc'},
    {'1': 'bidAskQuote', '3': 2, '4': 3, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.Quote', '10': 'bidAskQuote'},
    {'1': 'optionGreeks', '3': 3, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.OptionGreeks', '10': 'optionGreeks'},
    {'1': 'eFeedDetails', '3': 4, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.ExtendedFeedDetails', '10': 'eFeedDetails'},
  ],
};

/// Descriptor for `OptionChain`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List optionChainDescriptor = $convert.base64Decode(
    'CgtPcHRpb25DaGFpbhI/CgRsdHBjGAEgASgLMisuY29tLnVwc3RveC5tYXJrZXRkYXRhZmVlZG'
    'VyLnJwYy5wcm90by5MVFBDUgRsdHBjEk4KC2JpZEFza1F1b3RlGAIgAygLMiwuY29tLnVwc3Rv'
    'eC5tYXJrZXRkYXRhZmVlZGVyLnJwYy5wcm90by5RdW90ZVILYmlkQXNrUXVvdGUSVwoMb3B0aW'
    '9uR3JlZWtzGAMgASgLMjMuY29tLnVwc3RveC5tYXJrZXRkYXRhZmVlZGVyLnJwYy5wcm90by5P'
    'cHRpb25HcmVla3NSDG9wdGlvbkdyZWVrcxJeCgxlRmVlZERldGFpbHMYBCABKAsyOi5jb20udX'
    'BzdG94Lm1hcmtldGRhdGFmZWVkZXIucnBjLnByb3RvLkV4dGVuZGVkRmVlZERldGFpbHNSDGVG'
    'ZWVkRGV0YWlscw==');

@$core.Deprecated('Use feedDescriptor instead')
const Feed$json = {
  '1': 'Feed',
  '2': [
    {'1': 'ltpc', '3': 1, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.LTPC', '9': 0, '10': 'ltpc'},
    {'1': 'ff', '3': 2, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.FullFeed', '9': 0, '10': 'ff'},
    {'1': 'oc', '3': 3, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.OptionChain', '9': 0, '10': 'oc'},
  ],
  '8': [
    {'1': 'FeedUnion'},
  ],
};

/// Descriptor for `Feed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feedDescriptor = $convert.base64Decode(
    'CgRGZWVkEkEKBGx0cGMYASABKAsyKy5jb20udXBzdG94Lm1hcmtldGRhdGFmZWVkZXIucnBjLn'
    'Byb3RvLkxUUENIAFIEbHRwYxJBCgJmZhgCIAEoCzIvLmNvbS51cHN0b3gubWFya2V0ZGF0YWZl'
    'ZWRlci5ycGMucHJvdG8uRnVsbEZlZWRIAFICZmYSRAoCb2MYAyABKAsyMi5jb20udXBzdG94Lm'
    '1hcmtldGRhdGFmZWVkZXIucnBjLnByb3RvLk9wdGlvbkNoYWluSABSAm9jQgsKCUZlZWRVbmlv'
    'bg==');

@$core.Deprecated('Use feedResponseDescriptor instead')
const FeedResponse$json = {
  '1': 'FeedResponse',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.com.upstox.marketdatafeeder.rpc.proto.FeedResponse.Type', '10': 'type'},
    {'1': 'feeds', '3': 2, '4': 3, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.FeedResponse.FeedsEntry', '10': 'feeds'},
  ],
  '3': [FeedResponse_FeedsEntry$json],
  '4': [FeedResponse_Type$json],
};

@$core.Deprecated('Use feedResponseDescriptor instead')
const FeedResponse_FeedsEntry$json = {
  '1': 'FeedsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 11, '6': '.com.upstox.marketdatafeeder.rpc.proto.Feed', '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use feedResponseDescriptor instead')
const FeedResponse_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'initial_feed', '2': 0},
    {'1': 'live_feed', '2': 1},
  ],
};

/// Descriptor for `FeedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List feedResponseDescriptor = $convert.base64Decode(
    'CgxGZWVkUmVzcG9uc2USTAoEdHlwZRgBIAEoDjI4LmNvbS51cHN0b3gubWFya2V0ZGF0YWZlZW'
    'Rlci5ycGMucHJvdG8uRmVlZFJlc3BvbnNlLlR5cGVSBHR5cGUSVAoFZmVlZHMYAiADKAsyPi5j'
    'b20udXBzdG94Lm1hcmtldGRhdGFmZWVkZXIucnBjLnByb3RvLkZlZWRSZXNwb25zZS5GZWVkc0'
    'VudHJ5UgVmZWVkcxplCgpGZWVkc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EkEKBXZhbHVlGAIg'
    'ASgLMisuY29tLnVwc3RveC5tYXJrZXRkYXRhZmVlZGVyLnJwYy5wcm90by5GZWVkUgV2YWx1ZT'
    'oCOAEiJwoEVHlwZRIQCgxpbml0aWFsX2ZlZWQQABINCglsaXZlX2ZlZWQQAQ==');

