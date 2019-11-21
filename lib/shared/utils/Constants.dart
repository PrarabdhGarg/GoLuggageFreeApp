import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';

String baseUrl = "https://api.goluggagefree.com/";

String imageBaseUrl = baseUrl + "media/image/";

String logInUrl = baseUrl + "users/login";

String razorPayCallbackUrl = "api/confirmPayment/KLkajafj3434jaf";

String signUpUrl = baseUrl + "users";

String getTokensForBooking = baseUrl + "api/getApplicableCoupons";

// While making an api call to this end-point, you will have to add /{storageSpace.id}/book
String makeBooking = baseUrl + "api/bookings";

Color buttonColor = HexColor("#0078FF");

Color disabledButtonColor = Colors.grey;

Color cursorColor = Colors.grey;

Color lightGrey = HexColor("#F5F5F5");