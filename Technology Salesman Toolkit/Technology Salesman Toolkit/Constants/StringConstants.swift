//
//  StringConstants.swift
//  Technology Salesman Toolkit
//
//  Created by Bram De Coninck on 15/01/2019.
//  Copyright © 2019 Bram De Coninck. All rights reserved.
//

import Foundation

struct StringConstants {
    
    // LoginViewController
    static let titleLoginAlert = "Aanmelden"
    
    // RegistrationViewController
    static let titleRegistrationAlert = "Account aanmaken"
    static let messageVerificationEmailSent = "Uw account werd succesvol aangemaakt en er werd een bevestigingsmail naar uw e-mailadres verzonden."
    
    // SettingsViewController
    static let titleSettingsSignOutAlert = "Afmelden"
    static let messageSignOut = "Bent u zeker dat u zich wilt afmelden?"
    
    // ProfileViewController
    static let titleProfileEditProfileAlert = "Profiel wijzigen"
    static let titleProfileChangePasswordAlert = "Wachtwoord wijzigen"
    static let messageEditProfile = "Bent u zeker dat u uw profiel wilt wijzigen?"
    static let messageChangePassword = "Bent u zeker dat u uw wachtwoord wilt wijzigen? Als u op 'Ja' drukt, zal er een e-mail verzonden worden waarmee uw wachtwoord opnieuw ingesteld kan worden."
    static let succesNameChange = "Uw naam werd succesvol gewijzigd."
    static let succesEmailAddressChange = "Uw e-mailadres werd succesvol gewijzigd."
    static let messageChangePasswordEmailSent = "Er werd een e-mail verzonden naar uw e-mailadres waarmee u uw wachtwoord kunt wijzigen."
    
    // Alerts
    static let alertOk = "Oké"
    static let alertYes = "Ja"
    static let alertNo = "Nee"
    
    // Errors
    static let errorUnexpected = "Er is een onverwachte fout opgetreden tijdens het aanmelden."
    static let errorAccountNotCreated = "Er is iets fout opgetreden tijdens het aanmaken van uw account."
    static let errorNameNotChanged = "Er is een fout opgetreden tijdens het wijzigen van uw naam."
    static let errorEmailAddressNotChanged = "Er is een onverwachte fout opgetreden tijdens het wijzigen van uw e-mailadres."
    static let errorChangePasswordEmailNotSent = "Er is een onverwachte fout opgetreden tijdens het versturen van de mail voor het wijzigen van uw wachtwoord."
    
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
