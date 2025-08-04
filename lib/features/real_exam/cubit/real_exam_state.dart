part of 'real_exam_cubit.dart';

enum ExamStatus { initial, loading, success, error, onBreak, finished }

class RealExamState {
  const RealExamState({
    this.status = ExamStatus.initial,
    this.examModel,
    this.bookmarkedStatuses = const {},
    this.noteStatuses = const {},
    this.breakEndTime,
    this.errorMessage,
    this.examResult,
    this.sectionEndTimes = const {},
  });

  factory RealExamState.fromJson(Map<String, dynamic> json) {
    return RealExamState(
      sectionEndTimes: Map<String, String>.from(
        json['sectionEndTimes'] ?? {},
      ).map((key, value) => MapEntry(int.parse(key), value)),
      status: ExamStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ExamStatus.initial,
      ),
      examModel: json['examModel'] != null
          ? StartRealExamModel.fromJson(json['examModel'])
          : null,
      bookmarkedStatuses:
          (json['bookmarkedStatuses'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(int.parse(key), value as bool),
          ) ??
          const {},
      noteStatuses:
          (json['noteStatuses'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(int.parse(key), value as bool),
          ) ??
          const {},
      breakEndTime: json['breakEndTime'] != null
          ? DateTime.parse(json['breakEndTime'])
          : null,
    );
  }
  final ExamStatus status;
  final StartRealExamModel? examModel;
  final Map<int, bool> bookmarkedStatuses;
  final Map<int, bool> noteStatuses;
  final DateTime? breakEndTime;
  final String? errorMessage;
  final FinishAnalysisExamModel? examResult;
  final Map<int, String> sectionEndTimes;

  RealExamState copyWith({
    ExamStatus? status,
    StartRealExamModel? examModel,
    Map<int, bool>? bookmarkedStatuses,
    Map<int, bool>? noteStatuses,
    DateTime? breakEndTime,
    String? errorMessage,
    bool clearBreakTime = false,
    FinishAnalysisExamModel? examResult,
    Map<int, String>? sectionEndTimes,
  }) {
    return RealExamState(
      status: status ?? this.status,
      examModel: examModel ?? this.examModel,
      bookmarkedStatuses: bookmarkedStatuses ?? this.bookmarkedStatuses,
      noteStatuses: noteStatuses ?? this.noteStatuses,
      breakEndTime: clearBreakTime ? null : breakEndTime ?? this.breakEndTime,
      errorMessage: errorMessage ?? this.errorMessage,
      examResult: examResult ?? this.examResult,
      sectionEndTimes: sectionEndTimes ?? this.sectionEndTimes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sectionEndTimes': sectionEndTimes.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
      'status': status.name,
      'examModel': examModel?.toJson(),
      'bookmarkedStatuses': bookmarkedStatuses.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
      'noteStatuses': noteStatuses.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
      'breakEndTime': breakEndTime?.toIso8601String(),
    };
  }

  List<Object?> get props => [sectionEndTimes];
}
