import Foundation

/**
 Collection of all strings that are either
 used multiple times or need to be translated.
 Only Dutch is supported at the moment.
 */
struct StringConstants {
    
    // LoginViewController
    static let titleLoginAlert = "Aanmelden"
    
    // RegistrationViewController
    static let titleRegistrationAlert = "Account aanmaken"
    static let messageVerificationEmailSent = "Uw account werd succesvol aangemaakt en er werd een bevestigingsmail naar uw e-mailadres verzonden."
    static let privacyPolicyAlert = "Privacybeleid"
    static let messagePrivacyPolicy = "Door op 'Ja' te drukken, gaat u akkoord met het privacybeleid en zal uw account aangemaakt worden. Er zal een bevestigingsmail naar uw e-mailadres verzonden worden."
    
    // SettingsViewController
    static let titleSettingsSignOutAlert = "Afmelden"
    static let messageSignOut = "Bent u zeker dat u zich wilt afmelden?"
    static let titleSettingsSendSuggestionAlert = "Suggestie versturen"
    static let messageSendSuggestion = "Vul hieronder uw suggestie in en druk op de knop 'Verzend'."
    static let placeholderSendSuggestionTextfield = "Typ hier uw suggestie..."
    static let successSendSuggestion = "Bedankt voor het verzenden van uw suggestie!"
    
    // ProfileViewController
    static let titleProfileEditProfileAlert = "Profiel wijzigen"
    static let titleProfileChangePasswordAlert = "Wachtwoord wijzigen"
    static let messageEditProfile = "Bent u zeker dat u uw profiel wilt wijzigen?"
    static let messageChangePassword = "Bent u zeker dat u uw wachtwoord wilt wijzigen? Als u op 'Ja' drukt, zal er een e-mail verzonden worden waarmee uw wachtwoord opnieuw ingesteld kan worden."
    static let successNameChange = "Uw naam werd succesvol gewijzigd."
    static let messageChangePasswordEmailSent = "Er werd een e-mail verzonden naar uw e-mailadres waarmee u uw wachtwoord kunt wijzigen."
    
    // Alerts
    static let alertOk = "Oké"
    static let alertYes = "Ja"
    static let alertNo = "Nee"
    static let alertCancel = "Annuleren"
    static let alertSend = "Verzend"
    static let alertPrivacyPolicy = "Bekijk privacybeleid"
    
    // Errors
    static let errorUnexpected = "Er is een onverwachte fout opgetreden tijdens het aanmelden."
    static let errorAccountNotCreated = "Er is iets fout opgetreden tijdens het aanmaken van uw account."
    static let errorNameNotChanged = "Er is een fout opgetreden tijdens het wijzigen van uw naam."
    static let errorEmailAddressNotChanged = "Er is een onverwachte fout opgetreden tijdens het wijzigen van uw e-mailadres."
    static let errorChangePasswordEmailNotSent = "Er is een onverwachte fout opgetreden tijdens het verzend van de mail voor het wijzigen van uw wachtwoord."
    static let errorEmptySuggestion = "Gelieve een suggestie in te voeren alvorens u op 'Verzend' drukt."
    static let errorSuggestionNotSent = "Er is iets fout opgetreden tijdens het verzenden van uw suggestie."
    
    // Form validation
    static let formEmptyFields = "Gelieve voor ieder veld een waarde in te voeren."
    static let formInvalidEmailAddress = "Gelieve een geldig e-mailadres in te voeren."
    static let formUnverifiedEmailAddress = "Gelieve uw e-mailadres eerst te verifiëren aan de hand van de verzonden e-mail."
    static let formInvalidPassword = "Het wachtwoord moet minstens 6 karakters lang zijn."
    static let formPasswordsDoNotMatch = "De twee opgegeven wachtwoorden komen niet overeen."
    
    // URLs
    static let website = "https://bramdeconinck.com"
    static let privacyPolicy = "https://technology-salesman-toolkit.firebaseapp.com/privacy_policy.html"
    
}
