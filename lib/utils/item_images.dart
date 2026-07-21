/// Maps a ration item's name/category to a bundled, verified product photo
/// under `assets/images/items/`. Every photo was hand-checked to show the
/// correct ingredient (see assets/images/items/ATTRIBUTIONS.txt for sources).
///
/// Bundled (not hotlinked) so images always load — offline, instantly, and
/// without any User-Agent/CORS restrictions from the source host.
library;

const String _base = 'assets/images/items';

/// Resolve the best-matching asset for [name]. Order matters: more specific
/// lentil types are checked before the generic "dal" fallback.
String imageForItem(String name) {
  final n = name.toLowerCase();

  if (n.contains('rice')) return '$_base/rice.jpg';

  // Specific Indian lentils / pulses — check distinct types before the
  // generic "gram"/"dal" fallbacks so e.g. "green gram" → moong, not chana.
  if (n.contains('masoor') || n.contains('red lentil')) {
    return '$_base/masoor.jpg';
  }
  if (n.contains('moong') || n.contains('mung') || n.contains('green gram')) {
    return '$_base/moong.jpg';
  }
  if (n.contains('urad') || n.contains('black gram')) {
    return '$_base/urad.jpg';
  }
  if (n.contains('chana') || n.contains('chickpea') || n.contains('gram')) {
    return '$_base/chana.jpg';
  }
  if (n.contains('dal') || n.contains('lentil') || n.contains('pulse') ||
      n.contains('toor') || n.contains('arhar')) {
    return '$_base/dal.jpg';
  }

  if (n.contains('oil')) return '$_base/oil.jpg';
  if (n.contains('milk')) return '$_base/milk.jpg';
  if (n.contains('chil') || n.contains('mirch') || n.contains('pepper')) {
    return '$_base/chili.jpg';
  }
  if (n.contains('turmeric') || n.contains('haldi')) {
    return '$_base/turmeric.jpg';
  }
  if (n.contains('sugar')) return '$_base/sugar.jpg';
  if (n.contains('flour') || n.contains('atta') || n.contains('maida')) {
    return '$_base/flour.jpg';
  }
  if (n.contains('salt')) return '$_base/salt.jpg';
  // "Wheat Box" shows wheat flour (its contents), while bulk grain / cereal
  // containers keep the raw-grain photo.
  if (n.contains('wheat')) return '$_base/flour.jpg';
  if (n.contains('grain') || n.contains('cereal')) {
    return '$_base/wheat.jpg';
  }

  // Neutral pantry staple fallback.
  return '$_base/wheat.jpg';
}

/// Backwards-compatible alias (older call sites used the *Url* name).
String imageUrlForItem(String name, {int size = 600}) => imageForItem(name);

/// Hero backdrop reuses the primary item's photo.
String heroImageUrl(String name, {int width = 800, int height = 600}) =>
    imageForItem(name);
