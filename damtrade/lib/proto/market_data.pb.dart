//
//  Generated code. Do not modify.
//  source: lib/proto/market_data.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class MarketData extends $pb.GeneratedMessage {
  factory MarketData({
    $core.String? instrumentKey,
    $core.double? lastTradePrice,
  }) {
    final $result = create();
    if (instrumentKey != null) {
      $result.instrumentKey = instrumentKey;
    }
    if (lastTradePrice != null) {
      $result.lastTradePrice = lastTradePrice;
    }
    return $result;
  }
  MarketData._() : super();
  factory MarketData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MarketData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MarketData', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'instrumentKey')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'lastTradePrice', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MarketData clone() => MarketData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MarketData copyWith(void Function(MarketData) updates) => super.copyWith((message) => updates(message as MarketData)) as MarketData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarketData create() => MarketData._();
  MarketData createEmptyInstance() => create();
  static $pb.PbList<MarketData> createRepeated() => $pb.PbList<MarketData>();
  @$core.pragma('dart2js:noInline')
  static MarketData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MarketData>(create);
  static MarketData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get instrumentKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set instrumentKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasInstrumentKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearInstrumentKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get lastTradePrice => $_getN(1);
  @$pb.TagNumber(2)
  set lastTradePrice($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLastTradePrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastTradePrice() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
