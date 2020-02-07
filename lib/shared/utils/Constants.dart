import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_luggage_free/CouponSelection/model/Coupon.dart';
import 'package:go_luggage_free/more/FAQ.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';

String sentryDSN = "https://3c62b1ab40344f35803a04da958e7b6f@sentry.io/1851321";

String productionUrl = "https://apis.goluggagefree.com/";

String testUrl = "http://test.goluggagefree.com/";

String baseUrl = testUrl;

String imageBaseUrl = baseUrl;

String logInUrl = baseUrl + "users/login";

String razorPayCallbackUrl = baseUrl + "api/confirmAppPayment";

String signUpUrl = baseUrl + "users";

String getTokensForBooking = baseUrl + "api/getApplicableCoupons";

String payForBooking = baseUrl + "api/payFor/";

String forgotPasswordOtpGenerate = baseUrl + "users/forgotPasswordOTP";

String resetPassword = baseUrl + "users/resetPassword";

String getMapMyIndiaToken = baseUrl + "api/getMapMyIndiaAccessToken";

// While making an api call to this end-point, you will have to add /{storageSpace.id}/book
String makeBooking = baseUrl + "api/bookings/";

String formDataLoggingUrl = "https://hooks.slack.com/services/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";

Color buttonColor = HexColor("#0078FF");

Color disabledButtonColor = Colors.grey;

Color cursorColor = Colors.grey;

Color lightGrey = HexColor("#F5F5F5");

Coupon selectedCoupon = null;

bool isAppInTestingMode = true;

List<String> completeListOfUserGovtIdTypes = [
  "AADHAR",
  "Driving License",
  "Passport",
  "Voter Id",
  "Other"
];

/* List<String> currencies = [
  "INR",
  "USD"
]; */

String versionCodeHeader = "3.0";

String userName = "UserName";

// Please don't remove this form key. This is here to solve a major bug faced in the booking form page
//  Will shift it to its right place as soon as I find out where this is supposed to be :)
final GlobalKey<FormState> formKey = new GlobalKey();
final TextEditingController nameController = new TextEditingController(text: "");
final TextEditingController govtIdNumber = new TextEditingController(text: "");
final TextEditingController checkInController = new TextEditingController(text: "");
final TextEditingController checkOutController = new TextEditingController(text: "");
int numberOfBags = 1;
int numberOfDays = 0;
int price = 0;