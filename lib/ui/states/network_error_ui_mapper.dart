import 'dart:async';
import 'dart:io';

import 'package:bobmoo/core/exceptions/network_exceptions.dart';
import 'package:bobmoo/ui/states/error_ui_model.dart';
import 'package:flutter/material.dart';

class NetworkErrorUiMapper {
  static ErrorUiModel toUiModel(Object error) {
    final exception = _normalize(error);

    final description = switch (exception) {
      NoConnectivityException() => "인터넷 연결을 확인해주세요.",
      RequestTimeoutException() =>
        "서버가 밥 먹다가 체했나 봐요 ㅠㅠ\n팀원들이 긴급 심폐소생술 중입니다!\n조금 있다가 다시 와주세요 🙏",
      HttpStatusException(statusCode: final code) => switch (code) {
          503 => "서버가 잠시 바빠요.\n조금 있다가 다시 시도해주세요.",
          502 => "서버 연결이 원활하지 않아요.\n잠시 후 다시 시도해주세요.",
          500 => "서버 오류가 발생했어요.\n잠시 후 다시 시도해주세요.",
          _ => "서버 오류가 발생했어요.\n잠시 후 다시 시도해주세요.",
        },
      _ => "알 수 없는 오류가 발생했습니다.",
    };

    return ErrorUiModel(
      description: description,
      icon: switch (exception) {
        RequestTimeoutException() => Icons.schedule_rounded,
        NoConnectivityException() => Icons.wifi_off_rounded,
        HttpStatusException() => Icons.cloud_off_rounded,
        NetworkException() => Icons.error_outline_rounded,
        _ => Icons.error_outline_rounded,
      },
      actionLabel: "다시 한 번 찔러보기",
    );
  }

  static Object _normalize(Object error) {
    if (error is NetworkException) return error;
    if (error is TimeoutException) return const RequestTimeoutException();
    if (error is SocketException) return const NoConnectivityException();
    return error;
  }
}

