import 'dart:convert';

import 'package:go_luggage_free/shared/database/models/StorageSpace.dart';

BookingTicket bookingTicketFromJson(String str) => BookingTicket.fromJson(json.decode(str));

class BookingTicket {
    String id;
    dynamic bookingId;
    StorageSpace storageSpace;
    String netStorageCost;
    String checkInTime;
    String checkOutTime;
    dynamic bookingPersonName;
    int numberOfBags;
    String numberOfDays;
    dynamic userGovtId;

    BookingTicket({
        this.id,
        this.bookingId,
        this.storageSpace,
        this.netStorageCost,
        this.checkInTime,
        this.checkOutTime,
        this.bookingPersonName,
        this.numberOfBags,
        this.numberOfDays,
        this.userGovtId,
    });

    factory BookingTicket.fromJson(Map<String, dynamic> json) => BookingTicket(
        id: json["_id"],
        bookingId: json["bookingID"],
        storageSpace: StorageSpace.fromResponseForBookings(json["storageSpace"]),
        netStorageCost: json["netStorageCost"],
        checkInTime: json["checkInTime"],
        checkOutTime: json["checkOutTime"],
        bookingPersonName: json["bookingPersonName"],
        numberOfBags: json["numberOfBags"],
        numberOfDays: json["numberOfDays"],
        userGovtId: json["userGovtId"],
    );
}