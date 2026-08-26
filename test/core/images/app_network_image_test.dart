import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smerp_go/core/images/app_network_image.dart';

void main() {
  group('AppNetworkImage.isRemoteUrl', () {
    test('accepts http and https URLs', () {
      expect(
        AppNetworkImage.isRemoteUrl('https://cdn.example.com/a.png'),
        isTrue,
      );
      expect(
        AppNetworkImage.isRemoteUrl('http://cdn.example.com/a.png'),
        isTrue,
      );
    });

    test('rejects empty, blank, and non-http values', () {
      expect(AppNetworkImage.isRemoteUrl(null), isFalse);
      expect(AppNetworkImage.isRemoteUrl(''), isFalse);
      expect(AppNetworkImage.isRemoteUrl('   '), isFalse);
      expect(AppNetworkImage.isRemoteUrl('assets/pCircle.png'), isFalse);
      expect(AppNetworkImage.isRemoteUrl('not a url'), isFalse);
      expect(AppNetworkImage.isRemoteUrl('ftp://example.com/a.png'), isFalse);
    });
  });

  group('AppNetworkImage.provider', () {
    test('returns AssetImage for invalid urls', () {
      final provider = AppNetworkImage.provider('');
      expect(provider, isA<AssetImage>());
      expect(
        (provider as AssetImage).assetName,
        AppNetworkImage.placeholderAsset,
      );
    });

    test('returns CachedNetworkImageProvider for remote urls', () {
      final provider = AppNetworkImage.provider(
        'https://cdn.example.com/product.png',
      );
      expect(provider, isA<CachedNetworkImageProvider>());
    });
  });
}
