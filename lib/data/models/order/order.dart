class Order {
  final String id;
  final Client client;
  final String status;
  final String address;
  final String url;

  Order({
    required this.id,
    required this.client,
    required this.status,
    required this.address,
    required this.url,
  });

  Order copyWith({
    String? id,
    Client? client,
    String? status,
    String? address,
    String? url,
  }) {
    return Order(
      id: id ?? this.id,
      client: client ?? this.client,
      status: status ?? this.status,
      address: address ?? this.address,
      url: url ?? this.url,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      client: Client.fromJson(json['client']),
      status: json['status'],
      address: json['address'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "client": client.toJson(),
      "status": status,
      "address": address,
      "url": url,
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
