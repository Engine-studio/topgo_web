String phoneString(String phone) {
  return '+7 (${phone.substring(1, 4)}) ${phone.substring(4, 7)}' +
      '-${phone.substring(7, 9)}-${phone.substring(9)}';
}
