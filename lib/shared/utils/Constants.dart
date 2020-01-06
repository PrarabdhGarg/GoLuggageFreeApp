import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_luggage_free/CouponSelection/model/Coupon.dart';
import 'package:go_luggage_free/more/FAQ.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';

String sentryDSN = "https://3c62b1ab40344f35803a04da958e7b6f@sentry.io/1851321";

String baseUrl = "https://api.goluggagefree.com/";

String imageBaseUrl = baseUrl;

String logInUrl = baseUrl + "users/login";

String razorPayCallbackUrl = baseUrl + "api/confirmAppPayment";

String signUpUrl = baseUrl + "users";

String getTokensForBooking = baseUrl + "api/getApplicableCoupons";

String payForBooking = baseUrl + "api/payFor/";

String forgotPasswordOtpGenerate = baseUrl + "users/forgotPasswordOTP";

String resetPassword = baseUrl + "users/resetPassword";

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

List<Question> faqs = [
  Question(
    question: "How do I manage my booking?",
    answer: "In case of changing the booking, asking for a refund or for any other issues related to your booking, you should contact our customer care."
  ),
  Question(
    question: "What are the cloakroom timings?",
    answer: "Most of our cloakrooms are open 24x7. Regardless, you can find the details of the individual cloakroom, including the timings on this app as well."
  ),
  Question(
    question: "How do I make a booking?",
    answer: "Every booking on GoLuggageFree happens through this mobile app only. This app can also be used to find cloakrooms near you."
  ),
  Question(
    question: "What kind of items can I store?",
    answer: "You can store your luggage, handbags, shopping bags, bagpacks, gym bags and pretty much anything as long as it is not harmful(read explosive)."
  ),
  Question(
    question: "Is my luggage safe?",
    answer: "We seal the luggage using a zip-tie with a unique code which makes it tamper proof. In case of loss of luggage specific to terms and conditions, we provide insurance upto Rs 5000."
  )
];

String versionCodeHeader = "3.0";

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