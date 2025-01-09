import 'package:auto_route/auto_route.dart';
import 'package:buhms/app/router/app_router.gr.dart';
import 'package:buhms/app/view/banner.dart';
import 'package:buhms/core/extensions/context_extensions.dart';
import 'package:buhms/features/booking/presentation/controllers/book_hostel_controller.dart';
import 'package:buhms/features/booking/presentation/new_allocation_page.dart';
import 'package:buhms/features/rooms/domain/hostel.dart';
import 'package:buhms/features/rooms/domain/room.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

@RoutePage()
class BookHostelPage extends ConsumerStatefulWidget {
  const BookHostelPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookHostelPageState();
}

class _BookHostelPageState extends ConsumerState<BookHostelPage> {
  String? selectedHostelName;
  String? selectedRoomId;
  @override
  Widget build(BuildContext context) {
    final hostelBookingState = ref.watch(bookHostelNotifierProvider);
    final selectRoomState = ref.watch(selectRoomProvider);
    final hasRoomState = ref.watch(userRoomStatusProvider);
    ref.listen(bookHostelNotifierProvider, (prev, next) {
      next.maybeWhen(
        orElse: () => null,
        successful: (data) {
          if (data is bool) {
            if (data) {
              Logger().i('Booking Successful');
              context.replaceRoute(const RoomDetailsPage());
            }
            //  context.
          }
        },
      );
    });

    return hasRoomState.when(
      data: (data) {
        if (!data) {
          return hostelBookingState.when(
            initial: () {
              return const Center(child: CircularProgressIndicator());
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
            error: (error) {
              return Center(
                child: Text(error!.message),
              );
            },
            successful: (data) {
              var hostels = <Hostel>[];

              if (data is List<Hostel>) {
                hostels = data;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Book Hostel'),
                  SizedBox(
                    height: context.defaultValue,
                  ),
                  Form(
                    child: Column(
                      children: [
                        DropdownButtonFormField<Hostel>(
                          decoration: const InputDecoration(
                            labelText: 'Select Hostel',
                            border: OutlineInputBorder(),
                          ),
                          items: hostels.map((Hostel hostel) {
                            return DropdownMenuItem<Hostel>(
                              value: hostel,
                              child: Text(hostel.hostelName),
                            );
                          }).toList(),
                          onChanged: (Hostel? selectedHostel) {
                            setState(() {
                              selectedHostelName = selectedHostel!.hostelName;
                            });
                            // Logger().i(selectedHostel.toString());
                            ref
                                .read(selectRoomProvider.notifier)
                                .getRoomsAvailablePerHostel(
                                  selectedHostel!.id,
                                );
                          },
                        ),
                        SizedBox(
                          height: context.defaultValue,
                        ),
                        if (selectedHostelName != null) ...[
                          Column(
                            children: [
                              selectRoomState.maybeWhen(
                                loading: () {
                                  return const CircularProgressIndicator();
                                },
                                orElse: () {
                                  return Container();
                                },
                                successful: (data) {
                                  var rooms = <RoomInfo>[];
                                  if (data is List<RoomInfo>) {
                                    rooms = data;
                                  }
                                  return DropdownButtonFormField<RoomInfo>(
                                    decoration: const InputDecoration(
                                      labelText: 'Select Room',
                                      border: OutlineInputBorder(),
                                    ),
                                    items: rooms.map((RoomInfo room) {
                                      return DropdownMenuItem<RoomInfo>(
                                        value: room,
                                        child: Text('Room ${room.roomNumber}'),
                                      );
                                    }).toList(),
                                    onChanged: (RoomInfo? roomInfo) {
                                      setState(() {
                                        selectedRoomId = roomInfo!.roomId;
                                      });
                                      // Logger().i(roomInfo.toString());
                                    },
                                  );
                                },
                              ),
                              SizedBox(
                                height: context.defaultValue,
                              ),
                              FilledButton(
                                onPressed: () {
                                  ref
                                      .read(
                                        bookHostelNotifierProvider.notifier,
                                      )
                                      .bookRoom(selectedRoomId!);
                                },
                                child: const Text('Submit'),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          // return const Center(
          //   child: Text('You have a room already'),
          // );
//TODO - REMOVE THIS CODE AND REPLACE WITH WIDGET THAT INFORMS USER THAT THEY HAVE SELECTED A ROOM
//POSSIBLY POINT THEM TO THE ROOM DETAILS PAGE WITH A BUTTON.
          return const TestBannerPage(
            child: RoomAllocationView(),
          );
        }
      },
      error: (_, __) {
        return const Center(
          child: Text('Error'),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
