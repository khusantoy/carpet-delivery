class Order {
  final String id;
  final Client client;
  final String status;
  final String address;

  Order({
    required this.id,
    required this.client,
    required this.status,
    required this.address,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        client: Client.fromJson(json['client']),
        status: json['status'],
        address: json['address']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "client": client.toJson(),
      "status": status,
      "address": address
    };
  }
}

class Client {
  final String fullName;
  final String phoneNumber;
  final double latitude;
  final double longitude;

  Client({
    required this.fullName,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "full_name": fullName,
      "phone_number": phoneNumber,
      "latitude": latitude,
      "longitude": longitude
    };
  }
}
