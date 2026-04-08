// ignore_for_file: constant_identifier_names

const APP_NAME = 'URCLINIC Employee';
const APP_LOGO_URL = '$DOMAIN_URL/img/logo/mini_logo.png';
const DEFAULT_LANGUAGE = 'en';
const DASHBOARD_AUTO_SLIDER_SECOND = 5;

///Live Url
const DOMAIN_URL = String.fromEnvironment(
  'URCLINIC_DOMAIN_URL',
  defaultValue: 'https://urclinic.findosystem.com',
);

const BASE_URL = '$DOMAIN_URL/api/';

/// Keep these empty in source control and set real values in CI via --dart-define.
const APP_PLAY_STORE_URL =
    String.fromEnvironment('URCLINIC_PLAY_STORE_URL', defaultValue: '');
const APP_APPSTORE_URL =
    String.fromEnvironment('URCLINIC_APP_STORE_URL', defaultValue: '');

const TERMS_CONDITION_URL = String.fromEnvironment('URCLINIC_TERMS_URL',
    defaultValue: '$DOMAIN_URL/page/terms-conditions');
const PRIVACY_POLICY_URL = String.fromEnvironment('URCLINIC_PRIVACY_URL',
    defaultValue: '$DOMAIN_URL/page/privacy-policy');
const DATA_DELETION_REQUEST_URL = String.fromEnvironment(
    'URCLINIC_DATA_DELETION_URL',
    defaultValue: '$DOMAIN_URL/page/data-deletion-request');

const INQUIRY_SUPPORT_EMAIL = 'findogroup5@gmail.com';

/// You can add help line number here for contact.
const HELP_LINE_NUMBER = '+96599863214';
