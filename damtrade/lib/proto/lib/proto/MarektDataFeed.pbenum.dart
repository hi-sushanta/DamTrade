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

import 'package:protobuf/protobuf.dart' as $pb;

class FeedResponse_Type extends $pb.ProtobufEnum {
  static const FeedResponse_Type initial_feed = FeedResponse_Type._(0, _omitEnumNames ? '' : 'initial_feed');
  static const FeedResponse_Type live_feed = FeedResponse_Type._(1, _omitEnumNames ? '' : 'live_feed');

  static const $core.List<FeedResponse_Type> values = <FeedResponse_Type> [
    initial_feed,
    live_feed,
  ];

  static final $core.Map<$core.int, FeedResponse_Type> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FeedResponse_Type? valueOf($core.int value) => _byValue[value];

  const FeedResponse_Type._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
