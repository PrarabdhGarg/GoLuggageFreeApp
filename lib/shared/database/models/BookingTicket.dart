import 'dart:convert';

import 'package:go_luggage_free/shared/database/models/StorageSpace.dart';

class BookingTickets {
  List<BookingTicket> list;

  BookingTickets(this.list);

  factory BookingTickets.fromMap(List<dynamic> listOfDynamic) {
    List<BookingTicket> newList = new List();
    if(listOfDynamic.isNotEmpty) {
      listOfDynamic.forEach((item) {
        print("Converting item = ${item.toString()}");
        newList.add(BookingTicket.fromJson(item));
      });
    }
    newList.sort((a,b) => a.createdAt.compareTo(b.createdAt));
    return new BookingTickets(newList);
  }
}

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
    String createdAt;

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
        this.createdAt,
    });

// TODO Change capital or small capital D to small D
// TODO Change hard-coded booking id
    factory BookingTicket.fromJson(Map<String, dynamic> json) => BookingTicket(
        id: json["_id"].toString() ?? "",
        bookingId: json["bookingId"].toString() ?? "",
        storageSpace: StorageSpace.fromResponseForBookings(json["storageSpace"]),
        netStorageCost: double.parse(json["netStorageCost"].toString()) ?? 0.0,
        checkInTime: json["checkInTime"].toString() ?? "",
        checkOutTime: json["checkOutTime"].toString() ?? "",
        bookingPersonName: json["bookingPersonName"].toString() ?? "",
        numberOfBags: int.parse(json["numberOfBags"].toString()) ?? "",
        numberOfDays: int.parse(json["numberOfDays"].toString()) ?? "",
        userGovtId: json["userGovtId"].toString() ?? "",
        createdAt: json["createdAt"].toString() ?? "",
    );

// TODO Change capital or small capital D to small D
// TODO Change hard-coded booking id
    factory BookingTicket.fromDatabaseResult(Map<String, dynamic> json, StorageSpace storageSpace) => BookingTicket(
        id: json["_id"].toString() ?? "",
        bookingId: json["bookingId"].toString() ?? "",
        storageSpace: storageSpace,
        netStorageCost: double.parse(json["netStorageCost"].toString()) ?? 0.0,
        checkInTime: json["checkInTime"].toString() ?? "",
        checkOutTime: json["checkOutTime"].toString() ?? "",
        bookingPersonName: json["bookingPersonName"].toString() ?? "",
        numberOfBags: int.parse(json["numberOfBags"].toString()) ?? '',
        numberOfDays: int.parse(json["numberOfDays"].toString()) ?? "",
        userGovtId: json["userGovtId"].toString() ?? "",
        createdAt: json["createdAt"].toString() ?? "",
    );

    Map<String, dynamic> toMap() => {
      "id": id,
      "bookingId": bookingId,
      "netStorageCost": netStorageCost,
      "checkInTime": checkInTime,
      "checkOutTime": checkOutTime,
      "bookingPersonName": bookingPersonName,
      "numberOfDays": numberOfDays,
      "numberOfBags": numberOfBags,
      "userGovtId": userGovtId,
      "storageSpaceId": storageSpace.id,
      "createdAt": createdAt,
    };
}