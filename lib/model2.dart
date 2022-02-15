class UserDetail {
  final int? id;
  final String? name;
  final String? username;
  final String? email;
  final Addres? address;
  final String? phone;
  final String? website;
  final Company? company;

  UserDetail(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.address,
      this.phone,
      this.website,
      this.company});
  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return new UserDetail(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      address: Addres.fromJson(json['address']),
      phone: json['phone'],
      website: json['website'],
      company: Company.fromJson(json['company']),
    );
  }

  // UserDetail(this.id, this.name, this.username, this.email);
}

class Addres {
  final String? street;
  final String? suite;
  final String? city;
  final String? zipCode;

  Addres({this.street, this.suite, this.city, this.zipCode});

  factory Addres.fromJson(Map<String, dynamic> json) {
    return new Addres(
      street: json['street'],
      suite: json['suite'],
      city: json['city'],
      zipCode: json['zipcode'],
    );
  }
}

class Company {
  final String? name;
  final String? catchParase;
  final String? bs;

  Company({this.name, this.catchParase, this.bs});
  factory Company.fromJson(Map<String, dynamic> json) {
    return new Company(
      name: json['name'],
      catchParase: json['catchPhrase'],
      bs: json['bs'],
    );
  }
}
