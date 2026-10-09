import 'package:flutter_test/flutter_test.dart';
import 'package:ao_scan_app/utils/approved_countries.dart';

void main() {
  group('ApprovedCountries tests', () {
    const userRequestedCountries = [
      'Åland Islands',
      'Argentina',
      'Australia',
      'Austria',
      'Belgium',
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
      'St. Martin',
      'Slovakia',
      'Slovenia',
      'Spain',
      'Svalbard & Jan Mayen',
      'Sweden',
      'Switzerland',
      'United Kingdom',
      'United States',
    ];

    test('All 53 user-requested countries are approved', () {
      for (final country in userRequestedCountries) {
        expect(
          isCountryApproved(country),
          isTrue,
          reason: 'Expected $country to be approved',
        );
      }
    });

    test('Existing countries not in user list (Brazil, South Africa) remain approved', () {
      expect(isCountryApproved('Brazil'), isTrue);
      expect(isCountryApproved('South Africa'), isTrue);
    });

    test('Total number of approved countries is exactly 55', () {
      final names = approvedCountryNames();
      expect(names.length, equals(55));
      expect(names.toSet().length, equals(55), reason: 'List must have no duplicates');
    });

    test('Names list preserves user ordering with Åland Islands first', () {
      final names = approvedCountryNames();
      expect(names.first, equals('Åland Islands'));
      expect(names[1], equals('Argentina'));
      expect(names.last, equals('United States'));
    });

    test('Every approved country has a valid E.164 dial code starting with "+"', () {
      for (final country in approvedCountryNames()) {
        final dialCode = approvedCountryDialCode(country);
        expect(dialCode, isNotNull, reason: 'Dial code for $country should not be null');
        expect(dialCode!.startsWith('+'), isTrue, reason: 'Dial code for $country should start with +');
        expect(dialCode.length, greaterThanOrEqualTo(2));
      }
    });

    test('Specific dial codes match expected values', () {
      expect(approvedCountryDialCode('Germany'), equals('+49'));
      expect(approvedCountryDialCode('United States'), equals('+1'));
      expect(approvedCountryDialCode('Canada'), equals('+1'));
      expect(approvedCountryDialCode('United Kingdom'), equals('+44'));
      expect(approvedCountryDialCode('Åland Islands'), equals('+358'));
      expect(approvedCountryDialCode('Argentina'), equals('+54'));
      expect(approvedCountryDialCode('Sweden'), equals('+46'));
      expect(approvedCountryDialCode('St. Martin'), equals('+590'));
      expect(approvedCountryDialCode('Svalbard & Jan Mayen'), equals('+47'));
      expect(approvedCountryDialCode('Brazil'), equals('+55'));
      expect(approvedCountryDialCode('South Africa'), equals('+27'));
    });

    test('Alias and case-insensitive resolution works as expected', () {
      // Direct case insensitive
      expect(ApprovedCountries.canonicalName('germany'), equals('Germany'));
      expect(ApprovedCountries.canonicalName('UNITED STATES'), equals('United States'));

      // Aliases
      expect(ApprovedCountries.canonicalName('Saint Martin'), equals('St. Martin'));
      expect(ApprovedCountries.canonicalName('saint-martin'), equals('St. Martin'));
      expect(ApprovedCountries.canonicalName('Svalbard and Jan Mayen'), equals('Svalbard & Jan Mayen'));
      expect(ApprovedCountries.canonicalName('Reunion'), equals('Réunion'));
      expect(ApprovedCountries.canonicalName('Aland Islands'), equals('Åland Islands'));
      expect(ApprovedCountries.canonicalName('USA'), equals('United States'));
      expect(ApprovedCountries.canonicalName('UK'), equals('United Kingdom'));

      // Contains helper with alias
      expect(isCountryApproved('Saint Martin'), isTrue);
      expect(isCountryApproved('Svalbard and Jan Mayen'), isTrue);
      expect(isCountryApproved('USA'), isTrue);

      // Dial code with alias
      expect(approvedCountryDialCode('Saint Martin'), equals('+590'));
      expect(approvedCountryDialCode('USA'), equals('+1'));
    });

    test('Non-approved countries return false/null', () {
      expect(isCountryApproved('Afghanistan'), isFalse);
      expect(isCountryApproved('Japan'), isFalse);
      expect(isCountryApproved('China'), isFalse);
      expect(isCountryApproved(''), isFalse);
      expect(isCountryApproved(null), isFalse);

      expect(approvedCountryDialCode('Japan'), isNull);
      expect(ApprovedCountries.canonicalName('Japan'), isNull);
    });
  });
}
