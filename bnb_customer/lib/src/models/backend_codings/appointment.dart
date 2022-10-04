class AppointmentStatus {
  static const requested = "requested";
  static const active = "active";
  static const pending = "pending";
  static const cancelled = "cancelled";
  static const completed = "completed";
  //  customer didn't show up
  static const noShow = "noShow";
  //  customer's appointment is doing on
  static const checkedIn = "checkedIn";
}

///contains all the actions possible on an appointment
class AppointmentUpdates {
  static const createdByCustomer = "createdByCustomer";
  static const createdBySalon = "createdBySalon";
  static const changedByCustomer = "changedByCustomer";
  static const changedBySalon = "changedBySalon";
  static const cancelledByCustomer = "cancelledByCustomer";
  static const cancelledBySalon = "cancelledBySalon";
}

class AppointmentType {
  static const reservation = "reservation";
  static const blockTime = "blockTime";
}

class CreatedBy {
  static const salon = 'salon';
  static const customer = 'customer';
}
