import 'package:flutter_provider_architecture/model/user.dart';
import 'package:flutter_provider_architecture/provider_architecture/repository/api/ErrorResponse.dart';
import 'package:flutter_provider_architecture/provider_architecture/ui/base/base_model.dart';

class AboutUsViewModel extends BaseModel implements ErrorResponse {
  List<User> userList = [];

  AboutUsViewModel() {
    userList.clear();
    User user1 =
        new User(email: 'sameer.donga@gmail.com', id: '1', token: '9016789185');
    user1.firstName = 'Sameer';
    user1.lastName = 'Donga';
    user1.avatar = 'assets/sam.jpg';

    User user2 = new User(
        email: 'parth.vora@techypanther.com', id: '2', token: '9429734824');
    user2.firstName = 'Parth';
    user2.lastName = 'Vora';
    user2.avatar = 'assets/parth.png';
    userList.add(user1);
    userList.add(user2);
  }

  @override
  void serverMessage(String message, bool isError) {
    showMessage(message, isError);
    setState(ViewState.Idle);
  }
}
