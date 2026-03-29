import 'package:edumate/core/exceptions/api_exception.dart';
import 'package:edumate/data/models/profile_models.dart';
import 'package:edumate/data/repositories/profile_repository.dart';
import 'package:flutter/material.dart';

class ProfileSessionState {
  final Profile? profile;
  final List<Child> children;
  final bool isLoading;
  final String? errorMessage;

  const ProfileSessionState({
    required this.profile,
    required this.children,
    required this.isLoading,
    required this.errorMessage,
  });

  const ProfileSessionState.initial()
      : profile = null,
        children = const [],
        isLoading = false,
        errorMessage = null;

  ProfileSessionState copyWith({
    Profile? profile,
    List<Child>? children,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileSessionState(
      profile: profile ?? this.profile,
      children: children ?? this.children,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ProfileProvider
    extends InheritedNotifier<ValueNotifier<ProfileSessionState>> {
  const ProfileProvider({
    super.key,
    required ValueNotifier<ProfileSessionState> notifier,
    required super.child,
  }) : super(notifier: notifier);

  static ValueNotifier<ProfileSessionState> of(
    BuildContext context, {
    bool listen = true,
  }) {
    final provider = listen
        ? context.dependOnInheritedWidgetOfExactType<ProfileProvider>()
        : context
            .getElementForInheritedWidgetOfExactType<ProfileProvider>()
            ?.widget as ProfileProvider?;

    assert(
      provider != null,
      'ProfileProvider not found. Wrap MaterialApp with ProfileProvider.',
    );

    return provider!.notifier!;
  }

  static ValueNotifier<ProfileSessionState>? ofOrNull(
    BuildContext context, {
    bool listen = true,
  }) {
    final provider = listen
        ? context.dependOnInheritedWidgetOfExactType<ProfileProvider>()
        : context
            .getElementForInheritedWidgetOfExactType<ProfileProvider>()
            ?.widget as ProfileProvider?;

    return provider?.notifier;
  }

  static Future<void> refresh(BuildContext context) async {
    final notifier = of(context, listen: false);
    await refreshNotifier(notifier);
  }

  static Future<void> refreshNotifier(
    ValueNotifier<ProfileSessionState> notifier,
  ) async {
    final current = notifier.value;

    notifier.value = current.copyWith(isLoading: true, clearError: true);

    final repo = ProfileRepository.create();

    try {
      final profile = await repo.getMyProfile();
      var children = List<Child>.from(profile.children);

      try {
        final childrenResponse = await repo.listChildren(limit: 100, offset: 0);
        children = childrenResponse.items;
      } on ApiException {
        // Keep embedded children from /profile/me as fallback.
      }

      notifier.value = notifier.value.copyWith(
        profile: profile,
        children: children,
        isLoading: false,
        clearError: true,
      );
    } on ApiException catch (e) {
      notifier.value = notifier.value.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } catch (e) {
      notifier.value = notifier.value.copyWith(
        isLoading: false,
        errorMessage: 'Không thể tải dữ liệu hồ sơ: $e',
      );
    }
  }

  static void clear(BuildContext context) {
    final notifier = of(context, listen: false);
    notifier.value = const ProfileSessionState.initial();
  }
}
