class UserInfom {
  String? uid;
  String? email;
  String? fullname;
  String? username;

  UserInfom({this.uid, this.email,this.fullname, this.username,});

  factory UserInfom.fromMap(map){
    return UserInfom(
        uid: map['uid'],
        email: map['email'],
        fullname: map['fullname'],
        username: map['username'],
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'username': username,
    };
  }
}