/// Single source of truth for the 12 approved countries / regions that may
/// submit a free AO Scan demo form.
///
/// NOTE: registration remains open to every country — this list only restricts
/// demo-form submissions.
class ApprovedCountries {
  static const List<String> names = [
    'United States',
    'Canada',
    'Mexico',
    'Brazil',
    'Portugal',
    'Spain',
    'France',
    'Ecuador',
    'Australia',
    'United Kingdom',
    'Netherlands',
    'South Africa',
  ];

  /// Dial codes for the approved countries. Used to auto-select the phone
  /// country code when a country is picked in the demo form.
  static const Map<String, String> dialCodes = {
    'United States': '+1',
    'Canada': '+1',
    'Mexico': '+52',
    'Brazil': '+55',
    'Portugal': '+351',
    'Spain': '+34',
    'France': '+33',
    'Ecuador': '+593',
    'Australia': '+61',
    'United Kingdom': '+44',
    'Netherlands': '+31',
    'South Africa': '+27',
  };

  static bool contains(String? country) {
    if (country == null) return false;
    final normalized = country.trim().toLowerCase();
    return names.any((name) => name.toLowerCase() == normalized);
  }

  static String? dialCodeFor(String? country) {
    if (country == null) return null;
    for (final entry in dialCodes.entries) {
      if (entry.key.toLowerCase() == country.trim().toLowerCase()) {
        return entry.value;
      }
    }
    return null;
  }
}

/// Convenience helpers used across screens/controllers.
bool isCountryApproved(String? country) => ApprovedCountries.contains(country);

List<String> approvedCountryNames() => List.unmodifiable(ApprovedCountries.names);

String? approvedCountryDialCode(String? country) =>
    ApprovedCountries.dialCodeFor(country);