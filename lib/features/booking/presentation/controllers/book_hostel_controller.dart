// ignore_for_file: strict_raw_type

import 'package:buhms/app/providers/providers.dart';
import 'package:buhms/features/authentication/domain/user.dart';
import 'package:buhms/features/booking/data/book_hostel_repo.dart';
import 'package:buhms/features/booking/domain/booking.dart';
import 'package:buhms/features/booking/presentation/controllers/states/book_hostel_state.dart';
import 'package:buhms/features/booking/presentation/controllers/states/book_room_states.dart';
import 'package:buhms/features/home/data/user_repo.dart';
import 'package:buhms/features/rooms/domain/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookHostelNotifier extends Notifier<BookHostelState> {
  late BookHostelRepoImpl bookHostelRepoImpl;
  @override
  BookHostelState build() {
    bookHostelRepoImpl = ref.read(bookHostelProvider);
    _initializeData();
    return const BookHostelState.initial();
  }

  Future<void> _initializeData() async {
    await getHostels();
  }

  Future<void> getHostels() async {
    state = const HostelBookingState.loading();
    final res = await bookHostelRepoImpl.getHostels(
      userId: ref.read(supabaseClientProvider).auth.currentSession!.user.id,
    );
    state = res.fold((l) {
      return HostelBookingState.error(message: l);
    }, (r) {
      return HostelBookingState.successful(data: r);
    });
  }

  Future<bool> checkIfUserHasRoom() async {
    final res = await bookHostelRepoImpl.checkIfUserHasRoom(
      userId: ref.read(supabaseClientProvider).auth.currentSession!.user.id,
    );
    return res.fold((l) {
      return false;
    }, (r) {
      return r;
    });
  }

  Future<void> bookRoom(String roomId) async {
    state = const BookHostelState.loading();
    final res = await bookHostelRepoImpl.bookRoom(
      roomId: roomId,
      userId: ref.read(supabaseClientProvider).auth.currentSession!.user.id,
    );
    state = res.fold((l) {
      return BookHostelState.error(message: l);
    }, (r) {
      return BookHostelState.successful(data: r);
    });
  }
}

class BookRoomNotifier extends Notifier<BookRoomState> {
  late BookHostelRepoImpl bookHostelRepoImpl;
  @override
  BookRoomState build() {
    bookHostelRepoImpl = ref.read(bookHostelProvider);
    return const BookRoomState.initial();
  }

  Future<void> getRoomsAvailablePerHostel(String hostelId) async {
    state = const BookRoomState.loading();
    final res = await bookHostelRepoImpl.getRoomsAvailableByHostel(
      userId: ref.read(supabaseClientProvider).auth.currentSession!.user.id,
      hostelId: hostelId,
    );
    state = res.fold((l) {
      return BookRoomState.error(message: l);
    }, (r) {
      return BookRoomState.successful(data: r);
    });
  }
}

class SearchRoomNotifier extends Notifier<AsyncValue<RoomInfo>> {
  late UserRepoImpl userRepoImpl;
  @override
  AsyncValue<RoomInfo> build() {
    userRepoImpl = ref.read(userRepoImplProvider);
    return AsyncValue.data(RoomInfo.defaultRoom());
  }

  Future<void> getRoomInfo(String roomId, String hostelName) async {
    state = const AsyncLoading();
    final supabase = ref.read(supabaseClientProvider);
    final res = await supabase.from('rooms').select().eq('id', roomId);
    final decodedRes = res[0];
    // final getHostelName = supabase.from('hostels').select().eq('hostel_name', decodedRes['hostel_'])
    final decodedRoom = RoomInfo(
      roomId: decodedRes['id'] as String,
      capacity: decodedRes['capacity'] as int,
      hostelId: decodedRes['hostel_id'] as String,
      roomNumber: decodedRes['room_number'].toString(),
      roomMembers: await _getRoomOccupants(decodedRes['id'] as String),
      hostelName: hostelName,
    );
    // Logger().i(decodedRoom);
    state = AsyncData(decodedRoom);
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

final searchRoomResultNotifierProvider =
    NotifierProvider<SearchRoomNotifier, AsyncValue<RoomInfo>>(
  SearchRoomNotifier.new,
);

final userRoomStatusProvider = FutureProvider<bool>((ref) async {
  final controller = ref.read(bookHostelNotifierProvider.notifier);
  return controller.checkIfUserHasRoom();
});

final bookHostelNotifierProvider =
    NotifierProvider<BookHostelNotifier, BookHostelState>(
  BookHostelNotifier.new,
);
final selectRoomProvider =
    NotifierProvider<BookRoomNotifier, BookRoomState>(BookRoomNotifier.new);
