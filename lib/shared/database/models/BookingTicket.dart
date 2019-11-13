import 'dart:convert';

import 'package:go_luggage_free/shared/database/models/StorageSpace.dart';

BookingTicket bookingTicketFromJson(String str) => BookingTicket.fromJson(json.decode(str));

class BookingTicket {
    String id;
    String bookingId;
    StorageSpace storageSpace;
    double netStorageCost;
    String checkInTime;
    String checkOutTime;
    String bookingPersonName;
    int numberOfBags;
    int numberOfDays;
    String userGovtId;

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
        id: json["_id"].toString(),
        bookingId: json["bookingID"].toString(),
        storageSpace: StorageSpace.fromResponseForBookings(json["storageSpace"]),
        netStorageCost: double.parse(json["netStorageCost"].toString()),
        checkInTime: json["checkInTime"].toString(),
        checkOutTime: json["checkOutTime"].toString(),
        bookingPersonName: json["bookingPersonName"].toString(),
        numberOfBags: int.parse(json["numberOfBags"].toString()),
        numberOfDays: int.parse(json["numberOfDays"].toString()),
        userGovtId: json["userGovtId"].toString(),
    );
}