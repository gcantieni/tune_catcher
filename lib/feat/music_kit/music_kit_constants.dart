const kAppleMusicCatalogScheme = 'music-catalog';

String? catalogIdFromUrl(String url) {
  if (!url.startsWith('$kAppleMusicCatalogScheme:')) return null;
  return url.substring(kAppleMusicCatalogScheme.length + 1);
}
