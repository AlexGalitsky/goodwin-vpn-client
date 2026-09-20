// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profiles.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VpnProfile {

 String get name;
/// Create a copy of VpnProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VpnProfileCopyWith<VpnProfile> get copyWith => _$VpnProfileCopyWithImpl<VpnProfile>(this as VpnProfile, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VpnProfile&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);



}

/// @nodoc
abstract mixin class $VpnProfileCopyWith<$Res>  {
  factory $VpnProfileCopyWith(VpnProfile value, $Res Function(VpnProfile) _then) = _$VpnProfileCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$VpnProfileCopyWithImpl<$Res>
    implements $VpnProfileCopyWith<$Res> {
  _$VpnProfileCopyWithImpl(this._self, this._then);

  final VpnProfile _self;
  final $Res Function(VpnProfile) _then;

/// Create a copy of VpnProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VpnProfile].
extension VpnProfilePatterns on VpnProfile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( XrayProfile value)?  xray,TResult Function( HysteriaProfile value)?  hysteria,TResult Function( TrustTunnelProfile value)?  trusttunnel,required TResult orElse(),}){
final _that = this;
switch (_that) {
case XrayProfile() when xray != null:
return xray(_that);case HysteriaProfile() when hysteria != null:
return hysteria(_that);case TrustTunnelProfile() when trusttunnel != null:
return trusttunnel(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( XrayProfile value)  xray,required TResult Function( HysteriaProfile value)  hysteria,required TResult Function( TrustTunnelProfile value)  trusttunnel,}){
final _that = this;
switch (_that) {
case XrayProfile():
return xray(_that);case HysteriaProfile():
return hysteria(_that);case TrustTunnelProfile():
return trusttunnel(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( XrayProfile value)?  xray,TResult? Function( HysteriaProfile value)?  hysteria,TResult? Function( TrustTunnelProfile value)?  trusttunnel,}){
final _that = this;
switch (_that) {
case XrayProfile() when xray != null:
return xray(_that);case HysteriaProfile() when hysteria != null:
return hysteria(_that);case TrustTunnelProfile() when trusttunnel != null:
return trusttunnel(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String name,  XrayProtocol protocol,  String address,  int port,  String id,  String encryption,  String? flow,  String network,  String security,  String? sni,  String? fingerprint,  String? publicKey,  String? shortId,  String? spiderX,  String? serviceName,  String? grpcMode,  String? wsPath,  String? wsHost,  String? alpn,  int alterId,  String? vmessSecurity)?  xray,TResult Function( String name,  String address,  int port,  String password,  String? sni,  bool insecure,  String? obfs,  String? obfsPassword)?  hysteria,TResult Function( String name,  String endpoint,  String? hostname,  List<String> addresses,  String? username,  String? password,  String? customSni,  bool hasIpv6,  bool skipVerification,  String? upstreamProtocol,  bool antiDpi,  List<String> dnsUpstreams,  int deepLinkVersion,  String? rawDeepLink)?  trusttunnel,required TResult orElse(),}) {final _that = this;
switch (_that) {
case XrayProfile() when xray != null:
return xray(_that.name,_that.protocol,_that.address,_that.port,_that.id,_that.encryption,_that.flow,_that.network,_that.security,_that.sni,_that.fingerprint,_that.publicKey,_that.shortId,_that.spiderX,_that.serviceName,_that.grpcMode,_that.wsPath,_that.wsHost,_that.alpn,_that.alterId,_that.vmessSecurity);case HysteriaProfile() when hysteria != null:
return hysteria(_that.name,_that.address,_that.port,_that.password,_that.sni,_that.insecure,_that.obfs,_that.obfsPassword);case TrustTunnelProfile() when trusttunnel != null:
return trusttunnel(_that.name,_that.endpoint,_that.hostname,_that.addresses,_that.username,_that.password,_that.customSni,_that.hasIpv6,_that.skipVerification,_that.upstreamProtocol,_that.antiDpi,_that.dnsUpstreams,_that.deepLinkVersion,_that.rawDeepLink);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String name,  XrayProtocol protocol,  String address,  int port,  String id,  String encryption,  String? flow,  String network,  String security,  String? sni,  String? fingerprint,  String? publicKey,  String? shortId,  String? spiderX,  String? serviceName,  String? grpcMode,  String? wsPath,  String? wsHost,  String? alpn,  int alterId,  String? vmessSecurity)  xray,required TResult Function( String name,  String address,  int port,  String password,  String? sni,  bool insecure,  String? obfs,  String? obfsPassword)  hysteria,required TResult Function( String name,  String endpoint,  String? hostname,  List<String> addresses,  String? username,  String? password,  String? customSni,  bool hasIpv6,  bool skipVerification,  String? upstreamProtocol,  bool antiDpi,  List<String> dnsUpstreams,  int deepLinkVersion,  String? rawDeepLink)  trusttunnel,}) {final _that = this;
switch (_that) {
case XrayProfile():
return xray(_that.name,_that.protocol,_that.address,_that.port,_that.id,_that.encryption,_that.flow,_that.network,_that.security,_that.sni,_that.fingerprint,_that.publicKey,_that.shortId,_that.spiderX,_that.serviceName,_that.grpcMode,_that.wsPath,_that.wsHost,_that.alpn,_that.alterId,_that.vmessSecurity);case HysteriaProfile():
return hysteria(_that.name,_that.address,_that.port,_that.password,_that.sni,_that.insecure,_that.obfs,_that.obfsPassword);case TrustTunnelProfile():
return trusttunnel(_that.name,_that.endpoint,_that.hostname,_that.addresses,_that.username,_that.password,_that.customSni,_that.hasIpv6,_that.skipVerification,_that.upstreamProtocol,_that.antiDpi,_that.dnsUpstreams,_that.deepLinkVersion,_that.rawDeepLink);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String name,  XrayProtocol protocol,  String address,  int port,  String id,  String encryption,  String? flow,  String network,  String security,  String? sni,  String? fingerprint,  String? publicKey,  String? shortId,  String? spiderX,  String? serviceName,  String? grpcMode,  String? wsPath,  String? wsHost,  String? alpn,  int alterId,  String? vmessSecurity)?  xray,TResult? Function( String name,  String address,  int port,  String password,  String? sni,  bool insecure,  String? obfs,  String? obfsPassword)?  hysteria,TResult? Function( String name,  String endpoint,  String? hostname,  List<String> addresses,  String? username,  String? password,  String? customSni,  bool hasIpv6,  bool skipVerification,  String? upstreamProtocol,  bool antiDpi,  List<String> dnsUpstreams,  int deepLinkVersion,  String? rawDeepLink)?  trusttunnel,}) {final _that = this;
switch (_that) {
case XrayProfile() when xray != null:
return xray(_that.name,_that.protocol,_that.address,_that.port,_that.id,_that.encryption,_that.flow,_that.network,_that.security,_that.sni,_that.fingerprint,_that.publicKey,_that.shortId,_that.spiderX,_that.serviceName,_that.grpcMode,_that.wsPath,_that.wsHost,_that.alpn,_that.alterId,_that.vmessSecurity);case HysteriaProfile() when hysteria != null:
return hysteria(_that.name,_that.address,_that.port,_that.password,_that.sni,_that.insecure,_that.obfs,_that.obfsPassword);case TrustTunnelProfile() when trusttunnel != null:
return trusttunnel(_that.name,_that.endpoint,_that.hostname,_that.addresses,_that.username,_that.password,_that.customSni,_that.hasIpv6,_that.skipVerification,_that.upstreamProtocol,_that.antiDpi,_that.dnsUpstreams,_that.deepLinkVersion,_that.rawDeepLink);case _:
  return null;

}
}

}

/// @nodoc


class XrayProfile extends VpnProfile {
  const XrayProfile({required this.name, required this.protocol, required this.address, required this.port, required this.id, this.encryption = 'none', this.flow, this.network = 'tcp', this.security = 'none', this.sni, this.fingerprint, this.publicKey, this.shortId, this.spiderX, this.serviceName, this.grpcMode, this.wsPath, this.wsHost, this.alpn, this.alterId = 0, this.vmessSecurity}): super._();
  

@override final  String name;
 final  XrayProtocol protocol;
 final  String address;
 final  int port;
 final  String id;
@JsonKey() final  String encryption;
 final  String? flow;
@JsonKey() final  String network;
@JsonKey() final  String security;
 final  String? sni;
 final  String? fingerprint;
 final  String? publicKey;
 final  String? shortId;
 final  String? spiderX;
 final  String? serviceName;
/// gRPC: gun | multi
 final  String? grpcMode;
 final  String? wsPath;
 final  String? wsHost;
 final  String? alpn;
/// Trojan password uses [id]; VMess alterId if needed.
@JsonKey() final  int alterId;
 final  String? vmessSecurity;

/// Create a copy of VpnProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$XrayProfileCopyWith<XrayProfile> get copyWith => _$XrayProfileCopyWithImpl<XrayProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is XrayProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.address, address) || other.address == address)&&(identical(other.port, port) || other.port == port)&&(identical(other.id, id) || other.id == id)&&(identical(other.encryption, encryption) || other.encryption == encryption)&&(identical(other.flow, flow) || other.flow == flow)&&(identical(other.network, network) || other.network == network)&&(identical(other.security, security) || other.security == security)&&(identical(other.sni, sni) || other.sni == sni)&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint)&&(identical(other.publicKey, publicKey) || other.publicKey == publicKey)&&(identical(other.shortId, shortId) || other.shortId == shortId)&&(identical(other.spiderX, spiderX) || other.spiderX == spiderX)&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName)&&(identical(other.grpcMode, grpcMode) || other.grpcMode == grpcMode)&&(identical(other.wsPath, wsPath) || other.wsPath == wsPath)&&(identical(other.wsHost, wsHost) || other.wsHost == wsHost)&&(identical(other.alpn, alpn) || other.alpn == alpn)&&(identical(other.alterId, alterId) || other.alterId == alterId)&&(identical(other.vmessSecurity, vmessSecurity) || other.vmessSecurity == vmessSecurity));
}


@override
int get hashCode => Object.hashAll([runtimeType,name,protocol,address,port,id,encryption,flow,network,security,sni,fingerprint,publicKey,shortId,spiderX,serviceName,grpcMode,wsPath,wsHost,alpn,alterId,vmessSecurity]);



}

/// @nodoc
abstract mixin class $XrayProfileCopyWith<$Res> implements $VpnProfileCopyWith<$Res> {
  factory $XrayProfileCopyWith(XrayProfile value, $Res Function(XrayProfile) _then) = _$XrayProfileCopyWithImpl;
@override @useResult
$Res call({
 String name, XrayProtocol protocol, String address, int port, String id, String encryption, String? flow, String network, String security, String? sni, String? fingerprint, String? publicKey, String? shortId, String? spiderX, String? serviceName, String? grpcMode, String? wsPath, String? wsHost, String? alpn, int alterId, String? vmessSecurity
});




}
/// @nodoc
class _$XrayProfileCopyWithImpl<$Res>
    implements $XrayProfileCopyWith<$Res> {
  _$XrayProfileCopyWithImpl(this._self, this._then);

  final XrayProfile _self;
  final $Res Function(XrayProfile) _then;

/// Create a copy of VpnProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? protocol = null,Object? address = null,Object? port = null,Object? id = null,Object? encryption = null,Object? flow = freezed,Object? network = null,Object? security = null,Object? sni = freezed,Object? fingerprint = freezed,Object? publicKey = freezed,Object? shortId = freezed,Object? spiderX = freezed,Object? serviceName = freezed,Object? grpcMode = freezed,Object? wsPath = freezed,Object? wsHost = freezed,Object? alpn = freezed,Object? alterId = null,Object? vmessSecurity = freezed,}) {
  return _then(XrayProfile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as XrayProtocol,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,encryption: null == encryption ? _self.encryption : encryption // ignore: cast_nullable_to_non_nullable
as String,flow: freezed == flow ? _self.flow : flow // ignore: cast_nullable_to_non_nullable
as String?,network: null == network ? _self.network : network // ignore: cast_nullable_to_non_nullable
as String,security: null == security ? _self.security : security // ignore: cast_nullable_to_non_nullable
as String,sni: freezed == sni ? _self.sni : sni // ignore: cast_nullable_to_non_nullable
as String?,fingerprint: freezed == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String?,publicKey: freezed == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String?,shortId: freezed == shortId ? _self.shortId : shortId // ignore: cast_nullable_to_non_nullable
as String?,spiderX: freezed == spiderX ? _self.spiderX : spiderX // ignore: cast_nullable_to_non_nullable
as String?,serviceName: freezed == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String?,grpcMode: freezed == grpcMode ? _self.grpcMode : grpcMode // ignore: cast_nullable_to_non_nullable
as String?,wsPath: freezed == wsPath ? _self.wsPath : wsPath // ignore: cast_nullable_to_non_nullable
as String?,wsHost: freezed == wsHost ? _self.wsHost : wsHost // ignore: cast_nullable_to_non_nullable
as String?,alpn: freezed == alpn ? _self.alpn : alpn // ignore: cast_nullable_to_non_nullable
as String?,alterId: null == alterId ? _self.alterId : alterId // ignore: cast_nullable_to_non_nullable
as int,vmessSecurity: freezed == vmessSecurity ? _self.vmessSecurity : vmessSecurity // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class HysteriaProfile extends VpnProfile {
  const HysteriaProfile({required this.name, required this.address, required this.port, required this.password, this.sni, this.insecure = false, this.obfs, this.obfsPassword}): super._();
  

@override final  String name;
 final  String address;
 final  int port;
 final  String password;
 final  String? sni;
@JsonKey() final  bool insecure;
 final  String? obfs;
 final  String? obfsPassword;

/// Create a copy of VpnProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HysteriaProfileCopyWith<HysteriaProfile> get copyWith => _$HysteriaProfileCopyWithImpl<HysteriaProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HysteriaProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.port, port) || other.port == port)&&(identical(other.password, password) || other.password == password)&&(identical(other.sni, sni) || other.sni == sni)&&(identical(other.insecure, insecure) || other.insecure == insecure)&&(identical(other.obfs, obfs) || other.obfs == obfs)&&(identical(other.obfsPassword, obfsPassword) || other.obfsPassword == obfsPassword));
}


@override
int get hashCode => Object.hash(runtimeType,name,address,port,password,sni,insecure,obfs,obfsPassword);



}

/// @nodoc
abstract mixin class $HysteriaProfileCopyWith<$Res> implements $VpnProfileCopyWith<$Res> {
  factory $HysteriaProfileCopyWith(HysteriaProfile value, $Res Function(HysteriaProfile) _then) = _$HysteriaProfileCopyWithImpl;
@override @useResult
$Res call({
 String name, String address, int port, String password, String? sni, bool insecure, String? obfs, String? obfsPassword
});




}
/// @nodoc
class _$HysteriaProfileCopyWithImpl<$Res>
    implements $HysteriaProfileCopyWith<$Res> {
  _$HysteriaProfileCopyWithImpl(this._self, this._then);

  final HysteriaProfile _self;
  final $Res Function(HysteriaProfile) _then;

/// Create a copy of VpnProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? address = null,Object? port = null,Object? password = null,Object? sni = freezed,Object? insecure = null,Object? obfs = freezed,Object? obfsPassword = freezed,}) {
  return _then(HysteriaProfile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,sni: freezed == sni ? _self.sni : sni // ignore: cast_nullable_to_non_nullable
as String?,insecure: null == insecure ? _self.insecure : insecure // ignore: cast_nullable_to_non_nullable
as bool,obfs: freezed == obfs ? _self.obfs : obfs // ignore: cast_nullable_to_non_nullable
as String?,obfsPassword: freezed == obfsPassword ? _self.obfsPassword : obfsPassword // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class TrustTunnelProfile extends VpnProfile {
  const TrustTunnelProfile({required this.name, required this.endpoint, this.hostname, final  List<String> addresses = const [], this.username, this.password, this.customSni, this.hasIpv6 = true, this.skipVerification = false, this.upstreamProtocol, this.antiDpi = false, final  List<String> dnsUpstreams = const [], this.deepLinkVersion = 0, this.rawDeepLink}): _addresses = addresses,_dnsUpstreams = dnsUpstreams,super._();
  

@override final  String name;
 final  String endpoint;
 final  String? hostname;
 final  List<String> _addresses;
@JsonKey() List<String> get addresses {
  if (_addresses is EqualUnmodifiableListView) return _addresses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_addresses);
}

 final  String? username;
 final  String? password;
 final  String? customSni;
@JsonKey() final  bool hasIpv6;
@JsonKey() final  bool skipVerification;
 final  String? upstreamProtocol;
@JsonKey() final  bool antiDpi;
 final  List<String> _dnsUpstreams;
@JsonKey() List<String> get dnsUpstreams {
  if (_dnsUpstreams is EqualUnmodifiableListView) return _dnsUpstreams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dnsUpstreams);
}

@JsonKey() final  int deepLinkVersion;
 final  String? rawDeepLink;

/// Create a copy of VpnProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrustTunnelProfileCopyWith<TrustTunnelProfile> get copyWith => _$TrustTunnelProfileCopyWithImpl<TrustTunnelProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrustTunnelProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint)&&(identical(other.hostname, hostname) || other.hostname == hostname)&&const DeepCollectionEquality().equals(other._addresses, _addresses)&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.customSni, customSni) || other.customSni == customSni)&&(identical(other.hasIpv6, hasIpv6) || other.hasIpv6 == hasIpv6)&&(identical(other.skipVerification, skipVerification) || other.skipVerification == skipVerification)&&(identical(other.upstreamProtocol, upstreamProtocol) || other.upstreamProtocol == upstreamProtocol)&&(identical(other.antiDpi, antiDpi) || other.antiDpi == antiDpi)&&const DeepCollectionEquality().equals(other._dnsUpstreams, _dnsUpstreams)&&(identical(other.deepLinkVersion, deepLinkVersion) || other.deepLinkVersion == deepLinkVersion)&&(identical(other.rawDeepLink, rawDeepLink) || other.rawDeepLink == rawDeepLink));
}


@override
int get hashCode => Object.hash(runtimeType,name,endpoint,hostname,const DeepCollectionEquality().hash(_addresses),username,password,customSni,hasIpv6,skipVerification,upstreamProtocol,antiDpi,const DeepCollectionEquality().hash(_dnsUpstreams),deepLinkVersion,rawDeepLink);



}

/// @nodoc
abstract mixin class $TrustTunnelProfileCopyWith<$Res> implements $VpnProfileCopyWith<$Res> {
  factory $TrustTunnelProfileCopyWith(TrustTunnelProfile value, $Res Function(TrustTunnelProfile) _then) = _$TrustTunnelProfileCopyWithImpl;
@override @useResult
$Res call({
 String name, String endpoint, String? hostname, List<String> addresses, String? username, String? password, String? customSni, bool hasIpv6, bool skipVerification, String? upstreamProtocol, bool antiDpi, List<String> dnsUpstreams, int deepLinkVersion, String? rawDeepLink
});




}
/// @nodoc
class _$TrustTunnelProfileCopyWithImpl<$Res>
    implements $TrustTunnelProfileCopyWith<$Res> {
  _$TrustTunnelProfileCopyWithImpl(this._self, this._then);

  final TrustTunnelProfile _self;
  final $Res Function(TrustTunnelProfile) _then;

/// Create a copy of VpnProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? endpoint = null,Object? hostname = freezed,Object? addresses = null,Object? username = freezed,Object? password = freezed,Object? customSni = freezed,Object? hasIpv6 = null,Object? skipVerification = null,Object? upstreamProtocol = freezed,Object? antiDpi = null,Object? dnsUpstreams = null,Object? deepLinkVersion = null,Object? rawDeepLink = freezed,}) {
  return _then(TrustTunnelProfile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,endpoint: null == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String,hostname: freezed == hostname ? _self.hostname : hostname // ignore: cast_nullable_to_non_nullable
as String?,addresses: null == addresses ? _self._addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<String>,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,customSni: freezed == customSni ? _self.customSni : customSni // ignore: cast_nullable_to_non_nullable
as String?,hasIpv6: null == hasIpv6 ? _self.hasIpv6 : hasIpv6 // ignore: cast_nullable_to_non_nullable
as bool,skipVerification: null == skipVerification ? _self.skipVerification : skipVerification // ignore: cast_nullable_to_non_nullable
as bool,upstreamProtocol: freezed == upstreamProtocol ? _self.upstreamProtocol : upstreamProtocol // ignore: cast_nullable_to_non_nullable
as String?,antiDpi: null == antiDpi ? _self.antiDpi : antiDpi // ignore: cast_nullable_to_non_nullable
as bool,dnsUpstreams: null == dnsUpstreams ? _self._dnsUpstreams : dnsUpstreams // ignore: cast_nullable_to_non_nullable
as List<String>,deepLinkVersion: null == deepLinkVersion ? _self.deepLinkVersion : deepLinkVersion // ignore: cast_nullable_to_non_nullable
as int,rawDeepLink: freezed == rawDeepLink ? _self.rawDeepLink : rawDeepLink // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
