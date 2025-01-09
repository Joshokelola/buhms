import 'package:auto_route/annotations.dart';
import 'package:buhms/features/booking/presentation/controllers/book_hostel_controller.dart';
import 'package:buhms/features/rooms/domain/hostel.dart';
import 'package:buhms/features/rooms/domain/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class RoomAllocationView extends ConsumerStatefulWidget {
  const RoomAllocationView({super.key});

  @override
  RoomSearchPageState createState() => RoomSearchPageState();
}

class RoomSearchPageState extends ConsumerState<RoomAllocationView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(bookHostelNotifierProvider.notifier).getHostels();
    });
  }

  Hostel? selectedHostel;
  RoomInfo? selectedRoom;
  final TextEditingController roomNumberController = TextEditingController();
  bool showResults = false;

  // Sample data
  final List<String> blocks = ['Block A', 'Block B', 'Block C'];
  final List<String> floors = ['Ground Floor', 'First Floor', 'Second Floor'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 300, right: 300, top: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Room Search',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownForHostels(
                        'Hostel',
                        blocks,
                        selectedHostel,
                        (value) {
                          setState(() {
                            selectedHostel = value;
                            selectedRoom = null;
                          });
                          if (value != null) {
                            ref
                                .read(selectRoomProvider.notifier)
                                .getRoomsAvailablePerHostel(value.id);
                            // ref
                            //     .read(searchRoomResultNotifierProvider.notifier)
                            //     .getRoomOccupants(
                            //       selectedRoom!.roomId,
                            //     );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownForRoomsAvailable(
                        'Room Number',
                        floors,
                        selectedRoom,
                        (value) {
                          setState(() => selectedRoom = value);
                        },
                      ),
                    ),
                    // const SizedBox(width: 16),
                    // Expanded(
                    //   child: TextField(
                    //     controller: roomNumberController,
                    //     decoration: const InputDecoration(
                    //       labelText: 'Room Number',
                    //       border: OutlineInputBorder(),
                    //       contentPadding: EdgeInsets.symmetric(
                    //         horizontal: 12,
                    //         vertical: 16,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      //TODO - Enable this eventually

                      Future.microtask(() {
                        if (selectedRoom != null) {
                          ref
                              .read(searchRoomResultNotifierProvider.notifier)
                              .getRoomInfo(
                                selectedRoom!.roomId,
                                selectedHostel!.hostelName,
                              );

                          setState(() => showResults = true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Select A Room'),
                            ),
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text(
                      'Search Rooms',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ref.watch(searchRoomResultNotifierProvider).maybeWhen(
                  orElse: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                  data: (data) {
                    if (showResults) {
                      return _buildEnhancedSearchResult(data);
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownForRoomsAvailable(
    String label,
    List<String> items,
    RoomInfo? value,
    void Function(RoomInfo?) onChanged,
  ) {
    final rooms = ref.watch(selectRoomProvider);

    // Reset value if hostel changes or rooms load
    if (value != null &&
        rooms.maybeWhen(
          orElse: () => true,
          successful: (data) {
            if (data is List<RoomInfo>) {
              return !data.any((room) => room.roomId == value.roomId);
            }
            return true;
          },
        )) {
      Future.microtask(() => onChanged(null));
    }

    return DropdownButtonFormField<RoomInfo>(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: rooms.maybeWhen(
          orElse: () => null,
          loading: () => const SizedBox(
            height: 20,
            width: 20,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
        ),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      value: value, // Now we can safely include the value
      items: rooms.maybeWhen(
        orElse: () => [],
        loading: () => [],
        error: (_) => [],
        successful: (data) {
          if (data is List<RoomInfo>) {
            return data.map((RoomInfo room) {
              return DropdownMenuItem<RoomInfo>(
                value: room,
                child: Text('Room ${room.roomNumber}'),
              );
            }).toList();
          }
          return [];
        },
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildDropdownForHostels(
    String label,
    List<String> items,
    Hostel? value,
    void Function(Hostel?) onChanged,
  ) {
    final hostels = ref.watch(bookHostelNotifierProvider);

    // Reset value if it's not in the current list of hostels
    if (value != null &&
        hostels.maybeWhen(
          orElse: () => true,
          successful: (data) {
            if (data is List<Hostel>) {
              return !data.any((hostel) => hostel.id == value.id);
            }
            return true;
          },
        )) {
      // Reset the selected value if it's not in the list
      Future.microtask(() => onChanged(null));
    }

    return DropdownButtonFormField<Hostel>(
      decoration: InputDecoration(
        suffixIcon: hostels.maybeWhen(
          orElse: () => null,
          loading: () => const SizedBox(
            height: 20,
            width: 20,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
        ),
        hintText: 'Select Hostel',
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      //  value: value,
      items: hostels.maybeWhen(
        orElse: () => [],
        successful: (data) {
          if (data is List<Hostel>) {
            return data.map((Hostel hostel) {
              return DropdownMenuItem<Hostel>(
                value: hostel,
                child: Text(hostel.hostelName),
              );
            }).toList();
          }
          return [];
        },
        loading: () => [],
        error: (_) => [],
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildEnhancedSearchResult(RoomInfo room) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Room ${room.roomNumber}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF009ECE),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room.hostelName,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  //TODO -IMPLEMENT THIS
                  //  room.isAvailable
                  //     ? const Color(0xFF4CAF50).withOpacity(0.1)
                  //     : const Color(0xFFF44336).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  // room.isAvailable ? 'Available' : 'Occupied',
                  'Available',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    // room.isAvailable ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Capacity: ${room.capacity}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Current Occupants',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: room.roomMembers.length,
            itemBuilder: (context, index) {
              final occupant = room.roomMembers[index];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[200]!,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF009ECE).withOpacity(0.1),
                      child: Text(
                        occupant!.firstName[0] + occupant.lastName[0],
                        style: const TextStyle(
                          color: Color(0xFF009ECE),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${occupant.firstName} ${occupant.lastName}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          occupant.matricNumber,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF009ECE),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {},
            child: const Text(
              'Choose Room',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    roomNumberController.dispose();
    super.dispose();
  }
}
