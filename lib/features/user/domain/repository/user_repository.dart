
import '../entity/user.dart';

abstract class UserRepository {
  Future<void> saveUser(User user);
  Future<User> getUser();
}