import 'dart:async';

import 'package:buhms/app/providers/providers.dart';
import 'package:buhms/features/authentication/domain/user.dart';
import 'package:buhms/features/booking/domain/booking.dart';
import 'package:buhms/features/home/data/user_repo.dart';
import 'package:buhms/features/maintenance/data/maintenance_repo.dart';
import 'package:buhms/features/maintenance/presentation/states/maintenance_request_states.dart';
import 'package:buhms/features/rooms/domain/room.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class MaintenanceRequestNotifier extends Notifier<MaintenanceRequestState> {
  late MaintenanceRepoImpl maintenanceRepoImpl;
  late UserRepoImpl userRepoImpl;
  @override
  MaintenanceRequestState build() {
    maintenanceRepoImpl = ref.read(maintenanceRepoImplProvider);
    userRepoImpl = ref.read(userRepoImplProvider);
    return const MaintenanceRequestState.loading();
  }

  Future<void> getMaintenanceRequests() async {
    state = const MaintenanceRequestState.loading();
    final userId =
        ref.read(supabaseClientProvider).auth.currentSession!.user.id;
    final res =
        await maintenanceRepoImpl.getMaintenanceRequests(userId: userId);
    state = res.fold((l) {
      return MaintenanceRequestState.failed(message: l);
    }, (r) {
      return MaintenanceRequestState.successful(response: r);
    });
  }

  Future<String> getStaffName(String staffId) async {
    final getIt = ref.read(getItProvider);
    final supabase = getIt<SupabaseClient>();
    final res = await supabase
        .from('staffs')
        .select('first_name, last_name')
        .eq('id', staffId);
    final name = '${res[0]['last_name']} ${res[0]['first_name']}';
    return name;
  }

  Future<void> submitMaintenanceRequest(
    String description,
    String title,
  ) async {
    state = const MaintenanceRequestState.loading();
    final userId =
        ref.read(supabaseClientProvider).auth.currentSession!.user.id;
    final roomRes = await _getUserRoom();
    final roomId = roomRes.roomId;
    final res = await maintenanceRepoImpl.createMaintenanceRequest(
      userid: userId,
      roomId: roomId,
      description: description,
      title: title,
    );
    state = res.fold((l) {
      return MaintenanceRequestState.failed(message: l);
    }, (r) {
      return MaintenanceRequestState.successful(response: r);
    });
  }

  Future<RoomInfo> _getUserRoom() async {
    final supabase = ref.read(supabaseClientProvider);
    final userId =
        ref.read(supabaseClientProvider).auth.currentSession!.user.id;
    final response = await supabase
        .from('room_occupants')
        .select('room_id')
        .eq('user_id', userId);
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
    return decodedRoom;
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
        //   debugPrint(data.userId);
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

final maintenanceRequestProvider =
    NotifierProvider<MaintenanceRequestNotifier, MaintenanceRequestState>(
  MaintenanceRequestNotifier.new,
);
