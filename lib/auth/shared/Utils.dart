class Validators {
  static String passwordValidator(String password) {
    if(password == null) return "Enter non-null Password";
    if(password.isEmpty) return "Password cannot be empty";
    if(password.length < 7) return "Password should be of atlest 8 characters";
    return null;
  }

  static String phoneValidator(String phone) {
    if(phone == null) return "Enter non-null Phone number";
    if(phone.isEmpty) return "Phone number is required";
    // if(phone.length != 10) return "Enter 10 digit number";
    // if(!(RegExp(r'^-?[0-9]+$').hasMatch(phone))) return "Invalid";
    return null;
  }

  static String emailValidator(String email) {
    if(email == null) return "Enter non-null Email";
    if(email.isEmpty) return "Email is Required";
    if(email.length<=3) return "Enter a valid Email";
    if(!email.contains('@')) return "Enter a valid Email";
    if(!email.contains('.')) return "Enter a valid email";
    if(!(RegExp( r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$").hasMatch(email))) return "Invalid";
    return null;
  }

  static String nameValidator(String name) {
    if(name == null) return "Enter non-null name";
    if(name.isEmpty) return "Name cannot be blank";
    if(name.length == 1) return "Enter a valid name";
    if(!(RegExp(r'^[a-zA-Z]+$').hasMatch(name))) return "Invalid";
    if(name.length > 30) return "Too long"; 
    return null;
  }

  static String govtIdValidator(String govtId) {
    return null;
  }

  static String otpValidator(String otp) {
    if(otp == null) return "Enter non-null OTP";
    if(otp.isEmpty) return "Enter a non-empty otp";
    if(otp.length != 6) return "Invalid";
    if(!(RegExp(r'^-?[0-9]+$').hasMatch(otp))) return "OTP is numeric only";
    return null;
  }
}