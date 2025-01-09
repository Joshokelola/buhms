import 'package:auto_route/auto_route.dart';
import 'package:buhms/app/router/app_router.gr.dart';
import 'package:buhms/features/maintenance/presentation/controllers/maintenance_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ComplaintSubmissionPage extends ConsumerStatefulWidget {
  const ComplaintSubmissionPage({super.key});

  @override
  ConsumerState<ComplaintSubmissionPage> createState() =>
      _ComplaintSubmissionPageState();
}

//TODO: There should be a page where we can view maintenance requests made. Then its from that page we get a button that allows us to create a new maintenance request.
class _ComplaintSubmissionPageState
    extends ConsumerState<ComplaintSubmissionPage> {
  final _formKey = GlobalKey<FormState>();

  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _roomController = TextEditingController();

  static const primaryBlue = Color(0xFF009ECE);
  static const bgColor = Color(0xFFF5F7FA);
  static const textDark = Color(0xFF333333);
  static const inputBg = Color(0xFFF0F2F5);

  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement complaint submission logic
      await ref
          .read(maintenanceRequestProvider.notifier)
          .submitMaintenanceRequest(
            _descriptionController.text,
            _subjectController.text,
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint submitted successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(maintenanceRequestProvider, (previous, next) {
      next.maybeWhen(
        orElse: () => null,
        successful: (requests) {
          context.replaceRoute(const MaintenancePage());
        },
        failed: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message!.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.replaceRoute(const MaintenancePage());
        },
      );
    });
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                margin: const EdgeInsets.symmetric(vertical: 32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ref.watch(maintenanceRequestProvider).maybeWhen(
                      orElse: _complaintForm,
                      loading: () {
                        return AbsorbPointer(
                          child: Stack(
                            children: [
                              _complaintForm(),
                              Container(
                                color: Colors.black12,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Form _complaintForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const Text(
            'Submit Complaint',
            style: TextStyle(
              color: primaryBlue,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Please provide details about your complaint',
            style: TextStyle(color: textDark),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          const SizedBox(height: 16),

          // Subject Field
          TextFormField(
            controller: _subjectController,
            decoration: InputDecoration(
              labelText: 'Subject',
              hintText: 'Brief title of your complaint',
              filled: true,
              fillColor: inputBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a subject';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Description Field
          TextFormField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText:
                  'Please provide detailed information about your complaint',
              filled: true,
              fillColor: inputBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Room Number Field
          TextFormField(
            controller: _roomController,
            decoration: InputDecoration(
              labelText: 'Room Number (if applicable)',
              hintText: 'Enter your room number if complaint is room-related',
              filled: true,
              fillColor: inputBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Submit Button
          ElevatedButton(
            onPressed: _submitComplaint,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (ref.watch(maintenanceRequestProvider).maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    )) {
                  return Colors.grey[400];
                }
                return states.contains(WidgetState.disabled)
                    ? Colors.grey[400]
                    : const Color(
                        0xFF3498DB,
                      );
              }),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            child: ref.watch(maintenanceRequestProvider).maybeWhen(
                  orElse: () => const Text(
                    'SUBMIT COMPLAINT',
                    style: TextStyle(color: Colors.white),
                  ),
                  loading: () => const CircularProgressIndicator(),
                ),
          ),
          const SizedBox(height: 16),

          // View Complaints Link
          Center(
            child: TextButton(
              onPressed: () {
                // TODO: Navigate to complaints history
              },
              child: const Text(
                'View My Complaint History →',
                style: TextStyle(color: primaryBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    _roomController.dispose();
    super.dispose();
  }
}
