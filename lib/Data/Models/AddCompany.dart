class Company {
  final String Companyname;
  final String Companyemail;
  final String Companyphone;
  final String Companypoc;
  final String Companystart;
  final String Companyend;


  Company({
    required this.Companyname,
    required this.Companyemail,
    required this.Companyphone,
    required this.Companypoc,
    required this.Companystart,
    required this.Companyend,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      Companyname: json['company_name'],
      Companyemail: json['company_email'],
      Companyphone: json['company_phone'],
      Companypoc: json['company_poc'],
      Companystart: json['company_start_date'],
      Companyend: json['company_end_date'],
    );
  }
}