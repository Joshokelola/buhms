import 'package:flutter/material.dart';

enum TestEnvironment {
  development,
  staging,
  beta,
  testing,
  prototype
}

class TestBannerPage extends StatelessWidget {
  
  const TestBannerPage({
    required this.child, super.key,
    this.environment = TestEnvironment.development,
    this.customMessage,
    this.showIcon = true,
    this.showVersion = false,
    this.version,
    this.persistent = true,
    this.onBannerTap,
  });
  final Widget child;
  final TestEnvironment environment;
  final String? customMessage;
  final bool showIcon;
  final bool showVersion;
  final String? version;
  final bool persistent;
  final VoidCallback? onBannerTap;

  Color get _bannerColor {
    switch (environment) {
      case TestEnvironment.development:
        return Colors.red.shade700;
      case TestEnvironment.staging:
        return Colors.orange.shade700;
      case TestEnvironment.beta:
        return Colors.blue.shade700;
      case TestEnvironment.testing:
        return Colors.purple.shade700;
      case TestEnvironment.prototype:
        return Colors.green.shade700;
    }
  }

  IconData get _environmentIcon {
    switch (environment) {
      case TestEnvironment.development:
        return Icons.code;
      case TestEnvironment.staging:
        return Icons.warning;
      case TestEnvironment.beta:
        return Icons.bug_report;
      case TestEnvironment.testing:
        return Icons.science;
      case TestEnvironment.prototype:
        return Icons.construction;
    }
  }

  String get _environmentText {
    if (customMessage != null) return customMessage!;
    
    switch (environment) {
      case TestEnvironment.development:
        return 'DEVELOPMENT BUILD';
      case TestEnvironment.staging:
        return 'STAGING ENVIRONMENT';
      case TestEnvironment.beta:
        return 'BETA VERSION';
      case TestEnvironment.testing:
        return 'TEST ENVIRONMENT';
      case TestEnvironment.prototype:
        return 'PROTOTYPE';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (persistent)
          _buildBanner()
        else
          _buildDismissibleBanner(),
      ],
    );
  }

  Widget _buildDismissibleBanner() {
    return DismissibleTestBanner(
      color: _bannerColor,
      icon: _environmentIcon,
      message: _environmentText,
      showIcon: showIcon,
      showVersion: showVersion,
      version: version,
      onTap: onBannerTap,
    );
  }

  Widget _buildBanner() {
    return PersistentTestBanner(
      color: _bannerColor,
      icon: _environmentIcon,
      message: _environmentText,
      showIcon: showIcon,
      showVersion: showVersion,
      version: version,
      onTap: onBannerTap,
    );
  }
}

class PersistentTestBanner extends StatelessWidget {

  const PersistentTestBanner({
    required this.color, required this.icon, required this.message, required this.showIcon, required this.showVersion, super.key,
    this.version,
    this.onTap,
  });
  final Color color;
  final IconData icon;
  final String message;
  final bool showIcon;
  final bool showVersion;
  final String? version;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showIcon) ...[
                    Icon(
                      icon,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  if (showVersion && version != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        version!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DismissibleTestBanner extends StatefulWidget {

  const DismissibleTestBanner({
    required this.color, required this.icon, required this.message, required this.showIcon, required this.showVersion, super.key,
    this.version,
    this.onTap,
  });
  final Color color;
  final IconData icon;
  final String message;
  final bool showIcon;
  final bool showVersion;
  final String? version;
  final VoidCallback? onTap;

  @override
  State<DismissibleTestBanner> createState() => _DismissibleTestBannerState();
}

class _DismissibleTestBannerState extends State<DismissibleTestBanner> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: widget.color,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.4),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Close button
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isVisible = false;
                        });
                      },
                    ),
                  ),
                  // Banner content
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.showIcon) ...[
                          Icon(
                            widget.icon,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        if (widget.showVersion && widget.version != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.version!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}