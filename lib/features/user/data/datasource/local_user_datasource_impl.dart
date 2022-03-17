
import '../../domain/entity/user.dart';

abstract class LocalUserDataSource {
  Future<void> saveUser(User user);
  Future<User> getUser();
}