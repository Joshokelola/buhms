import 'package:auto_route/annotations.dart';
import 'package:buhms/features/authentication/domain/user.dart';
import 'package:buhms/features/rooms/presentation/controllers/room_controller.dart';
import 'package:buhms/features/rooms/presentation/widgets/details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class RoomDetailsPage extends ConsumerStatefulWidget {
  const RoomDetailsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RoomDetailsPageState();
}

class _RoomDetailsPageState extends ConsumerState<RoomDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(roomNotifierProvider.notifier).getUserRoom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Room Header Card
              Container(
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
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ref.watch(roomNotifierProvider).maybeWhen(
                      orElse: () {
                        return const Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF009ECE),
                          ),
                        );
                      },
                      data: (data) {
                        return Text(
                          'Room ${data.roomNumber}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF009ECE),
                          ),
                        );
                      },
                    ),
                    ref.watch(roomNotifierProvider).maybeWhen(
                      orElse: () {
                        return const CircularProgressIndicator();
                      },
                      data: (data) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: data.capacity == 0
                                ? Colors.red.withOpacity(0.5)
                                : const Color(0xFF4CAF50).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            data.capacity == 0 ? 'Not Available' : 'Available',
                            style: TextStyle(
                              color: data.capacity == 0
                                  ? Colors.red
                                  : const Color(0xFF4CAF50),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Room Information Card
              ref.watch(roomNotifierProvider).maybeWhen(
                orElse: () {
                  return const DetailCard(
                    title: 'Room Information',
                    details: [
                      DetailItem(label: 'Hostel', value: 'Loading...'),
                      DetailItem(label: 'Room Capacity', value: 'Loading...'),
                      DetailItem(
                        label: 'Current Occupants',
                        value: 'Loading...',
                      ),
                    ],
                  );
                },
                data: (data) {
                  return Column(
                    children: [
                      DetailCard(
                        title: 'Room Information',
                        details: [
                          DetailItem(label: 'Hostel', value: data.hostelName),
                          DetailItem(
                            label: 'Room Capacity',
                            value: data.capacity.toString(),
                          ),
                          DetailItem(
                            label: 'Current Occupants',
                            value:
                                '${data.roomMembers.length}/${data.capacity + data.roomMembers.length}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      DetailCard(
                        title: 'Current Occupants',
                        child: OccupantsList(
                          occupants: data.roomMembers,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OccupantsList extends StatelessWidget {
  const OccupantsList({required this.occupants, super.key});
  final List<Student?> occupants;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Add a height constraint to prevent overflow
      child: ListView.builder(
        itemCount: occupants.length,
        itemBuilder: (context, index) {
          final occupant = occupants[index];
          if (occupant != null) {
            return OccupantItem(
              name: '${occupant.lastName}  ${occupant.firstName}',
              studentId: occupant.matricNumber,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class OccupantItem extends StatelessWidget {
  const OccupantItem({
    required this.name,
    required this.studentId,
    super.key,
  });
  final String name;
  final String studentId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Student ID: $studentId',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
