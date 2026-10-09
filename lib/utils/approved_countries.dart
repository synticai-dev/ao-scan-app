/// Single source of truth for the 55 approved countries / regions that may
/// submit a free AO Scan demo form.
///
/// NOTE: registration remains open to every country — this list only restricts
/// demo-form submissions.
class ApprovedCountries {
  static const List<String> names = [
    'Åland Islands',
    'Argentina',
    'Australia',
    'Austria',
    'Belgium',
    'Brazil',
    'Bulgaria',
    'Canada',
    'Colombia',
    'Croatia',
    'Cyprus',
    'Czech Republic',
    'Denmark',
    'Ecuador',
    'Estonia',
    'Finland',
    'France',
    'French Guiana',
    'Germany',
    'Gibraltar',
    'Greece',
    'Guadeloupe',
    'Guatemala',
    'Hungary',
    'Iceland',
    'Indonesia',
    'Ireland',
    'Italy',
    'Latvia',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Malaysia',
    'Malta',
    'Martinique',
    'Mayotte',
    'Mexico',
    'Netherlands',
    'New Zealand',
    'Norway',
    'Panama',
    'Poland',
    'Portugal',
    'Réunion',
    'Romania',
    'Slovakia',
    'Slovenia',
    'South Africa',
    'Spain',
    'St. Martin',
    'Svalbard & Jan Mayen',
    'Sweden',
    'Switzerland',
    'United Kingdom',
    'United States',
  ];

  /// Dial codes for all approved countries. Used to auto-select the phone
  /// country code when a country is picked in the demo form.
  static const Map<String, String> dialCodes = {
    'Åland Islands': '+358',
    'Argentina': '+54',
    'Australia': '+61',
    'Austria': '+43',
    'Belgium': '+32',
    'Brazil': '+55',
    'Bulgaria': '+359',
    'Canada': '+1',
    'Colombia': '+57',
    'Croatia': '+385',
    'Cyprus': '+357',
    'Czech Republic': '+420',
    'Denmark': '+45',
    'Ecuador': '+593',
    'Estonia': '+372',
    'Finland': '+358',
    'France': '+33',
    'French Guiana': '+594',
    'Germany': '+49',
    'Gibraltar': '+350',
    'Greece': '+30',
    'Guadeloupe': '+590',
    'Guatemala': '+502',
    'Hungary': '+36',
    'Iceland': '+354',
    'Indonesia': '+62',
    'Ireland': '+353',
    'Italy': '+39',
    'Latvia': '+371',
    'Liechtenstein': '+423',
    'Lithuania': '+370',
    'Luxembourg': '+352',
    'Malaysia': '+60',
    'Malta': '+356',
    'Martinique': '+596',
    'Mayotte': '+262',
    'Mexico': '+52',
    'Netherlands': '+31',
    'New Zealand': '+64',
    'Norway': '+47',
    'Panama': '+507',
    'Poland': '+48',
    'Portugal': '+351',
    'Réunion': '+262',
    'Romania': '+40',
    'Slovakia': '+421',
    'Slovenia': '+386',
    'South Africa': '+27',
    'Spain': '+34',
    'St. Martin': '+590',
    'Svalbard & Jan Mayen': '+47',
    'Sweden': '+46',
    'Switzerland': '+41',
    'United Kingdom': '+44',
    'United States': '+1',
  };

  /// Common aliases, abbreviations, and name variants (e.g. from the
  /// country_picker package used on registration).
  static const Map<String, String> _aliases = {
    'saint martin': 'St. Martin',
    'saint-martin': 'St. Martin',
    'st martin': 'St. Martin',
    'svalbard and jan mayen': 'Svalbard & Jan Mayen',
    'svalbard & jan mayen islands': 'Svalbard & Jan Mayen',
    'reunion': 'Réunion',
    'aland islands': 'Åland Islands',
    'united states of america': 'United States',
    'usa': 'United States',
    'us': 'United States',
    'uk': 'United Kingdom',
    'great britain': 'United Kingdom',
  };

  /// Resolves a country string to its canonical name in [names], or returns null
  /// if not approved. Handles case-insensitivity, trim, and known aliases.
  static String? canonicalName(String? country) {
    if (country == null) return null;
    final trimmed = country.trim();
    if (trimmed.isEmpty) return null;

    final lower = trimmed.toLowerCase();

    // 1. Direct case-insensitive match against canonical names
    for (final name in names) {
      if (name.toLowerCase() == lower) {
        return name;
      }
    }

    // 2. Check known aliases
    final aliasMatch = _aliases[lower];
    if (aliasMatch != null) {
      return aliasMatch;
    }

    return null;
  }

  static bool contains(String? country) => canonicalName(country) != null;

  static String? dialCodeFor(String? country) {
    final canonical = canonicalName(country);
    if (canonical == null) return null;
    return dialCodes[canonical];
  }
}

/// Convenience helpers used across screens/controllers.
bool isCountryApproved(String? country) => ApprovedCountries.contains(country);

List<String> approvedCountryNames() => List.unmodifiable(ApprovedCountries.names);

String? approvedCountryDialCode(String? country) =>
    ApprovedCountries.dialCodeFor(country);