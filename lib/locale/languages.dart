import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get language;

  String get badRequest;

  String get forbidden;

  String get pageNotFound;

  String get tooManyRequests;

  String get internalServerError;

  String get badGateway;

  String get serviceUnavailable;

  String get gatewayTimeout;

  String get hey;

  String get hello;

  String get thisFieldIsRequired;

  String get contactNumber;

  String get gallery;

  String get camera;

  String get editProfile;

  String get update;

  String get reload;

  String get address;

  String get viewAll;

  String get pressBackAgainToExitApp;

  String get invalidUrl;

  String get cancel;

  String get delete;

  String get deleteAccountConfirmation;

  String get demoUserCannotBeGrantedForThis;

  String get somethingWentWrong;

  String get yourInternetIsNotWorking;

  String get profileUpdatedSuccessfully;

  String get wouldYouLikeToSetProfilePhotoAs;

  String get yourOldPasswordDoesnT;

  String get yourNewPasswordDoesnT;

  String get location;

  String get yes;

  String get no;

  String get submit;

  String get firstName;

  String get lastName;

  String get changePassword;

  String get yourNewPasswordMust;

  String get password;

  String get newPassword;

  String get confirmNewPassword;

  String get email;

  String get mainStreet;

  String get toResetYourNew;

  String get stayTunedNoNew;

  String get noNewNotificationsAt;

  String get signIn;

  String get explore;

  String get settings;

  String get rateApp;

  String get aboutApp;

  String get logout;

  String get rememberMe;

  String get forgotPassword;

  String get forgotPasswordTitle;

  String get registerNow;

  String get createYourAccount;

  String get createYourAccountFor;

  String get signUp;

  String get alreadyHaveAnAccount;

  String get yourPasswordHasBeen;

  String get youCanNowLog;

  String get done;

  String get pleaseAcceptTermsAnd;

  String get deleteAccount;

  String get eG;

  String get merry;

  String get doe;

  String get welcomeBackToThe;

  String get welcomeToThe;

  String get doYouWantToLogout;

  String get appTheme;

  String get guest;

  String get notifications;

  String get newUpdate;

  String get anUpdateTo;

  String get isAvailableGoTo;

  String get later;

  String get closeApp;

  String get updateNow;

  String get signInFailed;

  String get userCancelled;

  String get appleSigninIsNot;

  String get eventStatus;

  String get eventAddedSuccessfully;

  String get notRegistered;

  String get signInWithGoogle;

  String get signInWithApple;

  String get orSignInWith;

  String get ohNoYouAreLeaving;

  String get oldPassword;

  String get oldAndNewPassword;

  String get personalizeYourProfile;

  String get themeAndMore;

  String get showSomeLoveShare;

  String get privacyPolicyTerms;

  String get securelyLogOutOfAccount;

  String get termsOfService;

  String get successfully;

  String get clearAll;

  String get notificationDeleted;

  String get doYouWantToRemoveNotification;

  String get doYouWantToClearAllNotification;

  String get doYouWantToRemoveImage;

  String get locationPermissionDenied;

  String get enableLocation;

  String get permissionDeniedPermanently;

  String get chooseYourLocation;

  String get setAddress;

  String get sorryUserCannotSignin;

  String get iAgreeToThe;

  String get logIn;

  String get country;

  String get selectCountry;

  String get state;

  String get selectState;

  String get city;

  String get pinCode;

  String get selectCity;

  String get addressLine;

  String get searchHere;

  String get noDataFound;

  String get pending;

  String get completed;

  String get confirmed;

  String get cancelled;

  String get rejected;

  String get checkIn;

  String get checkout;

  String get reject;

  String get processing;

  String get delivered;

  String get placed;

  String get inProgress;

  String get paid;

  String get failed;

  String get approved;

  String get doYouWantToCancelBooking;

  String get aboutSelf;

  String get appliedTaxes;

  String get appointment;

  String get online;

  String get inClinic;

  String get patient;

  String get doctor;

  String get payment;

  String get videoCallLinkIsNotFound;

  String get thisIsNotAOnlineService;

  String get oppsThisAppointmentIsNotConfirmedYet;

  String get oppsThisAppointmentHasBeenCancelled;

  String get oppsThisAppointmentHasBeenCompleted;

  String get dateTime;

  String get appointmentType;

  String get searchAppoinmentHere;

  String get noClinicsFoundAtAMoment;

  String get looksLikeThereIsNoClinicsWellKeepYouPostedWhe;

  String get searchDoctorHere;

  String get searchPatientHere;

  String get noPatientFound;

  String get oppsNoPatientFoundAtMomentTryAgainLater;

  String get searchServiceHere;

  String get noServiceFound;

  String get oppsNoServiceFoundAtMomentTryAgainLater;

  String get filterBy;

  String get clearFilter;

  String get doYouWantToPerformThisAction;

  String get statusHasBeenUpdated;

  String get sessionSummary;

  String get clinicInfo;

  String get doctorInfo;

  String get patientInfo;

  String get aboutService;

  String get encounterDetails;

  String get doctorName;

  String get active;

  String get closed;

  String get clinicName;

  String get description;

  String get usersMustClearPaymentBeforeAccessingCheckout;

  String get paymentDetails;

  String get price;

  String get discount;

  String get off;

  String get subtotal;

  String get tax;

  String get total;

  String get appointments;

  String get noAppointmentsFound;

  String get thereAreCurrentlyNoAppointmentsAvailable;

  String get resetYourPassword;

  String get enterYourEmailAddressToResetYourNewPassword;

  String get sendCode;

  String get edit;

  String get gender;

  String get profile;

  String get clinics;

  String get manageClinics;

  String get manageSessions;

  String get changeOrAddYourSessions;

  String get doctors;

  String get manageDoctors;

  String get requests;

  String get requestForServiceCategoryAndSpecialization;

  String get receptionists;

  String get allReceptionist;

  String get encounters;

  String get manageEncouterData;

  String get userNotCreated;

  String get pleaseSelectRoleToLogin;

  String get pleaseSelectRoleToRegister;

  String get pleaseSelectClinicToRegister;

  String get chooseYourRole;

  String get demoAccounts;

  String get notAMember;

  String get registerYourAccountForBetterExperience;

  String get selectUserRole;

  String get selectClinic;

  String get termsConditions;

  String get and;

  String get privacyPolicy;

  String get areYouSureYouWantTonupdateTheService;

  String get save;

  String get allCategory;

  String get noCategoryFound;

  String get editClinic;

  String get addClinic;

  String get clinicImage;

  String get chooseImageToUpload;

  String get chooseSpecialization;

  String get searchForSpecialization;

  String get specialization;

  String get timeSlot;

  String get chooseCountry;

  String get searchForCountry;

  String get chooseState;

  String get searchForState;

  String get chooseCity;

  String get searchForCity;

  String get postalCode;

  String get latitude;

  String get longitude;

  String get writeHere;

  String get status;

  String get pleaseSelectAClinicImage;

  String get addBreak;

  String get editBreak;

  String get selectTime;

  String get startDateMustBeBeforeEndDate;

  String get endDateMustBeAfterStartDate;

  String get breakTimeIsOutsideShiftTime;

  String get lblBreak;

  String get clinicSessions;

  String get noSessionsFound;

  String get oppsNoSessionsFoundAtMomentTryAgainLater;

  String get unavailable;

  String get sessions;

  String get clinicSessionsInformation;

  String get services;

  String get serviceAvaliable;

  String get doctorsAvaliable;

  String get photosAvaliable;

  String get clinicDetail;

  String get readMore;

  String get readLess;

  String get clinicGalleryDeleteSuccessfully;

  String get noGalleryFoundAtAMoment;

  String get looksLikeThereIsNoGalleryForThisClinicWellKee;

  String get pleaseSelectImages;

  String get noClinicsFound;

  String get addNewClinic;

  String get areYouSureYouWantToDeleteThisClinic;

  String get clinicDeleteSuccessfully;

  String get totalAppointments;

  String get totalServices;

  String get totalPatient;

  String get totalEarning;

  String get welcomeBack;

  String get totalDoctors;

  String get doYouWantToPerformThisChange;

  String get statusUpdatedSuccessfully;

  String get chooseClinic;

  String get pleaseChooseClinic;

  String get oppsNoClinicsFoundAtMomentTryAgainLater;

  String get change;

  String get analytics;

  String get youDontHaveAnyServicesnPleaseAddYourServices;

  String get addService;

  String get recentAppointment;

  String get yourService;

  String get patients;

  String get noPatientsFound;

  String get oppsNoPatientsFoundAtMomentTryAgainLater;

  String get patientDetail;

  String get appointmentsTillNow;

  String get payoutHistory;

  String get noPayout;

  String get oppsLooksLikeThereIsNoPayoutsAvailable;

  String get addReceptionist;

  String get selectClinicCenters;

  String get noReceptionistsFound;

  String get oppsNoReceptionistsFoundAtMomentTryAgainLater;

  String get addRequest;

  String get name;

  String get selectType;

  String get requestList;

  String get noRequestsFound;

  String get oppsNoRequestsFoundAtMomentTryAgainLater;

  String get changePrice;

  String get assignDoctor;

  String get priceUpdatedSuccessfully;

  String get charges;

  String get doctorsAssignSuccessfully;

  String get pleaseSelectClinic;

  String get searchForClinic;

  String get noDoctorsFound;

  String get looksLikeThereAreNoDoctorsAvilableToAssign;

  String get socialMedia;

  String get revenue;

  String get yearly;

  String get service;

  String get searchClinicHere;

  String get home;

  String get payouts;

  String get editDoctor;

  String get addDoctor;

  String get aboutMyself;

  String get experienceSpecializationContactInfo;

  String get doctorSessionsInformation;

  String get noServicesTillNow;

  String get oopsThisDoctorDoesntHaveAnyServicesYet;

  String get reviews;

  String get noReviewsTillNow;

  String get oopsThisDoctorDoesntHaveAnyReviewsYet;

  String get qualification;

  String get qualificationDetailIsNotAvilable;

  String get qualificationInDetail;

  String get year;

  String get degree;

  String get university;

  String get by;

  String get breaks;

  String get noWeekListFound;

  String get oppsNoWeekListFoundAtMomentTryAgainLater;

  String get addDayOff;

  String get assignClinics;

  String get oppsNoDoctorFoundAtMomentTryAgainLater;

  String get sessionSavedSuccessfully;

  String get doctorSession;

  String get selectDoctor;

  String get pleaseSelectDoctor;

  String get allSession;

  String get addSession;

  String get noDoctorSessionFound;

  String get thereAreCurrentlyNoDoctorSessionAvailable;

  String get oppsNoReviewFoundAtMomentTryAgainLater;

  String get noServicesFound;

  String get oppsNoServicesFoundAtMomentTryAgainLater;

  String get invoice;

  String get encounter;

  String get totalPayableAmountWithTax;

  String get discountAmount;

  String get servicePrice;

  String get contactInfo;

  String get experience;

  String get about;

  String get myProfile;

  String get doctorDetail;

  String get areYouSureYouWantToDeleteThisDoctor;

  String get doctorDeleteSuccessfully;

  String get noQualificationsFound;

  String get looksLikeThereAreNoQualificationsAddedByThisD;

  String get addEncounter;

  String get fillPatientEncounterDetails;

  String get dateIsNotSelected;

  String get date;

  String get chooseDoctor;

  String get choosePatient;

  String get searchForPatient;

  String get bodyChart;

  String get imageDetails;

  String get reset;

  String get imageTitle;

  String get imageDescription;

  String get pleaseUploadTheImage;

  String get patientName;

  String get lastUpdate;

  String get noBodyChartsFound;

  String get oppsNoBodyChartsFoundAtMomentTryAgainLater;

  String get areYouSureYouWantToDeleteThisBodyChart;

  String get editPrescription;

  String get addPrescription;

  String get frequency;

  String get duration;

  String get instruction;

  String get noNotesAdded;

  String get chooseOrAddNotes;

  String get writeNotes;

  String get add;

  String get notes;

  String get observations;

  String get chooseOrAddObservation;

  String get writeObservation;

  String get noObservationAdded;

  String get otherInformation;

  String get write;

  String get prescription;

  String get noPrescriptionAdded;

  String get days;

  String get problems;

  String get chooseOrAddProblems;

  String get writeProblem;

  String get noProblemAdded;

  String get clinicalDetail;

  String get moreInformation;

  String get patientHealthInformation;

  String get showBodyChartRelatedInformation;

  String get viewReport;

  String get showReportRelatedInformation;

  String get billDetails;

  String get showBillDetailsRelatedInformation;

  String get clinic;

  String get encounterDate;

  String get unpaid;

  String get totalPrice;

  String get enterDiscount;

  String get enterPayableAmount;

  String get paymentStatus;

  String get toCloseTheEncounterInvoicePaymentIsMandatory;

  String get noInvoiceDetailsFound;

  String get oppsNoInvoiceDetailsFoundAtMomentTryAgainLate;

  String get invoiceDetail;

  String get noInvoiceFound;

  String get oppsNoInvoiceFoundAtMomentTryAgainLater;

  String get generateInvoice;

  String get invoiceId;

  String get patientDetails;

  String get editMedicalReport;

  String get addMedicalReport;

  String get uploadMedicalReport;

  String get pleaseUploadAMedicalReport;

  String get medicalReports;

  String get thereIsNoMedicalReportsAvilableAtThisMoment;

  String get noMedicalReportsFound;

  String get areYouSureYouWantToDeleteThisMedicalReport;

  String get medicalReportDeleteSuccessfully;

  String get noEncountersFound;

  String get areYouSureYouWantToDeleteThisEncounter;

  String get totalClinic;

  String get subjectiveObjectiveAssessmentAndPlan;

  String get noteTheAcronymSoapStandsForSubjectiveObjectiv;

  String get subjective;

  String get objective;

  String get assessment;

  String get plan;

  String get clearAllFilters;

  String get apply;

  String get reportDetails;

  String get yearIsRequired;

  String get enterAValidYearBetween1900And;

  String get pleaseEnterYourDegree;

  String get pleaseEnterDegree;

  String get pleaseEnterUniversity;

  String get selectYear;

  String get somethingWentWrongPleaseTryAgainLater;

  String get advancePayableAmount;

  String get advancePaidAmount;

  String get remainingPayableAmount;

  String get addYourSignature;

  String get verifyWithEaseYourDigitalMark;

  String get clear;

  String get doctorImage;

  String get serviceTotal;

  String get expert;

  String get percent;

  String get fixed;

  String get discoutValue;

  String get editDiscount;

  String get addDiscount;

  String get totalAmount;

  String get addBillingItem;

  String get serviceImage;

  String get editService;

  String get great;

  String get bookingSuccessful;

  String get yourAppointmentHasBeenBookedSuccessfully;

  String get totalPayment;

  String get goToAppointments;

  String get addAppointment;

  String get selectService;

  String get chooseDate;

  String get noTimeSlotsAvailable;

  String get chooseTime;

  String get asPerDoctorCharges;

  String get remainingAmount;

  String get refundableAmount;

  String get version;

  String get passwordLengthShouldBe8To14Characters;

  String get theConfirmPasswordAndPasswordMustMatch;

  String get chooseCommission;

  String get searchForCommission;

  String get noCommissionFound;

  String get commission;

  String get selectServices;

  String get facebookLink;

  String get instagramLink;

  String get twitterLink;

  String get dribbleLink;

  String get signature;

  String get addNew;

  String get pleaseSelectADoctorImage;

  String get remove;

  String get degreecertification;

  String get noReviewsFoundAtAMoment;

  String get looksLikeThereIsNoReviewsWellKeepYouPostedWhe;

  String get addNewDoctor;

  String get bodyChartDeleteSuccessfully;

  String get editBillingItem;

  String get quantity;

  String get areYouSureYouWantToDeleteThisBillingItem;

  String get pleaseWaitWhileItsLoading;

  String get billingItemRemovedSuccessfully;

  String get closeCheckoutEncounter;

  String get file;

  String get serviceName;

  String get serviceDurationMin;

  String get defaultPrice;

  String get chooseCategory;

  String get searchForCategory;

  String get category;

  String get enterDescription;

  String get pleaseSelectAServiceImage;

  String get sServices;

  String get bookedForWithColon;

  String get bookedFor;

  String get dateOfBirth;

  String get pleaseAddService;

  String get editReceptionist;

  String get receptionistDeleteSuccessfully;

  String get lblCancelBooking;

  String get areYouSureYou;

  String get totalCancellationFee;

  String get reason;

  String get enterReason;

  String get goBack;

  String get bookingCancelled;

  String get yourBookingHasBeen;

  String get noteCheckYourBooking;

  String get appliedInclusiveTaxes;

  String get includesInclusiveTax;

  String get inclusiveTaxes;

  String get inclusiveTax;

  String get appliedExclusiveTaxes;

  String get exclusiveTax;

  String encounterWithId(int id);

  String get cancelAppointment;

  String cancellationFeesWillBeAppliedIfYouCancelWithinHoursOfScheduledTime(String hours, bool isCancellationChargesEnabled);

  String get continueText;

  String get wouldYouLikeToProceedAndConfirmPayment;

  String get cancellationFee;

  String get yourAppointmentHasBeenSuccessfullyCancelled;

  String get appointmentRefundWillBeProcessedWithingHoursIfApplicable;

  String get noteCheckYourAppointmentHistoryForRefundDetailsIfApplicable;

  String get ok;

  String get hintReason;

  String get confirm;

  String get medicalHistory;

  String get selectMedicine;

  String get pleaseEnterValidEmail;

  String get pleaseEnterOTP;

  String get passwordMustIncludeSpacialCharacter;

  String get passwordMustIncludeAtLeastOneLowercaseCharacter;

  String get passwordMustIncludeAtLeastOneNumber;

  String get passwordMustIncludeAtLeastOneCapitalCharacter;

  String get addFile;

  String get optional;

  String get reply;

  String get passwordIsRequired;

  String get passwordDoesNotMeetRequirements;

  String get passwordTooShort;

  String get tryToAnotherWay;

  String get pleaseEnterValid6digitOTP;

  String get otpFromAuthenticatorApp;

  String get otp;

  String get verify;

  String get updateTo;

  String get aVertionUpdateIsAvailable;

  String get available;

  String get inAppUpdate;

  String get emailRequired;

  String get encounterId;

  String get goToHistory;

  String get viewCommissions;

  String get addMedicalHistory;

  String get addFiles;

  String get readAll;

  String get otherDetails;

  String get selectedFileShouldBeLessThan5MB;

  String get dosage;

  String get form;

  String get viewAndManageTheListOfServicesYouProvide;

  String get manageServices;

  String get supportedFormat;

  String get noFileSelected;

  String get areYouSureYouWantToDeleteThisReceptionist;

  String get open;

  String get close;

  String get medicineInfo;

  String get supplierInfo;

  String get inventoryInfo;

  String get medicineNameHint;

  String get dosageHint;

  String get selectCategory;

  String get chooseMedicineForm;

  String get searchForMedicineForm;

  String get selectMedicineForm;

  String get addStock;

  String get lowStock;

  String get expiryDate;

  String get viewDetail;

  String get totalMedicine;

  String get topMedicine;

  String get expiredMedicine;

  String get lowStockMedicine;

  String get totalRevenue;

  String get todaysPrescription;

  String get dateAndTime;

  String get bookingInfo;

  String get prescriptionStatus;

  String get addMedicine;

  String get addExtraMedicineForPatient;

  String get addExtraMedicine;

  String get upcomingExpiryMedicine;

  String get appointmentDateAndTime;

  String get prescriptionDateAndTime;

  String get encounterStatus;

  String get prescriptionPaymentStatus;

  String get medicineCategory;

  String get medicineStockUpdated;

  String get noTopMedicineFound;

  String get oopsNoTopMedicines;

  String get noExpiredMedicineFound;

  String get oopsNoExpiredMedicines;

  String get noLowStockMedicinesFound;

  String get oopsNoLowStockMedicines;

  String get noMedicineFound;

  String get oopsNoMedicinesFound;

  String get newPrescription;

  String get basicInventoryDetail;

  String get reorderLevel;

  String get otherDetail;

  String get chooseManufacturer;

  String get searchForManufacturer;

  String get selectManufacturer;

  String get addManufacturer;

  String get manufacturerName;

  String get batchNumber;

  String get startSerialNumber;

  String get endSerialNumber;

  String get pricing;

  String get purchasePrice;

  String get sellingPrice;

  String get stockValue;

  String get editMedicine;

  String get form1;

  String get passwordLength;

  String get medicines;

  String get topMedicines;

  String get expiredMedicines;

  String get lowStockMedicines;

  String get selectMedicines;

  String get expiring;

  String get stock;

  String get expired;

  String get paymentTerms;

  String get supplierList;

  String get aboutMedicine;

  String get medicineDetail;

  String get suppliers;

  String get searchMedicine;

  String get showResult;

  String get filter;

  String get editMedicineStock;

  String get addNewMedicineStock;

  String get previous;

  String get next;

  String get areYousureYouWantToRemove;

  String get isRemovedSuccessfully;

  String get chooseSupplier;

  String get searchForSupplier;

  String get selectSupplier;

  String get paymentTermsInDays;

  String get medicineTotal;

  String get searchMedicineHere;

  String get searchPrescriptionHere;

  String get prescriptionInfo;

  String get medicineTotalInc;

  String get male;

  String get female;

  String get other;

  String get manufacturerAddedSuccessfully;

  String get expiryDate1;

  String get medicineAddedToStockSuccessfully;

  String get editSupplier;

  String get addNewSupplier;

  String get supplierImage;

  String get personalDetails;

  String get chooseSupplierType;

  String get searchForSupplierType;

  String get selectSupplierType;

  String get pleaseSelectAnSupplierImage;

  String get searchSupplierHere;

  String get allSuppliers;

  String get pleaseSelectDeliveryDate;

  String get pleaseEnterQuantity;

  String get deliveryDate;

  String get addQuantity;

  String get addOrder;

  String get bookingStatus;

  String get areYouSureYouWantToRemoveSupplier;

  String get manageSupplier;

  String get enterTheManufacturerName;

  String get orders;

  String get manageOrders;

  String get noSuppliersFound;

  String get allOrders;

  String get allPurchaseOrder;

  String get noOrdersFound;

  String get egMedicines;

  String get medicineName;

  String get aboutManufacturer;

  String get order;

  String get aboutSupplier;

  String get orderPlacedSuccessfully;

  String get noPrescriptionFound;

  String get sellingPriceCannotLess;

  String get editOrder;

  String get pleaseSelectAtLeastOneFilterOption;

  String get areYouSureWantToDeleteOrder;

  String get areYouSureWantToDeleteSupplier;

  String get topSupplier;

  String get selectPharmaForMedicine;

  String get choosePharma;

  String get searchForPharma;

  String get quantityCannotBeNegative;

  String get quantityExceedsAvailableStock;

  String get unit;

  String get advancePaid;

  String get advanceRefunded;

  String get refunded;

  String get medicinesAddedSuccessfully;

  String get supplierDetails;

  String get aboutOrder;

  String get orderDate;

  String get selectPharma;

  String get youHaveNotPlacedAnyOrder;

  String get changePaymentStatus;

  String get changeOrderStatus;

  String get orderStatus;

  String get pleaseSelectSupplierType;

  String get complete;

  String get payNow;

  String get supplierType;

  String get medicineUsage;

  String get stockHistory;

  String get noStockHistoryFound;

  String get noStockHistoryAvailableAtMoment;

  String stockNotEnoughAvailable(String availableStock);

  String get pharma;

  String get managePharma;

  String get allPharma;

  String get editPharma;

  String get addNewPharma;

  String get pharmaImage;

  String get noPharmaFound;

  String get manage;

  // Bed Type Strings
  String get bedType;

  String get bedStatus;

  String get totalBeds;

  String get occupied;

  String get bedAssign;

  String get deleteBed;

  String get manageBedTypes;

  String get search;

  String get enterBedTypeName;

  String get allBedType;

  String get noBedTypesFound;

  String get bedTypeLabel;

  String get noDescriptionAvailable;

  String get filterFunctionalityNotImplemented;

  String get saveFunctionalityNotImplemented;

  String get info;

  String get newBed;

  String get bed;

  String get bedTypeRequired;

  String get bedCapacity;

  String get underMaintenance;

  String get addBedType;

  String get editBedType;

  String get deleteBedType;

  String get deleteConfirmation;

  String get searchBedTypeHint;

  String get allBeds;

  String get searchHint;

  String get noBedsFound;

  String get bedCharges;

  String get capacity;

  String get bedAssignedSuccessfully;

  String get bedAssignedFailed;

  String get bedUpdatedSuccessfully;

  String get bedUpdatedFailed;

  String get editBedAssignment;

  String get selectPatientError;

  String get selectBedTypeError;

  String get selectRoomError;

  String get invalidBedTypeError;

  String get pleaseEnterBedTypeName;

  String get bedTypeAddedSuccessfully;

  String get bedTypeUpdatedSuccessfully;

  // Bed Management Add/Edit Strings
  String get addBed;

  String get editBed;

  String get bedNameLabel;

  String get bedUnavailable;

  String get pleaseEnterBedName;

  String get pleaseSelectBedType;

  String get chargesLabel;

  String get pleaseEnterBedCharges;

  String get pleaseEnterValidAmount;

  String get bedCapacityLabel;

  String get pleaseEnterCapacity;

  String get pleaseEnterValidNumber;

  String get statusLabel;

  String get underMaintenanceLabel;

  String get descriptionLabel;

  String get updateBed;

  String get noBedTypesAvailable;

  String get selectBedTypeTitle;

  String get searchBedTypeHintText;

  String get weightLabel;

  String get heightLabel;

  String get bloodPressureLabel;

  String get heartRateLabel;

  String get bloodGroupLabel;

  String get temperatureLabel;

  String get symptomsLabel;

  String get pleaseEnterValidWeight;

  String get pleaseEnterValidHeight;

  String get pleaseEnterValidHeartRate;

  String get pleaseEnterValidTemperature;

  String get pleaseEnterValidBloodPressure;

  String get pleaseEnterValidBloodGroup;

  String get bedDetails;

  String get viewAssignedBedDetails;

  String get assignBed;

  String get assignBedToPatient;

  String get chooseEncounter;

  String get searchForEncounter;

  String get pleaseSelectPatient;

  String get selectRoom;

  String get room;

  String get admissionDate;

  String get dischargeDate;

  // Bed Management
  String get areYouSureYouWantToDeleteThisBed;

  String get areYouSureYouWantToDeleteThisBedType;

  String get roomNumber;

  String get assignDate;

  String get bedPrice;
  // IPD (In-Patient Department)
  String get ipdInPatientDepartment;

  String get perDay;

  String get pleaseSelectAdmissionDateFirst;

  String get pleaseSelectBed;

  String get couldNotFindBedId;

  // Add for bed status widget
  String get noAvailableBeds;

  String get bedTypeEditedSuccessfully;

  String get bedTypeSavedSuccessfully;

  String get bedEditedSuccessfully;

  String get bedSavedSuccessfully;
}
