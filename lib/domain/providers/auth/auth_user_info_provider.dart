import 'package:oppenhomies/domain/models/user/user_model.dart';
import 'package:oppenhomies/domain/providers/auth/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_user_info_provider.g.dart';

@riverpod
class AuthUserInfo extends _$AuthUserInfo {
  late final AuthRepository _repository;

  @override
  Future<UserModel?> build() async {
    _repository = ref.read(authRepositoryProvider);
    return _getUserModel();
  }

  Future<UserModel?> _getUserModel() async {
    final userInfo = await _repository.getUserInfo();
    return userInfo;
  }

  Future<bool> deposit(double amount) async {
    final res = await _repository.deposit(amount);
    refresh();
    return res;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_getUserModel);
  }
}
