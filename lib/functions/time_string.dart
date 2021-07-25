String timeString(List<int> time) {
  return '${time[0] < 10 ? "0${time[0]}" : time[0]}' +
      ' : ' +
      '${time[1] < 10 ? "0${time[1]}" : time[1]}';
}
