class MachineEvent {
  final String type;
  final Map<String, Object?> raw;

  MachineEvent(this.type, this.raw);

  factory MachineEvent.fromJson(Map<String, Object?> json) => MachineEvent(json['type'] as String, json);
}
