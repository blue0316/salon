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

class ActiveAppointmentSubStatus {
  static const requested = "requested";
  //status is active and isrequested
  static const unConfirmed = "unConfirmed";

  //status is active and is upcomming but client hasn't confirmed
  static const confirmed = "confirmed";
//status is active and is upcomming and client has confirmed
  static const cancelledByCustomer = "cancelledByCustomer";
  static const cancelledBySalon = "cancelledBySalon";

  static const reviewed = "reviewed";
}

///contains all the actions possible on an appointment
class AppointmentUpdates {
  //created
  static const createdByCustomer = "createdByCustomer";
  static const createdBySalon = "createdBySalon";
  static const createdBySalonForMaster = "createdBySalonForMaster";
  static const createdBySalonMaster = "createdBySalonMaster";
  //update
  static const changedByCustomer = "changedByCustomer";
  static const changedBySalon = "changedBySalon";
  static const noShowBySalon = "noShowBySalon";
  static const changedBySalonMaster = "changedBySalonMaster";
  //cancelled
  static const cancelledByCustomer = "cancelledByCustomer";
  static const cancelledBySalon = "cancelledBySalon";
  static const completed = "completed";
  //request
  static const approvedBySalon = "approvedBySalon";
  static const confirmedBySalon = "confirmedBySalon";
  static const confirmedByCustomer = "confirmedByCustomer";
}

class AppointmentType {
  static const reservation = "reservation";
  static const cleanUpTime = "cleanUpTime";
  static const preparationTime = "preparationTime";
  static const blockTime = "blockTime";
}

class CreatedBy {
  static const salon = 'salon';
  static const customer = 'customer';
}
