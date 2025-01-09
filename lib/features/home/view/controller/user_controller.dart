import 'package:buhms/app/providers/providers.dart';
import 'package:buhms/features/booking/data/book_hostel_repo.dart';
import 'package:buhms/features/home/data/user_repo.dart';
import 'package:buhms/features/home/view/controller/states/user_states.dart';
import 'package:buhms/features/rooms/data/room_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileNotifier extends Notifier<UserProfileState> {
  late UserRepoImpl userRepoImpl;
  late BookHostelRepoImpl bookHostelRepoImpl;
  late RoomRepo roomRepo;
  @override
  UserProfileState build() {
    userRepoImpl = ref.read(userRepoImplProvider);
    roomRepo = ref.read(roomRepoProvider);
    return const UserProfileState.initial();
  }

  Future<void> getUserProfile() async {
    state = const UserProfileState.loading();
    final res = await userRepoImpl.getStudentProfile(
      userId: ref.read(supabaseClientProvider).auth.currentSession!.user.id,
    );
    // final testing = await roomRepo.getUserHostel(
    //     userId: ref.read(supabaseClientProvider).auth.currentSession!.user.id,);
    state = res.fold((l) {
      return UserProfileState.error(message: l);
    }, (r) {
      return UserProfileState.loaded(response: r);
    });
  }
}

final userNotifierProvider =
    NotifierProvider<UserProfileNotifier, UserProfileState>(
  UserProfileNotifier.new,
);
