import 'package:flutter/material.dart';

abstract class ConditionalRender {
  ///
  ///
  /// === [SINGLE] ===
  ///
  ///
  static Widget single({
    required bool condition,
    required Widget Function() widget,
    required Widget Function() fallback,
  }) {
    if (condition) {
      return widget();
    } else {
      return fallback();
    }
  }

  ///
  ///
  /// === [LIST] ===
  ///
  ///
  static List<Widget> list({
    required bool condition,
    required List<Widget> Function() widget,
    required List<Widget> Function() fallback,
  }) {
    if (condition) {
      return widget();
    } else {
      return fallback();
    }
  }

  ///
  ///
  /// === [SWITCH SINGLE] ===
  ///
  ///
  static Widget switchSingle<T>({
    required T value,
    required Map<T, Widget Function()> cases,
    required Widget Function() fallback,
  }) {
    final widget = cases[value];

    if (widget != null) {
      return widget();
    } else {
      return fallback();
    }
  }

  ///
  ///
  /// === [SWITCH LIST] ===
  ///
  ///
  static List<Widget> switchList<T>({
    required T value,
    required Map<T, List<Widget> Function()> cases,
    required List<Widget> Function() fallback,
  }) {
    final widget = cases[value];

    if (widget != null) {
      return widget();
    } else {
      return fallback();
    }
  }
}
