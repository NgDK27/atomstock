import 'package:oppenhomies/domain/models/user/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:oppenhomies/domain/providers/auth/auth_repository.dart';

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
    if (await _repository.hasValidToken()) {
      final userInfo = await _repository.getUserInfo();
      return userInfo;
    } else {
      return null;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_getUserModel);
  }
}