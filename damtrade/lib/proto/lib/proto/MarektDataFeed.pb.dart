//
//  Generated code. Do not modify.
//  source: lib/proto/MarektDataFeed.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'MarektDataFeed.pbenum.dart';

export 'MarektDataFeed.pbenum.dart';

class LTPC extends $pb.GeneratedMessage {
  factory LTPC({
    $core.double? ltp,
    $fixnum.Int64? ltt,
    $fixnum.Int64? ltq,
    $core.double? cp,
  }) {
    final $result = create();
    if (ltp != null) {
      $result.ltp = ltp;
    }
    if (ltt != null) {
      $result.ltt = ltt;
    }
    if (ltq != null) {
      $result.ltq = ltq;
    }
    if (cp != null) {
      $result.cp = cp;
    }
    return $result;
  }
  LTPC._() : super();
  factory LTPC.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LTPC.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LTPC', package: const $pb.PackageName(_omitMessageNames ? '' : 'com.upstox.marketdatafeeder.rpc.proto'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'ltp', $pb.PbFieldType.OD)
    ..aInt64(2, _omitFieldNames ? '' : 'ltt')
    ..aInt64(3, _omitFieldNames ? '' : 'ltq')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'cp', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LTPC clone() => LTPC()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LTPC copyWith(void Function(LTPC) updates) => super.copyWith((message) => updates(message as LTPC)) as LTPC;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LTPC create() => LTPC._();
  LTPC createEmptyInstance() => create();
  static $pb.PbList<LTPC> createRepeated() => $pb.PbList<LTPC>();
  @$core.pragma('dart2js:noInline')
  static LTPC getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LTPC>(create);
  static LTPC? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get ltp => $_getN(0);
  @$pb.TagNumber(1)
  set ltp($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLtp() => $_has(0);
  @$pb.TagNumber(1)
  void clearLtp() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get ltt => $_getI64(1);
  @$pb.TagNumber(2)
  set ltt($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLtt() => $_has(1);
  @$pb.TagNumber(2)
  void clearLtt() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get ltq => $_getI64(2);
  @$pb.TagNumber(3)
  set ltq($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLtq() => $_has(2);
  @$pb.TagNumber(3)
  void clearLtq() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get cp => $_getN(3);
  @$pb.TagNumber(4)
  set cp($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCp() => $_has(3);
  @$pb.TagNumber(4)
  void clearCp() => clearField(4);
}

class MarketLevel extends $pb.GeneratedMessage {
  factory MarketLevel({
    $core.Iterable<Quote>? bidAskQuote,
  }) {
    final $result = create();
    if (bidAskQuote != null) {
      $result.bidAskQuote.addAll(bidAskQuote);
    }
    return $result;
  }
  MarketLevel._() : super();
  factory MarketLevel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MarketLevel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MarketLevel', package: const $pb.PackageName(_omitMessageNames ? '' : 'com.upstox.marketdatafeeder.rpc.proto'), createEmptyInstance: create)
    ..pc<Quote>(1, _omitFieldNames ? '' : 'bidAskQuote', $pb.PbFieldType.PM, protoName: 'bidAskQuote', subBuilder: Quote.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MarketLevel clone() => MarketLevel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MarketLevel copyWith(void Function(MarketLevel) updates) => super.copyWith((message) => updates(message as MarketLevel)) as MarketLevel;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarketLevel create() => MarketLevel._();
  MarketLevel createEmptyInstance() => create();
  static $pb.PbList<MarketLevel> createRepeated() => $pb.PbList<MarketLevel>();
  @$core.pragma('dart2js:noInline')
  static MarketLevel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MarketLevel>(create);
  static MarketLevel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Quote> get bidAskQuote => $_getList(0);
}

class MarketOHLC extends $pb.GeneratedMessage {
  factory MarketOHLC({
    $core.Iterable<OHLC>? ohlc,
  }) {
    final $result = create();
    if (ohlc != null) {
      $result.ohlc.addAll(ohlc);
    }
    return $result;
  }
  MarketOHLC._() : super();
  factory MarketOHLC.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MarketOHLC.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MarketOHLC', package: const $pb.PackageName(_omitMessageNames ? '' : 'com.upstox.marketdatafeeder.rpc.proto'), createEmptyInstance: create)
    ..pc<OHLC>(1, _omitFieldNames ? '' : 'ohlc', $pb.PbFieldType.PM, subBuilder: OHLC.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MarketOHLC clone() => MarketOHLC()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MarketOHLC copyWith(void Function(MarketOHLC) updates) => super.copyWith((message) => updates(message as MarketOHLC)) as MarketOHLC;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarketOHLC create() => MarketOHLC._();
  MarketOHLC createEmptyInstance() => create();
  static $pb.PbList<MarketOHLC> createRepeated() => $pb.PbList<MarketOHLC>();
  @$core.pragma('dart2js:noInline')
  static MarketOHLC getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MarketOHLC>(create);
  static MarketOHLC? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<OHLC> get ohlc => $_getList(0);
}

class Quote extends $pb.GeneratedMessage {
  factory Quote({
    $core.int? bq,
    $core.double? bp,
    $core.int? bno,
    $core.int? aq,
    $core.double? ap,
    $core.int? ano,
  }) {
    final $result = create();
    if (bq != null) {
      $result.bq = bq;
    }
    if (bp != null) {
      $result.bp = bp;
    }
    if (bno != null) {
      $result.bno = bno;
    }
    if (aq != null) {
      $result.aq = aq;
    }
    if (ap != null) {
      $result.ap = ap;
    }
    if (ano != null) {
      $result.ano = ano;
    }
    return $result;
  }
  Quote._() : super();
  factory Quote.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Quote.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Quote', package: const $pb.PackageName(_omitMessageNames ? '' : 'com.upstox.marketdatafeeder.rpc.proto'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'bq', $pb.PbFieldType.O3)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'bp', $pb.PbFieldType.OD)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'bno', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'aq', $pb.PbFieldType.O3)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'ap', $pb.PbFieldType.OD)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'ano', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Quote clone() => Quote()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Quote copyWith(void Function(Quote) updates) => super.copyWith((message) => updates(message as Quote)) as Quote;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Quote create() => Quote._();
  Quote createEmptyInstance() => create();
  static $pb.PbList<Quote> createRepeated() => $pb.PbList<Quote>();
  @$core.pragma('dart2js:noInline')
  static Quote getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Quote>(create);
  static Quote? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get bq => $_getIZ(0);
  @$pb.TagNumber(1)
  set bq($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBq() => $_has(0);
  @$pb.TagNumber(1)
  void clearBq() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get bp => $_getN(1);
  @$pb.TagNumber(2)
  set bp($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBp() => $_has(1);
  @$pb.TagNumber(2)
  void clearBp() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get bno => $_getIZ(2);
  @$pb.TagNumber(3)
  set bno($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBno() => $_has(2);
  @$pb.TagNumber(3)
  void clearBno() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get aq => $_getIZ(3);
  @$pb.TagNumber(4)
  set aq($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAq() => $_has(3);
  @$pb.TagNumber(4)
  void clearAq() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get ap => $_getN(4);
  @$pb.TagNumber(5)
  set ap($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAp() => $_has(4);
  @$pb.TagNumber(5)
  void clearAp() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get ano => $_getIZ(5);
  @$pb.TagNumber(6)
  set ano($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAno() => $_has(5);
  @$pb.TagNumber(6)
  void clearAno() => clearField(6);
}

class OptionGreeks extends $pb.GeneratedMessage {
  factory OptionGreeks({
    $core.double? op,
    $core.double? up,
    $core.double? iv,
    $core.double? delta,
    $core.double? theta,
    $core.double? gamma,
    $core.double? vega,
    $core.double? rho,
  }) {
    final $result = create();
    if (op != null) {
      $result.op = op;
    }
    if (up != null) {
      $result.up = up;
    }
    if (iv != null) {
      $result.iv = iv;
    }
    if (delta != null) {
      $result.delta = delta;
    }
    if (theta != null) {
      $result.theta = theta;
    }
    if (gamma != null) {
      $result.gamma = gamma;
    }
    if (vega != null) {
      $result.vega = vega;
    }
    if (rho != null) {
      $result.rho = rho;
    }
    return $result;
  }
  OptionGreeks._() : super();
  factory OptionGreeks.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OptionGreeks.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OptionGreeks', package: const $pb.PackageName(_omitMessageNames ? '' : 'com.upstox.marketdatafeeder.rpc.proto'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'op', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'up', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'iv', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'delta', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'theta', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'gamma', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'vega', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'rho', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OptionGreeks clone() => OptionGreeks()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OptionGreeks copyWith(void Function(OptionGreeks) updates) => super.copyWith((message) => updates(message as OptionGreeks)) as OptionGreeks;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OptionGreeks create() => OptionGreeks._();
  OptionGreeks createEmptyInstance() => create();
  static $pb.PbList<OptionGreeks> createRepeated() => $pb.PbList<OptionGreeks>();
  @$core.pragma('dart2js:noInline')
  static OptionGreeks getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OptionGreeks>(create);
  static OptionGreeks? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get op => $_getN(0);
  @$pb.TagNumber(1)
  set op($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOp() => $_has(0);
  @$pb.TagNumber(1)
  void clearOp() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get up => $_getN(1);
  @$pb.TagNumber(2)
  set up($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUp() => $_has(1);
  @$pb.TagNumber(2)
  void clearUp() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get iv => $_getN(2);
  @$pb.TagNumber(3)
  set iv($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIv() => $_has(2);
  @$pb.TagNumber(3)
  void clearIv() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get delta => $_getN(3);
  @$pb.TagNumber(4)
  set delta($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDelta() => $_has(3);
  @$pb.TagNumber(4)
  void clearDelta() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get theta => $_getN(4);
  @$pb.TagNumber(5)
  set theta($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTheta() => $_has(4);
  @$pb.TagNumber(5)
  void clearTheta() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get gamma => $_getN(5);
  @$pb.TagNumber(6)
  set gamma($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasGamma() => $_has(5);
  @$pb.TagNumber(6)
  void clearGamma() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get vega => $_getN(6);
  @$pb.TagNumber(7)
  set vega($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasVega() => $_has(6);
  @$pb.TagNumber(7)
  void clearVega() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get rho => $_getN(7);
  @$pb.TagNumber(8)
  set rho($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasRho() => $_has(7);
  @$pb.TagNumber(8)
  void clearRho() => clearField(8);
}

class ExtendedFeedDetails extends $pb.GeneratedMessage {
  factory ExtendedFeedDetails({
    $core.double? atp,
    $core.double? cp,
    $fixnum.Int64? vtt,
    $core.double? oi,
    $core.double? changeOi,
    $core.double? lastClose,
    $core.double? tbq,
    $core.double? tsq,
    $core.double? close,
    $core.double? lc,
    $core.double? uc,
    $core.double? yh,
    $core.double? yl,
    $core.double? fp,
    $core.int? fv,
    $fixnum.Int64? mbpBuy,
    $fixnum.Int64? mbpSell,
    $fixnum.Int64? tv,
    $core.double? dhoi,
    $core.double? dloi,
    $core.double? sp,
    $core.double? poi,
  }) {
    final $result = create();
    if (atp != null) {
      $result.atp = atp;
    }
    if (cp != null) {
      $result.cp = cp;
    }
    if (vtt != null) {
      $result.vtt = vtt;
    }
    if (oi != null) {
      $result.oi = oi;
    }
    if (changeOi != null) {
      $result.changeOi = changeOi;
    }
    if (lastClose != null) {
      $result.lastClose = lastClose;
    }
    if (tbq != null) {
      $result.tbq = tbq;
    }
    if (tsq != null) {
      $result.tsq = tsq;
    }
    if (close != null) {
      $result.close = close;
    }
    if (lc != null) {
      $result.lc = lc;
    }
    if (uc != null) {
      $result.uc = uc;
    }
    if (yh != null) {
      $result.yh = yh;
    }
    if (yl != null) {
      $result.yl = yl;
    }
    if (fp != null) {
      $result.fp = fp;
    }
    if (fv != null) {
      $result.fv = fv;
    }
    if (mbpBuy != null) {
      $result.mbpBuy = mbpBuy;
    }
    if (mbpSell != null) {
      $result.mbpSell = mbpSell;
    }
    if (tv != null) {
      $result.tv = tv;
    }
    if (dhoi != null) {
      $result.dhoi = dhoi;
    }
    if (dloi != null) {
      $result.dloi = dloi;
    }
    if (sp != null) {
      $result.sp = sp;
    }
    if (poi != null) {
      $result.poi = poi;
    }
    return $result;
  }
  ExtendedFeedDetails._() : super();
  factory ExtendedFeedDetails.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExtendedFeedDetails.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExtendedFeedDetails', package: const $pb.PackageName(_omitMessageNames ? '' : 'com.upstox.marketdatafeeder.rpc.proto'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'atp', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'cp', $pb.PbFieldType.OD)
    ..aInt64(3, _omitFieldNames ? '' : 'vtt')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'oi', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'changeOi', $pb.PbFieldType.OD, protoName: 'changeOi')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'lastClose', $pb.PbFieldType.OD, protoName: 'lastClose')
    ..a<$core.double>(7, _omitFieldNames ? '' : 'tbq', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'tsq', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'close', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'lc', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'uc', $pb.PbFieldType.OD)
    ..a<$core.double>(12, _omitFieldNames ? '' : 'yh', $pb.PbFieldType.OD)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'yl', $pb.PbFieldType.OD)
    ..a<$core.double>(14, _omitFieldNames ? '' : 'fp', $pb.PbFieldType.OD)
    ..a<$core.int>(15, _omitFieldNames ? '' : 'fv', $pb.PbFieldType.O3)
    ..aInt64(16, _omitFieldNames ? '' : 'mbpBuy', protoName: 'mbpBuy')
    ..aInt64(17, _omitFieldNames ? '' : 'mbpSell', protoName: 'mbpSell')
    ..aInt64(18, _omitFieldNames ? '' : 'tv')
    ..a<$core.double>(19, _omitFieldNames ? '' : 'dhoi', $pb.PbFieldType.OD)
    ..a<$core.double>(20, _omitFieldNames ? '' : 'dloi', $pb.PbFieldType.OD)
    ..a<$core.double>(21, _omitFieldNames ? '' : 'sp', $pb.PbFieldType.OD)
    ..a<$core.double>(22, _omitFieldNames ? '' : 'poi', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExtendedFeedDetails clone() => ExtendedFeedDetails()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExtendedFeedDetails copyWith(void Function(ExtendedFeedDetails) updates) => super.copyWith((message) => updates(message as ExtendedFeedDetails)) as ExtendedFeedDetails;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExtendedFeedDetails create() => ExtendedFeedDetails._();
  ExtendedFeedDetails createEmptyInstance() => create();
  static $pb.PbList<ExtendedFeedDetails> createRepeated() => $pb.PbList<ExtendedFeedDetails>();
  @$core.pragma('dart2js:noInline')
  static ExtendedFeedDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExtendedFeedDetails>(create);
  static ExtendedFeedDetails? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get atp => $_getN(0);
  @$pb.TagNumber(1)
  set atp($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAtp() => $_has(0);
  @$pb.TagNumber(1)
  void clearAtp() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get cp => $_getN(1);
  @$pb.TagNumber(2)
  set cp($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCp() => $_has(1);
  @$pb.TagNumber(2)
  void clearCp() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get vtt => $_getI64(2);
  @$pb.TagNumber(3)
  set vtt($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVtt() => $_has(2);
  @$pb.TagNumber(3)
  void clearVtt() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get oi => $_getN(3);
  @$pb.TagNumber(4)
  set oi($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOi() => $_has(3);
  @$pb.TagNumber(4)
  void clearOi() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get changeOi => $_getN(4);
  @$pb.TagNumber(5)
  set changeOi($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasChangeOi() => $_has(4);
  @$pb.TagNumber(5)
  void clearChangeOi() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get lastClose => $_getN(5);
  @$pb.TagNumber(6)
  set lastClose($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLastClose() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastClose() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get tbq => $_getN(6);
  @$pb.TagNumber(7)
  set tbq($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTbq() => $_has(6);
  @$pb.TagNumber(7)
  void clearTbq() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get tsq => $_getN(7);
  @$pb.TagNumber(8)
  set tsq($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTsq() => $_has(7);
  @$pb.TagNumber(8)
  void clearTsq() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get close => $_getN(8);
  @$pb.TagNumber(9)
  set close($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasClose() => $_has(8);
  @$pb.TagNumber(9)
  void clearClose() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get lc => $_getN(9);
  @$pb.TagNumber(10)
  set lc($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasLc() => $_has(9);
  @$pb.TagNumber(10)
  void clearLc() => clearField(10);

  @$pb.TagNumber(11)
  $core.double get uc => $_getN(10);
  @$pb.TagNumber(11)
  set uc($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasUc() => $_has(10);
  @$pb.TagNumber(11)
  void clearUc() => clearField(11);

  @$pb.TagNumber(12)
  $core.double get yh => $_getN(11);
  @$pb.TagNumber(12)
  set yh($core.double v) { $_setDouble(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasYh() => $_has(11);
  @$pb.TagNumber(12)
  void clearYh() => clearField(12);

  @$pb.TagNumber(13)
  $core.double get yl => $_getN(12);
  @$pb.TagNumber(13)
  set yl($core.double v) { $_setDouble(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasYl() => $_has(12);
  @$pb.TagNumber(13)
  void clearYl() => clearField(13);

  @$pb.TagNumber(14)
  $core.double get fp => $_getN(13);
  @$pb.TagNumber(14)
  set fp($core.double v) { $_setDouble(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasFp() => $_has(13);
  @$pb.TagNumber(14)
  void clearFp() => clearField(14);

  @$pb.TagNumber(15)
  $core.int get fv => $_getIZ(14);
  @$pb.TagNumber(15)
  set fv($core.int v) { $_setSignedInt32(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasFv() => $_has(14);
  @$pb.TagNumber(15)
  void clearFv() => clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get mbpBuy => $_getI64(15);
  @$pb.TagNumber(16)
  set mbpBuy($fixnum.Int64 v) { $_setInt64(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasMbpBuy() => $_has(15);
  @$pb.TagNumber(16)
  void clearMbpBuy() => clearField(16);

  @$pb.TagNumber(17)
  $fixnum.Int64 get mbpSell => $_getI64(16);
  @$pb.TagNumber(17)
  set mbpSell($fixnum.Int64 v) { $_setInt64(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasMbpSell() => $_has(16);
  @$pb.TagNumber(17)
  void clearMbpSell() => clearField(17);

  @$pb.TagNumber(18)
  $fixnum.Int64 get tv => $_getI64(17);
  @$pb.TagNumber(18)
  set tv($fixnum.Int64 v) { $_setInt64(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasTv() => $_has(17);
  @$pb.TagNumber(18)
  void clearTv() => clearField(18);

  @$pb.TagNumber(19)
  $core.double get dhoi => $_getN(18);
  @$pb.TagNumber(19)
  set dhoi($core.double v) { $_setDouble(18, v); }
  @$pb.TagNumber(19)
  $core.bool hasDhoi() => $_has(18);
  @$pb.TagNumber(19)
  void clearDhoi() => clearField(19);

  @$pb.TagNumber(20)
  $core.double get dloi => $_getN(19);
  @$pb.TagNumber(20)
  set dloi($core.double v) { $_setDouble(19, v); }
  @$pb.TagNumber(20)
  $core.bool hasDloi() => $_has(19);
  @$pb.TagNumber(20)
  void clearDloi() => clearField(20);

  @$pb.TagNumber(21)
  $core.double get sp => $_getN(20);
  @$pb.TagNumber(21)
  set sp($core.double v) { $_setDouble(20, v); }
  @$pb.TagNumber(21)
  $core.bool hasSp() => $_has(20);
  @$pb.TagNumber(21)
  void clearSp() => clearField(21);

  @$pb.TagNumber(22)
  $core.double get poi => $_getN(21);
  @$pb.TagNumber(22)
  set poi($core.double v) { $_setDouble(21, v); }
  @$pb.TagNumber(22)
  $core.bool hasPoi() => $_has(21);
  @$pb.TagNumber(22)
  void clearPoi() => clearField(22);
}

class OHLC extends $pb.GeneratedMessage {
  factory OHLC({
    $core.String? interval,
    $core.double? open,
    $core.double? high,
    $core.double? low,
    $core.double? close,
    $core.int? volume,
    $fixnum.Int64? ts,
  }) {
    final $result = create();
    if (interval != null) {
      $result.interval = interval;
    }
    if (open != null) {
      $result.open = open;
    }
    if (high != null) {
      $result.high = high;
    }
    if (low != null) {
      $result.low = low;
    }
    if (close != null) {
      $result.close = close;
    }
    if (volume != null) {
      $result.volume = volume;
    }
    if (ts != null) {
      $result.ts = ts;
    }
    return $result;
  }
  OHLC._() : super();
  factory OHLC.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OHLC.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OHLC', package: const $pb.PackageName(_omitMessageNames ? '' : 'com.upstox.marketdatafeeder.rpc.proto'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'interval')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'open', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'high', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'low', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'close', $pb.PbFieldType.OD)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'volume', $pb.PbFieldType.O3)
    ..aInt64(7, _omitFieldNames ? '' : 'ts')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OHLC clone() => OHLC()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OHLC copyWith(void Function(OHLC) updates) => super.copyWith((message) => updates(message as OHLC)) as OHLC;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OHLC create() => OHLC._();
  OHLC createEmptyInstance() => create();
  static $pb.PbList<OHLC> createRepeated() => $pb.PbList<OHLC>();
  @$core.pragma('dart2js:noInline')
  static OHLC getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OHLC>(create);
  static OHLC? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get interval => $_getSZ(0);
  @$pb.TagNumber(1)
  set interval($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasInterval() => $_has(0);
  @$pb.TagNumber(1)
  void clearInterval() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get open => $_getN(1);
  @$pb.TagNumber(2)
  set open($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOpen() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpen() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get high => $_getN(2);
  @$pb.TagNumber(3)
  set high($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHigh() => $_has(2);
  @$pb.TagNumber(3)
  void clearHigh() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get low => $_getN(3);
  @$pb.TagNumber(4)
  set low($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLow() => $_has(3);
  @$pb.TagNumber(4)
  void clearLow() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get close => $_getN(4);
  @$pb.TagNumber(5)
  set close($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasClose() => $_has(4);
  @$pb.TagNumber(5)
  void clearClose() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get volume => $_getIZ(5);
  @$pb.TagNumber(6)
  set volume($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasVolume() => $_has(5);
  @$pb.TagNumber(6)
  void clearVolume() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get ts => $_getI64(6);
  @$pb.TagNumber(7)
  set ts($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTs() => $_has(6);
  @$pb.TagNumber(7)
  void clearTs() => clearField(7);
}

class MarketFullFeed extends $pb.GeneratedMessage {
  factory MarketFullFeed({
    LTPC? ltpc,
    MarketLevel? marketLevel,
    OptionGreeks? optionGreeks,
    MarketOHLC? marketOHLC,
    ExtendedFeedDetails? eFeedDetails,
  }) {
    final $result = create();
    if (ltpc != null) {
      $result.ltpc = ltpc;
    }
    if (marketLevel != null) {
      $result.marketLevel = marketLevel;
    }
    if (optionGreeks != null) {
      $result.optionGreeks = optionGreeks;
    }
    if (marketOHLC != null) {
      $result.marketOHLC = marketOHLC;
    }
    if (eFeedDetails != null) {
      $result.eFeedDetails = eFeedDetails;
    }
    return $result;
  }
  MarketFullFeed._() : super();
  factory MarketFullFeed.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MarketFullFeed.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MarketFullFeed', package: const $pb.PackageName(_omitMessageNames ? '' : 'com.upstox.marketdatafeeder.rpc.proto'), createEmptyInstance: create)
    ..aOM<LTPC>(1, _omitFieldNames ? '' : 'ltpc', subBuilder: LTPC.create)
    ..aOM<MarketLevel>(2, _omitFieldNames ? '' : 'marketLevel', protoName: 'marketLevel', subBuilder: MarketLevel.create)
    ..aOM<OptionGreeks>(3, _omitFieldNames ? '' : 'optionGreeks', protoName: 'optionGreeks', subBuilder: OptionGreeks.create)
    ..aOM<MarketOHLC>(4, _omitFieldNames ? '' : 'marketOHLC', protoName: 'marketOHLC', subBuilder: MarketOHLC.create)
    ..aOM<ExtendedFeedDetails>(5, _omitFieldNames ? '' : 'eFeedDetails', protoName: 'eFeedDetails', subBuilder: ExtendedFeedDetails.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MarketFullFeed clone() => MarketFullFeed()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MarketFullFeed copyWith(void Function(MarketFullFeed) updates) => super.copyWith((message) => updates(message as MarketFullFeed)) as MarketFullFeed;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MarketFullFeed create() => MarketFullFeed._();
  MarketFullFeed createEmptyInstance() => create();
  static $pb.PbList<MarketFullFeed> createRepeated() => $pb.PbList<MarketFullFeed>();
  @$core.pragma('dart2js:noInline')
  static MarketFullFeed getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MarketFullFeed>(create);
  static MarketFullFeed? _defaultInstance;

  @$pb.TagNumber(1)
  LTPC get ltpc => $_getN(0);
  @$pb.TagNumber(1)
  set ltpc(LTPC v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLtpc() => $_has(0);
  @$pb.TagNumber(1)
  void clearLtpc() => clearField(1);
  @$pb.TagNumber(1)
  LTPC ensureLtpc() => $_ensure(0);

  @$pb.TagNumber(2)
  MarketLevel get marketLevel => $_getN(1);
  @$pb.TagNumber(2)
  set marketLevel(MarketLevel v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasMarketLevel() => $_has(1);
  @$pb.TagNumber(2)
  void clearMarketLevel() => clearField(2);
  @$pb.TagNumber(2)
  MarketLevel ensureMarketLevel() => $_ensure(1);

  @$pb.TagNumber(3)
  OptionGreeks get optionGreeks => $_getN(2);
  @$pb.TagNumber(3)
  set optionGreeks(OptionGreeks v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasOptionGreeks() => $_has(2);
  @$pb.TagNumber(3)
  void clearOptionGreeks() => clearField(3);
  @$pb.TagNumber(3)
  OptionGreeks ensureOptionGreeks() => $_ensure(2);

  @$pb.TagNumber(4)
  MarketOHLC get marketOHLC => $_getN(3);
  @$pb.TagNumber(4)
  set marketOHLC(MarketOHLC v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasMarketOHLC() => $_has(3);
  @$pb.TagNumber(4)
  void clearMarketOHLC() => clearField(4);
  @$pb.TagNumber(4)
  MarketOHLC ensureMarketOHLC() => $_ensure(3);

  @$pb.TagNumber(5)
  ExtendedFeedDetails get eFeedDetails => $_getN(4);
  @$pb.TagNumber(5)
  set eFeedDetails(ExtendedFeedDetails v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasEFeedDetails() => $_has(4);
  @$pb.TagNumber(5)
  void clearEFeedDetails() => clearField(5);
  @$pb.TagNumber(5)
  ExtendedFeedDetails ensureEFeedDetails() => $_ensure(4);
}

class IndexFullFeed extends $pb.GeneratedMessage {
  factory IndexFullFeed({
    LTPC? ltpc,
    MarketOHLC? marketOHLC,
    $core.double? lastClose,
    $core.double? yh,
    $core.double? yl,
  }) {
    final $result = create();
    if (ltpc != null) {
      $result.ltpc = ltpc;
    }
    if (marketOHLC != null) {
      $result.marketOHLC = marketOHLC;
    }
    if (lastClose != null) {
      $result.lastClose = lastClose;
    }
    if (yh != null) {
      $result.yh = yh;
    }
    if (yl != null) {
      $result.yl = yl;
    }
    return $result;
  }
  IndexFullFeed._() : super();
  factory IndexFullFeed.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IndexFullFeed.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'IndexFullFeed', package: const $pb.PackageName(_omitMessageNames ? '' : 'com.upstox.marketdatafeeder.rpc.proto'), createEmptyInstance: create)
    ..aOM<LTPC>(1, _omitFieldNames ? '' : 'ltpc', subBuilder: LTPC.create)
    ..aOM<MarketOHLC>(2, _omitFieldNames ? '' : 'marketOHLC', protoName: 'marketOHLC', subBuilder: MarketOHLC.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'lastClose', $pb.PbFieldType.OD, protoName: 'lastClose')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'yh', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'yl', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IndexFullFeed clone() => IndexFullFeed()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IndexFullFeed copyWith(void Function(IndexFullFeed) updates) => super.copyWith((message) => updates(message as IndexFullFeed)) as IndexFullFeed;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IndexFullFeed create() => IndexFullFeed._();
  IndexFullFeed createEmptyInstance() => create();
  static $pb.PbList<IndexFullFeed> createRepeated() => $pb.PbList<IndexFullFeed>();
  @$core.pragma('dart2js:noInline')
  static IndexFullFeed getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IndexFullFeed>(create);
  static IndexFullFeed? _defaultInstance;

  @$pb.TagNumber(1)
  LTPC get ltpc => $_getN(0);
  @$pb.TagNumber(1)
  set ltpc(LTPC v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLtpc() => $_has(0);
  @$pb.TagNumber(1)
  void clearLtpc() => clearField(1);
  @$pb.TagNumber(1)
  LTPC ensureLtpc() => $_ensure(0);

  @$pb.TagNumber(2)
  MarketOHLC get marketOHLC => $_getN(1);
  @$pb.TagNumber(2)
  set marketOHLC(MarketOHLC v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasMarketOHLC() => $_has(1);
  @$pb.TagNumber(2)
  void clearMarketOHLC() => clearField(2);
  @$pb.TagNumber(2)
  MarketOHLC ensureMarketOHLC() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.double get lastClose => $_getN(2);
  @$pb.TagNumber(3)
  set lastClose($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLastClose() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastClose() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get yh => $_getN(3);
  @$pb.TagNumber(4)
  set yh($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasYh() => $_has(3);
  @$pb.TagNumber(4)
  void clearYh() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get yl => $_getN(4);
  @$pb.TagNumber(5)
  set yl($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasYl() => $_has(4);
  @$pb.TagNumber(5)
  void clearYl() => clearField(5);
}

enum FullFeed_FullFeedUnion {
  marketFF, 
  indexFF, 
  notSet
}

class FullFeed extends $pb.GeneratedMessage {
  factory FullFeed({
    MarketFullFeed? marketFF,
    IndexFullFeed? indexFF,
  }) {
    final $result = create();
    if (marketFF != null) {
      $result.marketFF = marketFF;
    }
    if (indexFF != null) {
      $result.indexFF = indexFF;
    }
    return $result;
  }
  FullFeed._() : super();
  factory FullFeed.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FullFeed.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, FullFeed_FullFeedUnion> _FullFeed_FullFeedUnionByTag = {
    1 : FullFeed_FullFeedUnion.marketFF,
    2 : FullFeed_FullFeedUnion.indexFF,
    0 : FullFeed_FullFeedUnion.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FullFeed', package: const $pb.PackageName(_omitMessageNames ? '' : 'com.upstox.marketdatafeeder.rpc.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<MarketFullFeed>(1, _omitFieldNames ? '' : 'marketFF', protoName: 'marketFF', subBuilder: MarketFullFeed.create)
    ..aOM<IndexFullFeed>(2, _omitFieldNames ? '' : 'indexFF', protoName: 'indexFF', subBuilder: IndexFullFeed.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FullFeed clone() => FullFeed()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FullFeed copyWith(void Function(FullFeed) updates) => super.copyWith((message) => updates(message as FullFeed)) as FullFeed;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FullFeed create() => FullFeed._();
  FullFeed createEmptyInstance() => create();
  static $pb.PbList<FullFeed> createRepeated() => $pb.PbList<FullFeed>();
  @$core.pragma('dart2js:noInline')
  static FullFeed getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FullFeed>(create);
  static FullFeed? _defaultInstance;

  FullFeed_FullFeedUnion whichFullFeedUnion() => _FullFeed_FullFeedUnionByTag[$_whichOneof(0)]!;
  void clearFullFeedUnion() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  MarketFullFeed get marketFF => $_getN(0);
  @$pb.TagNumber(1)
  set marketFF(MarketFullFeed v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasMarketFF() => $_has(0);
  @$pb.TagNumber(1)
  void clearMarketFF() => clearField(1);
  @$pb.TagNumber(1)
  MarketFullFeed ensureMarketFF() => $_ensure(0);

  @$pb.TagNumber(2)
  IndexFullFeed get indexFF => $_getN(1);
  @$pb.TagNumber(2)
  set indexFF(IndexFullFeed v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasIndexFF() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndexFF() => clearField(2);
  @$pb.TagNumber(2)
  IndexFullFeed ensureIndexFF() => $_ensure(1);
}

class OptionChain extends $pb.GeneratedMessage {
  factory OptionChain({
    LTPC? ltpc,
    $core.Iterable<Quote>? bidAskQuote,
    OptionGreeks? optionGreeks,
    ExtendedFeedDetails? eFeedDetails,
  }) {
    final $result = create();
    if (ltpc != null) {
      $result.ltpc = ltpc;
    }
    if (bidAskQuote != null) {
      $result.bidAskQuote.addAll(bidAskQuote);
    }
    if (optionGreeks != null) {
      $result.optionGreeks = optionGreeks;
    }
    if (eFeedDetails != null) {
      $result.eFeedDetails = eFeedDetails;
    }
    return $result;
  }
  OptionChain._() : super();
  factory OptionChain.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OptionChain.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OptionChain', package: const $pb.PackageName(_omitMessageNames ? '' : 'com.upstox.marketdatafeeder.rpc.proto'), createEmptyInstance: create)
    ..aOM<LTPC>(1, _omitFieldNames ? '' : 'ltpc', subBuilder: LTPC.create)
    ..pc<Quote>(2, _omitFieldNames ? '' : 'bidAskQuote', $pb.PbFieldType.PM, protoName: 'bidAskQuote', subBuilder: Quote.create)
    ..aOM<OptionGreeks>(3, _omitFieldNames ? '' : 'optionGreeks', protoName: 'optionGreeks', subBuilder: OptionGreeks.create)
    ..aOM<ExtendedFeedDetails>(4, _omitFieldNames ? '' : 'eFeedDetails', protoName: 'eFeedDetails', subBuilder: ExtendedFeedDetails.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OptionChain clone() => OptionChain()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OptionChain copyWith(void Function(OptionChain) updates) => super.copyWith((message) => updates(message as OptionChain)) as OptionChain;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OptionChain create() => OptionChain._();
  OptionChain createEmptyInstance() => create();
  static $pb.PbList<OptionChain> createRepeated() => $pb.PbList<OptionChain>();
  @$core.pragma('dart2js:noInline')
  static OptionChain getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OptionChain>(create);
  static OptionChain? _defaultInstance;

  @$pb.TagNumber(1)
  LTPC get ltpc => $_getN(0);
  @$pb.TagNumber(1)
  set ltpc(LTPC v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLtpc() => $_has(0);
  @$pb.TagNumber(1)
  void clearLtpc() => clearField(1);
  @$pb.TagNumber(1)
  LTPC ensureLtpc() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<Quote> get bidAskQuote => $_getList(1);

  @$pb.TagNumber(3)
  OptionGreeks get optionGreeks => $_getN(2);
  @$pb.TagNumber(3)
  set optionGreeks(OptionGreeks v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasOptionGreeks() => $_has(2);
  @$pb.TagNumber(3)
  void clearOptionGreeks() => clearField(3);
  @$pb.TagNumber(3)
  OptionGreeks ensureOptionGreeks() => $_ensure(2);

  @$pb.TagNumber(4)
  ExtendedFeedDetails get eFeedDetails => $_getN(3);
  @$pb.TagNumber(4)
  set eFeedDetails(ExtendedFeedDetails v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasEFeedDetails() => $_has(3);
  @$pb.TagNumber(4)
  void clearEFeedDetails() => clearField(4);
  @$pb.TagNumber(4)
  ExtendedFeedDetails ensureEFeedDetails() => $_ensure(3);
}

enum Feed_FeedUnion {
  ltpc, 
  ff, 
  oc, 
  notSet
}

class Feed extends $pb.GeneratedMessage {
  factory Feed({
    LTPC? ltpc,
    FullFeed? ff,
    OptionChain? oc,
  }) {
    final $result = create();
    if (ltpc != null) {
      $result.ltpc = ltpc;
    }
    if (ff != null) {
      $result.ff = ff;
    }
    if (oc != null) {
      $result.oc = oc;
    }
    return $result;
  }
  Feed._() : super();
  factory Feed.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Feed.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Feed_FeedUnion> _Feed_FeedUnionByTag = {
    1 : Feed_FeedUnion.ltpc,
    2 : Feed_FeedUnion.ff,
    3 : Feed_FeedUnion.oc,
    0 : Feed_FeedUnion.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Feed', package: const $pb.PackageName(_omitMessageNames ? '' : 'com.upstox.marketdatafeeder.rpc.proto'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<LTPC>(1, _omitFieldNames ? '' : 'ltpc', subBuilder: LTPC.create)
    ..aOM<FullFeed>(2, _omitFieldNames ? '' : 'ff', subBuilder: FullFeed.create)
    ..aOM<OptionChain>(3, _omitFieldNames ? '' : 'oc', subBuilder: OptionChain.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Feed clone() => Feed()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Feed copyWith(void Function(Feed) updates) => super.copyWith((message) => updates(message as Feed)) as Feed;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Feed create() => Feed._();
  Feed createEmptyInstance() => create();
  static $pb.PbList<Feed> createRepeated() => $pb.PbList<Feed>();
  @$core.pragma('dart2js:noInline')
  static Feed getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Feed>(create);
  static Feed? _defaultInstance;

  Feed_FeedUnion whichFeedUnion() => _Feed_FeedUnionByTag[$_whichOneof(0)]!;
  void clearFeedUnion() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  LTPC get ltpc => $_getN(0);
  @$pb.TagNumber(1)
  set ltpc(LTPC v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLtpc() => $_has(0);
  @$pb.TagNumber(1)
  void clearLtpc() => clearField(1);
  @$pb.TagNumber(1)
  LTPC ensureLtpc() => $_ensure(0);

  @$pb.TagNumber(2)
  FullFeed get ff => $_getN(1);
  @$pb.TagNumber(2)
  set ff(FullFeed v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFf() => $_has(1);
  @$pb.TagNumber(2)
  void clearFf() => clearField(2);
  @$pb.TagNumber(2)
  FullFeed ensureFf() => $_ensure(1);

  @$pb.TagNumber(3)
  OptionChain get oc => $_getN(2);
  @$pb.TagNumber(3)
  set oc(OptionChain v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasOc() => $_has(2);
  @$pb.TagNumber(3)
  void clearOc() => clearField(3);
  @$pb.TagNumber(3)
  OptionChain ensureOc() => $_ensure(2);
}

class FeedResponse extends $pb.GeneratedMessage {
  factory FeedResponse({
    FeedResponse_Type? type,
    $core.Map<$core.String, Feed>? feeds,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (feeds != null) {
      $result.feeds.addAll(feeds);
    }
    return $result;
  }
  FeedResponse._() : super();
  factory FeedResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeedResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FeedResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'com.upstox.marketdatafeeder.rpc.proto'), createEmptyInstance: create)
    ..e<FeedResponse_Type>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: FeedResponse_Type.initial_feed, valueOf: FeedResponse_Type.valueOf, enumValues: FeedResponse_Type.values)
    ..m<$core.String, Feed>(2, _omitFieldNames ? '' : 'feeds', entryClassName: 'FeedResponse.FeedsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OM, valueCreator: Feed.create, valueDefaultOrMaker: Feed.getDefault, packageName: const $pb.PackageName('com.upstox.marketdatafeeder.rpc.proto'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FeedResponse clone() => FeedResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FeedResponse copyWith(void Function(FeedResponse) updates) => super.copyWith((message) => updates(message as FeedResponse)) as FeedResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FeedResponse create() => FeedResponse._();
  FeedResponse createEmptyInstance() => create();
  static $pb.PbList<FeedResponse> createRepeated() => $pb.PbList<FeedResponse>();
  @$core.pragma('dart2js:noInline')
  static FeedResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeedResponse>(create);
  static FeedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FeedResponse_Type get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(FeedResponse_Type v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.Map<$core.String, Feed> get feeds => $_getMap(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
