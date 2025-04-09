getTime({startTime, endTime, today}) {
  bool result = false;
  int startTimeInt = (startTime.hour * 60 + startTime.minute) * 60;
  int EndTimeInt = (endTime.hour * 60 + endTime.minute) * 60;
  int todayTimeInt = (today.hour * 60 + today.minute) * 60;
  int dif1 = todayTimeInt - startTimeInt;
  int dif2 = todayTimeInt - EndTimeInt;

  // print('resutl 1: ${dif1}');
  // print('result 2: ${dif2}');
  if (
        (
        startTimeInt < EndTimeInt &&
        todayTimeInt >= startTimeInt &&
        todayTimeInt <= EndTimeInt
        ) ||
        (
        startTimeInt > EndTimeInt && (
        todayTimeInt >= startTimeInt ||
        todayTimeInt <= EndTimeInt
        )
        )
) {
   return true;
} else {
    return false;
}
   
}
