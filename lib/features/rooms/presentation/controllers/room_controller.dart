import 'package:buhms/app/providers/providers.dart';
import 'package:buhms/features/authentication/domain/user.dart';
import 'package:buhms/features/booking/domain/booking.dart';
import 'package:buhms/features/home/data/user_repo.dart';
import 'package:buhms/features/rooms/data/room_repo.dart';
import 'package:buhms/features/rooms/domain/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoomNotifier extends Notifier<AsyncValue<RoomInfo>> {
  late RoomRepo roomRepo;
  late UserRepoImpl userRepoImpl;
  @override
  AsyncValue<RoomInfo> build() {
    roomRepo = ref.read(roomRepoProvider);
    userRepoImpl = ref.read(userRepoImplProvider);
    return AsyncValue.data(RoomInfo.defaultRoom());
  }

  Future<void> getUserRoom() async {
    state = const AsyncLoading();
    final supabase = ref.read(supabaseClientProvider);
    final userId =
        ref.read(supabaseClientProvider).auth.currentSession!.user.id;
    final response = await supabase
        .from('room_occupants')
        .select('room_id')
        .eq('user_id', userId);
    if (response.isNotEmpty) {
      final roomId = response[0]['room_id'] as String;
      final getRoom = await supabase.from('rooms').select().eq('id', roomId);
      final room = getRoom[0];
      // Logger().i(room);
      final getHostelRes = await supabase
          .from('hostels')
          .select('hostel_name')
          .eq('id', room['hostel_id'] as String);
      // Logger().i(getHostelRes);
      final decodedRoom = RoomInfo(
        roomId: room['id'] as String,
        capacity: room['capacity'] as int,
        hostelId: room['hostel_id'] as String,
        roomNumber: room['room_number'].toString(),
        roomMembers: await _getRoomOccupants(room['id'] as String),
        hostelName: getHostelRes[0]['hostel_name'] as String,
      );
      state = AsyncData(decodedRoom);
      // final res = await roomRepo.getUserHostel(
      //   userId: ref.read(supabaseClientProvider).auth.currentSession!.user.id,
      // );
      // state = res.fold((l) {
      //   return AsyncValue.error(l, StackTrace.fromString(l.message));
      // }, (r) {
      //   return AsyncValue.data(r);
      // });
    } else {
      state = AsyncData(RoomInfo.defaultRoom());
    }
  }

  Future<List<Student?>> _getRoomOccupants(String roomId) async {
    final supabase = ref.read(supabaseClientProvider);
    // final res =
    //     await supabase.from('room_occupants').select().eq('room_id', roomId);
    // Logger().i(res);

    final res =
        await supabase.from('room_occupants').select().eq('room_id', roomId);
    final bookings = res.map((data) {
      return Booking(
        userId: data['user_id'] as String,
        roomId: data['room_id'] as String,
        checkInDate: DateTime.parse(data['check_in_date'] as String),
      );
    }).toList();

    final roomOccupants = await Future.wait(
      bookings.map((data) async {
        debugPrint(data.userId);
        final getStudentRes =
            await userRepoImpl.getStudentProfile(userId: data.userId);
        final getStudentProfile = getStudentRes.fold((l) {
          return null;
        }, (r) {
          return r;
        });
        return getStudentProfile;
      }).toList(),
    );
    return roomOccupants;
  }
}

final roomNotifierProvider =
    NotifierProvider<RoomNotifier, AsyncValue<RoomInfo>>(RoomNotifier.new);
