import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_luggage_free/shared/utils/Helpers.dart';

String baseUrl = "http://test.goluggagefree.com/";

String imageBaseUrl = baseUrl;

String logInUrl = baseUrl + "users/login";

String razorPayCallbackUrl = baseUrl + "api/confirmAppPayment";

String signUpUrl = baseUrl + "users";

String getTokensForBooking = baseUrl + "api/getApplicableCoupons";

// While making an api call to this end-point, you will have to add /{storageSpace.id}/book
String makeBooking = baseUrl + "api/bookings/";

Color buttonColor = HexColor("#0078FF");

Color disabledButtonColor = Colors.grey;

Color cursorColor = Colors.grey;

Color lightGrey = HexColor("#F5F5F5");

// Please don't remove this form key. This is here to solve a major bug faced in the booking form page
//  Will shift it to its right place as soon as I find out where this is supposed to be :)
final GlobalKey<FormState> formKey = new GlobalKey();
final TextEditingController nameController = new TextEditingController(text: "Prarabdh");
final TextEditingController govtIdNumber = new TextEditingController(text: "Helilajfaj");
final TextEditingController checkInController = new TextEditingController(text: "");
final TextEditingController checkOutController = new TextEditingController(text: "");